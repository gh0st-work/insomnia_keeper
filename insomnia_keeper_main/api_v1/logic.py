import datetime
import json

import bit
import eth_account
import js2py
from django.utils import timezone
from pytils.translit import slugify
from rest_framework import status
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
import redis
from .serializers import *
import walletcore as trust_core


# import tonweb.management as ton


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


def generate_trust_wallet_passphrase(profile: Profile):
    return f'{profile.tag}-{settings.SECRET_KEY}'


COIN_TO_TRUST = {
    'btc': trust_core.CoinType.Bitcoin,
    'ltc': trust_core.CoinType.Litecoin,
    'doge': trust_core.CoinType.Dogecoin,
    'dash': trust_core.CoinType.Dash,
    'via': trust_core.CoinType.Viacoin,
    'grs': trust_core.CoinType.Groestlcoin,
    'dgb': trust_core.CoinType.DigiByte,
    'mona': trust_core.CoinType.Monacoin,
    'dcr': trust_core.CoinType.Decred,
    'eth': trust_core.CoinType.Ethereum,
    'etc': trust_core.CoinType.EthereumClassic,
    'icx': trust_core.CoinType.ICON,
    'atom': trust_core.CoinType.Cosmos,
    'zec': trust_core.CoinType.Zcash,
    'firo': trust_core.CoinType.Firo,
    'xrp': trust_core.CoinType.XRP,
    'bch': trust_core.CoinType.SmartBitcoinCash,
    'xlm': trust_core.CoinType.Stellar,
    'btg': trust_core.CoinType.BitcoinGold,
    'xno': trust_core.CoinType.Nano,
    'rvn': trust_core.CoinType.Ravencoin,
    'poa': trust_core.CoinType.POANetwork,
    'eos': trust_core.CoinType.EOS,
    'trx': trust_core.CoinType.Tron,
    'fio': trust_core.CoinType.FIO,
    'nim': trust_core.CoinType.Nimiq,
    'algo': trust_core.CoinType.Algorand,
    'iotx': trust_core.CoinType.IoTeX,
    'zil': trust_core.CoinType.Zilliqa,
    'luna': trust_core.CoinType.Terra,
    'dot': trust_core.CoinType.Polkadot,
    'near': trust_core.CoinType.NEAR,
    'aion': trust_core.CoinType.Aion,
    'ksm': trust_core.CoinType.Kusama,
    'ae': trust_core.CoinType.Aeternity,
    'kava': trust_core.CoinType.Kava,
    'fil': trust_core.CoinType.Filecoin,
    'blz': trust_core.CoinType.Bluzelle,
    'band': trust_core.CoinType.BandChain,
    'theta': trust_core.CoinType.Theta,
    'sol': trust_core.CoinType.Solana,
    'egld': trust_core.CoinType.Elrond,
    'bnb': trust_core.CoinType.SmartChain,
    'vet': trust_core.CoinType.VeChain,
    'clo': trust_core.CoinType.Callisto,
    'neo': trust_core.CoinType.NEO,
    'tomo': trust_core.CoinType.TomoChain,
    'tt': trust_core.CoinType.ThunderToken,
    'one': trust_core.CoinType.Harmony,
    'rose': trust_core.CoinType.Oasis,
    'ont': trust_core.CoinType.Ontology,
    'xtz': trust_core.CoinType.Tezos,
    'ada': trust_core.CoinType.Cardano,
    'kin': trust_core.CoinType.Kin,
    'qtum': trust_core.CoinType.Qtum,
    'nas': trust_core.CoinType.Nebulas,
    'go': trust_core.CoinType.GoChain,
    'nuls': trust_core.CoinType.NULS,
    'flux': trust_core.CoinType.Zelcash,
    'wan': trust_core.CoinType.Wanchain,
    'waves': trust_core.CoinType.Waves,
    'matic': trust_core.CoinType.Polygon,
    'rune': trust_core.CoinType.THORChain,
    'oeth': trust_core.CoinType.Optimism,
    'areth': trust_core.CoinType.Arbitrum,
    'ht': trust_core.CoinType.ECOChain,
    'avax': trust_core.CoinType.AvalancheCChain,
    'xdai': trust_core.CoinType.XDai,
    'ftm': trust_core.CoinType.Fantom,
    'cro': trust_core.CoinType.CronosChain,
    'celo': trust_core.CoinType.Celo,
    'ron': trust_core.CoinType.Ronin,
    'osmo': trust_core.CoinType.Osmosis,
    'xec': trust_core.CoinType.ECash,
}


