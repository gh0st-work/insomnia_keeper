import datetime
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

LINUX_USER = 'gh0st'

DEBUG = True
LOCAL = (not os.path.exists(f'/home/{LINUX_USER}/insomnia_keeper/server/secrets/secret_key.txt'))

if LOCAL:
    SECRET_KEY = 'blahblahblah'
    ALLOWED_HOSTS = ['*']
else:
    with open(f'/home/{LINUX_USER}/insomnia_keeper/server/secrets/secret_key.txt') as f:
        SECRET_KEY = f.read().strip()
    with open(f'/home/{LINUX_USER}/insomnia_keeper/server/secrets/database_secret_key.txt') as f:
        DATABASE_SECRET_KEY = f.read().strip()
    ALLOWED_HOSTS = ['127.0.0.1', 'insomnia-keeper.com']

SITE_ID = 1
SITE_HOST = '127.0.0.1'
SITE_NAME = 'insomnia-keeper.com'

if LOCAL:
    SITE_HOST = '127.0.0.1:8000'
    SITE_NAME = '127.0.0.1:8000'

if LOCAL:
    ALLOWED_HOSTS = ['*']
else:
    ALLOWED_HOSTS = [SITE_HOST, SITE_NAME, f'www.{SITE_NAME}']

DJANGO_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.sites',
]

THIRD_PARTY_APPS = [
    'rest_framework',
    'rest_framework_simplejwt.token_blacklist',
    'corsheaders',
    'ckeditor',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'django_extensions',
]

INSOMNIA_KEEPER_APPS = [
    'insomnia_keeper_main.apps.InsomniaKeeperMainConfig',
]

INSTALLED_APPS = DJANGO_APPS + THIRD_PARTY_APPS + INSOMNIA_KEEPER_APPS

REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': datetime.timedelta(minutes=5),
    'REFRESH_TOKEN_LIFETIME': datetime.timedelta(days=30),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': False,
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUTH_HEADER_TYPES': ('JWT',),
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
}
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'corsheaders.middleware.CorsPostCsrfMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
]

ROOT_URLCONF = 'insomnia_keeper_settings.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.media',
            ],
        },
    },
]

WSGI_APPLICATION = 'insomnia_keeper_settings.wsgi.application'
ASGI_APPLICATION = 'insomnia_keeper_settings.routing.application'

if LOCAL:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': 'db.sqlite3',
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': 'insomnia_keeper_db',
            'USER': 'insomnia_keeper_user',
            'PASSWORD': DATABASE_SECRET_KEY,
            'HOST': '127.0.0.1',
            'PORT': '5432',
        }
    }

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

LANGUAGE_CODE = 'ru'
TIME_ZONE = 'Europe/Moscow'
USE_I18N = True
USE_L10N = False
USE_TZ = True

STATIC_URL = '/server-data/'
STATIC_ROOT = os.path.join(BASE_DIR, "static")
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "insomnia_keeper_main", "static"),
]

MEDIA_URL = '/users-data/'
MEDIA_ROOT = os.path.join(BASE_DIR, "media")

LOGIN_URL = '/#login'

# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
# EMAIL_HOST = 'localhost'
# EMAIL_PORT = 25
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
# EMAIL_USE_TLS = False
# EMAIL_USE_LOCALTIME = True

DECIMAL_SEPARATOR = '.'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': os.path.join(BASE_DIR, 'django-log.txt'),
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'ERROR',
            'propagate': True,
        },
    },
}

CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
X_FRAME_OPTIONS = 'ALLOWALL'

XS_SHARING_ALLOWED_METHODS = ['POST', 'GET', 'OPTIONS', 'PUT', 'DELETE']

REDIS_HOST = 'localhost'
REDIS_PORT = 6379
REDIS_DB = 0
