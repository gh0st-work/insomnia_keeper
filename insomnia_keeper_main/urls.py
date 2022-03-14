from django.urls import path
from rest_framework_simplejwt import views as jwt_views

from .api_v1 import views as views_v1

urlpatterns = []

api_v1_auth_urlpatterns = [
    path('v1/auth/token/obtain/', views_v1.LoginView.as_view(), name='v1-token-create'),
    path('v1/auth/token/refresh/', jwt_views.TokenRefreshView.as_view(), name='v1-token-refresh'),
    path('v1/auth/logout/', views_v1.LogoutView.as_view(), name='v1-logout'),
]

api_v1_profile_urlpatterns = [
    path('v1/profile-data/', views_v1.ProfileDataView.as_view(), name='v1-profile-data'),
    path('v1/profile/create/', views_v1.ProfileCreateView.as_view(), name='v1-profile-create'),
    path('v1/profile/reset-password/', views_v1.ProfileResetPasswordView.as_view(), name='v1-profile-reset-password'),
    path('v1/profile/', views_v1.ProfileView.as_view(), name='v1-profile'),
]

api_v1_admin_urlpatterns = [

]

api_v1_misc_urlpatterns = [
    path('v1/personal-account/', views_v1.PersonalAccountView.as_view(), name='v1-personal-account'),
    path('v1/global/', views_v1.GlobalView.as_view(), name='v1-global'),
    path('v1/error/', views_v1.ErrorView.as_view(), name='v1-error'),
]

api_v1_urlpatterns = api_v1_auth_urlpatterns \
                      + api_v1_profile_urlpatterns \
                      + api_v1_admin_urlpatterns \
                      + api_v1_misc_urlpatterns

urlpatterns += api_v1_urlpatterns