def create_trust_wallet(profile: Profile) -> TrustWallet:
    wallet = trust_core.HDWallet.create(128, generate_trust_wallet_passphrase(profile))
    mnemonic = wallet.mnemonic
    trust_wallet = TrustWallet.objects.create(
        owner=profile,
        mnemonic=mnemonic,
        **{
            f'{symbol}_address': COIN_TO_TRUST[symbol]
            for symbol in TRUST_WALLET_COINS.keys()
        }
    )
    return trust_wallet


def create_independent_wallet(profile: Profile, currency: str) -> IndependentWallet:
    if currency == 'ton':
        acc = ton.create_wallet()
        wallet = IndependentWallet.objects.create(
            owner=profile,
            currency=currency,
            address=acc['address'],
            public_key=acc['public_key'],
            private_key=acc['private_key']
        )
        return wallet
    else:
        raise Exception('No such currency')


def create_keeper(profile: Profile) -> Keeper:
    trust_wallet = create_trust_wallet(profile)
    ton_wallet = create_independent_wallet(profile, 'ton')
    keeper = Keeper.objects.create(
        owner=profile,
        trust_wallet=trust_wallet,
        ton_wallet=ton_wallet,
    )
    return keeper


@check_auth()
def check_tag_available(profile, data):
    try:
        tag = data['tag']
    except:
        return Response({
            'success': False,
            'errors': ['Тег не введен']
        }, status=status.HTTP_400_BAD_REQUEST)

    if len(tag) <= 3:
        return Response({
            'success': False,
            'data': [{'tag': 'Тег должен быть длиннее 3х символов'}]
        }, status=status.HTTP_406_NOT_ACCEPTABLE)
    else:
        if Profile.objects.filter(user__username=tag):
            return Response({
                'success': True,
                'data': {'tag': tag}
            }, status=status.HTTP_200_OK)
        else:
            return Response({
                'success': False,
                'data': [{'tag': 'Пользователь с таким тегом уже существует'}]
            }, status=status.HTTP_406_NOT_ACCEPTABLE)


@check_auth()
def create_profile(profile, data):
    try:
        tag = data['tag']
    except:
        return Response({
            'success': False,
            'errors': ['Тег не введен']
        }, status=status.HTTP_400_BAD_REQUEST)

    if len(tag) > 3:
        data['username'] = tag
        if not Profile.objects.filter(user__username=tag):
            serializer = SignUpSerializer(data=data)
            if serializer.is_valid():
                if len(serializer.validated_data.password) >= 16:
                    user = User.objects.create_user(
                        username=serializer.validated_data.username,
                        password=serializer.validated_data.password
                    )
                    user.is_active = True
                    user.save()
                    profile = Profile.objects.create(user=user)
                    profile.save()
                    create_keeper(profile)
                    return Response({
                        'success': True,
                        'data': ProfileSerializer(profile).data
                    }, status=status.HTTP_200_OK)
                else:
                    return Response({
                        'success': False,
                        'errors': [{'password': 'Введите как минимум 16 символов'}]
                    }, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response({
                    'success': False,
                    'errors': serialize_errors(serializer.errors)
                }, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({
                'success': False,
                'errors': [{'tag': 'Пользователь с таким тегом уже существует'}]
            }, status=status.HTTP_400_BAD_REQUEST)
    else:
        return Response({
            'success': False,
            'data': [{'tag': 'Тег должен быть длиннее 3х символов'}]
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
