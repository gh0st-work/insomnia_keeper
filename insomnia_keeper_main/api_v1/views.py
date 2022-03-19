from django.shortcuts import render
from rest_framework import permissions
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView

from .logic import *


class GlobalView(APIView):
    permission_classes = (permissions.AllowAny,)

    def get(self, request):
        return get_global()


class LoginView(TokenObtainPairView):

    def post(self, request, *args, **kwargs):
        if 'email' in request.data.keys():
            users = User.objects.filter(email=request.data['email'])
            if len(users) == 1:
                user = users[0]
                request.data['username'] = user.username
                return super(LoginView, self).post(request, *args, **kwargs)
        return Response({
            'detail': "No active account found with the given credentials",
        }, status=status.HTTP_401_UNAUTHORIZED)


class LogoutView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        return log_out(request)


class ProfileView(APIView):

    def get(self, request):
        return get_profile(request)


class ProfileCreateView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        return create_profile(request)


class PersonalAccountView(APIView):

    def get(self, request):
        return get_personal_account_data(request)


class ErrorView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        return report_error(request)



def build(request, *args, **kwargs):
    context = {}
    if Global.objects.filter(active=True):
        context['fixed'] = Global.objects.get(active=True)
    return render(request, 'build.html', context=context)
