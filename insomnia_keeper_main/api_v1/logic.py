import datetime
import json

import bit
import eth_account
from django.utils import timezone
from pytils.translit import slugify
from rest_framework import status
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
import redis
from .serializers import *


def extract_request_data(request):
    data = {}
    if request.data:
        data = {k: v for k, v in request.data.items()}
    elif request.query_params:
        data = {k: v for k, v in request.query_params.items()}
    data['meta'] = request.META.copy()
    return data


def get_multiple_files_from_data(data, prefix: str) -> List[Any]:
    files = []
    for key in data.keys():
        if key.startswith(prefix):
            files.append(data[key])
    return files


def get_now() -> datetime.datetime:
    return timezone.now()


def check_auth(access_status=None):
    def real_decorator(original_function):

        def wrapper(request, is_jwt=True):
            data = extract_request_data(request)
            profile = False
            if is_jwt:
                if request.auth:
                    if request.user:
                        if request.user.is_active:
                            if Profile.objects.filter(user=request.user, status='active'):
                                profile = Profile.objects.get(user=request.user, status='active')
            else:
                # Some auth checks if we need API token auth (not JWT)
                pass

            permissions_list = ['default', 'admin']
            if access_status in permissions_list and profile:
                for i, permission in enumerate(permissions_list):
                    if access_status == permission:
                        if profile.access_status in permissions_list[i:]:
                            return original_function(profile, data)
            elif access_status is None:
                return original_function(profile, data)

            return Response({
                'success': False,
            }, status=status.HTTP_403_FORBIDDEN)

        return wrapper

    return real_decorator


def send_auth_mail(
    template: str,
    user: User,
    email: str,
) -> None:
    """ Отправить email с ключем """

    def signup_func() -> Tuple[str, EmailVerification]:
        subject = 'Регистрация'
        EmailVerification.objects.filter(user=user).delete()
        key_model = EmailVerification.objects.create(user=user, new_email=email)
        return subject, key_model

    def reset_password_func() -> Tuple[str, ResetPasswordVerification]:
        subject = 'Сброс пароля'
        ResetPasswordVerification.objects.filter(user=user).delete()
        key_model = ResetPasswordVerification.objects.create(user=user)
        return subject, key_model

    def change_email_func() -> Tuple[str, ResetPasswordVerification]:
        subject = 'Смена email'
        EmailVerification.objects.filter(user=user).delete()
        key_model = EmailVerification.objects.create(user=user, new_email=email)
        return subject, key_model

    template_to_func = {
        'signup': signup_func,
        'reset-password': reset_password_func,
        'change-email': change_email_func,
    }

    subject, key_model = template_to_func[template]()
    data = {
        'key': key_model.key,
        'created': key_model.created,
    }
    if settings.LOCAL:
        print(key_model.key)
    else:
        send_mail(subject, template, email, data)


def key_verification(
    email: str,
    key: str
) -> Tuple[int, Dict]:
    """ Сверка ключа """
    if User.objects.filter(email=email):
        user = User.objects.get(email=email)
        if EmailVerification.objects.filter(user=user):
            key_model = EmailVerification.objects.get(user=user)
            new = key_model.new_email
            if str(key) == str(key_model.key):
                return status.HTTP_200_OK, {
                    'success': True,
                    'data': {
                        'key': key,
                        'new': new
                    }
                }
        if ResetPasswordVerification.objects.filter(user=user):
            key_model = ResetPasswordVerification.objects.get(user=user)
            if str(key) == str(key_model.key):
                return status.HTTP_200_OK, {
                    'success': True,
                    'data': {
                        'key': key
                    }
                }
    return status.HTTP_401_UNAUTHORIZED, {
        'success': False
    }


def get_global():
    if Global.objects.filter(active=True) and Rules.objects.filter(active=True):

        fixed = Global.objects.get(active=True)
        rules = Rules.objects.get(active=True)

        global_data = GlobalSerializer(fixed).data
        global_data['static_url'] = settings.STATIC_URL
        global_data['rules'] = rules.content

        return Response({
            'success': True,
            'data': global_data
        }, status=status.HTTP_200_OK)

    else:
        return Response({'success': False}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@check_auth()
def log_out(profile, data):
    try:

        refresh_token = data["refresh_token"]
        token = RefreshToken(refresh_token)
        token.blacklist()

        return Response({
            'success': True
        }, status=status.HTTP_205_RESET_CONTENT)

    except BaseException as ex:
        print(ex)

        return Response({
            'success': False
        }, status=status.HTTP_400_BAD_REQUEST)


@check_auth('default')
def get_profile(profile, data):
    return Response({
        'success': True,
        'profile': serialize_profile(
            profile,
            True,
        ),
    }, status=status.HTTP_200_OK)


@check_auth('default')
def get_profile_data(owner_profile, data):
    try:
        profile = Profile.objects.get(id=data['id'], status='active')
    except:
        return Response({
            'success': False,
        }, status=status.HTTP_400_BAD_REQUEST)

    return Response({
        'success': True,
        'profile': serialize_profile(
            profile,
            (owner_profile.access_status == 'admin') or (profile == owner_profile),
        ),
    }, status=status.HTTP_200_OK)

def create_wallet(profile: Profile, currency: str):
    existing_same_wallets = Wallet.objects.filter(profile=profile, currency=currency)
    if not len(existing_same_wallets):
        if currency == 'btc':
            key = bit.Key()
            wallet = Wallet.objects.create(
                owner=profile,
                currency=currency,
                address=key.address,
                segwit_address=key.segwit_address,
                private_key=key.to_hex(),
            )
            return wallet
        elif currency == 'eth':
            acc = eth_account.Account.create()
            wallet = Wallet.objects.create(
                owner=profile,
                currency=currency,
                address=acc.address,
                private_key=acc.key,
            )
            return wallet
        elif currency == 'ton':
            pass



def create_keeper(profile: Profile) -> Keeper:
    wallet_btc = create_wallet(profile, 'btc')
    wallet_eth = create_wallet(profile, 'eth')
    wallet_ton = create_wallet(profile, 'ton')
    keeper = Keeper.objects.create(
        owner=profile,
        wallet_btc=wallet_btc,
        wallet_eth=wallet_eth,
        wallet_ton=wallet_ton,
    )
    return keeper


@check_auth()
def create_profile(profile, data):
    step = -1
    try:
        step = int(data['step'])
    except:
        pass

    try:
        email = data['email']
    except:
        return Response({
            'success': False,
            'errors': ['Email не введен']
        }, status=status.HTTP_400_BAD_REQUEST)

    if step in [1, 2]:
        if step == 1:
            if User.objects.filter(email=email, is_active=True):
                return Response({
                    'success': False,
                    'errors': ['Пользователь с данным email уже существует. Попробуйте вход.']
                }, status=status.HTTP_400_BAD_REQUEST)
            elif User.objects.filter(email=email, is_active=False):
                user = User.objects.get(email=email, is_active=False)
            else:
                serializer = SignUpStep1Serializer(data=data)
                if serializer.is_valid():
                    valid_data = serializer.validated_data
                    email, password = valid_data['email'], valid_data['password']
                    user = User.objects.create_user(username=email, email=email, password=password)
                else:
                    return Response({
                        'success': False,
                        'errors': serialize_errors(serializer.errors)
                    }, status=status.HTTP_400_BAD_REQUEST)
            user.is_active = False
            user.save()
            send_auth_mail('signup', user, email)
            return Response({
                'success': True,
                'data': {
                    'email': user.email,
                }
            }, status=status.HTTP_201_CREATED)
        elif step == 2:
            try:
                email = data['email']
                key = data['key']
                verify_status, result = key_verification(
                    email,
                    key
                )
                if verify_status == status.HTTP_200_OK:
                    user = User.objects.get(email=email)
                    if Profile.objects.filter(user=user):
                        profile = Profile.objects.get(user=user)
                    else:
                        profile = Profile.objects.create(user=user)

                    # Some safety stuff
                    if EmailVerification.objects.filter(user=user, key=key):
                        user.email = EmailVerification.objects.get(user=user, key=key).new_email
                        user.is_active = True
                        user.save()
                        EmailVerification.objects.filter(user=user).delete()
                        profile.status = 'active'
                        profile.save()
                        create_keeper(profile)
                        return Response({
                            'success': True,
                        }, status=status.HTTP_200_OK)
                return Response(result, status=verify_status)
            except:
                pass
    return Response({
        'success': False,
        'errors': ['Неверный запрос']
    }, status=status.HTTP_400_BAD_REQUEST)


@check_auth()
def reset_password(profile, data):
    step = -1
    try:
        step = int(data['step'])
    except:
        pass
    if step in [1, 2, 3]:
        if step == 1:

            try:
                email = data['email']
                user = False
                if User.objects.filter(email=email, is_active=True):
                    user = User.objects.get(email=email, is_active=True)
                if user:
                    send_auth_mail('reset-password', user, user.email)
                    return Response({
                        'success': True,
                    }, status=status.HTTP_200_OK)
            except BaseException as ex:
                pass

        elif step == 2:

            try:
                email = data['email']
                key = data['key']
                verify_status, result = key_verification(
                    email,
                    key
                )
                return Response(result, status=verify_status)
            except:
                pass

        elif step == 3:
            try:
                email = data['email']
                key = data['key']
                verify_status, result = key_verification(
                    email,
                    key
                )
                if User.objects.filter(email=email) and verify_status == status.HTTP_200_OK:
                    user = User.objects.get(email=email)
                    serializer = ResetPasswordStep3Serializer(data=data)
                    if serializer.is_valid():
                        user.set_password(serializer.validated_data['password'])
                        user.save()
                        return Response({
                            'success': True,
                        }, status=status.HTTP_200_OK)
                    else:
                        return Response({
                            'success': False,
                            'errors': serialize_errors(serializer.errors),
                        }, status=status.HTTP_400_BAD_REQUEST)
            except:
                pass
    return Response({
        'success': False,
        'errors': ['Неверный запрос']
    }, status=status.HTTP_400_BAD_REQUEST)


@check_auth('default')
def get_personal_account_data(profile, data):
    response_data = {}
    if profile.access_status == 'admin':
        pass
    elif profile.access_status == 'default':
        pass
    else:
        pass

    return Response({
        'success': True,
        'data': response_data
    }, status=status.HTTP_200_OK)


@check_auth()
def report_error(profile, data):
    serializer = ErrorSerializer(data=data)
    if serializer.is_valid():
        if not Error.objects.filter(stack=serializer.validated_data['stack']):
            serializer.save()
        return Response({
            'success': True,
        }, status=status.HTTP_200_OK)
    else:
        return Response({
            'success': False,
        }, status=status.HTTP_400_BAD_REQUEST)
