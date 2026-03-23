"""
Django settings for Gyaan Saarthi Backend - FREE VERSION
100% Free Services - No Paid APIs

File Location: C:\gyaansaarthi\backend\gyaan_saarthi\settings.py
"""
import os
from pathlib import Path
from decouple import config, Csv
from datetime import timedelta

# Build paths inside the project
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config('SECRET_KEY', default='django-insecure-change-this-secret-key-in-production')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = config('DEBUG', default=True, cast=bool)

# Around line 28-30
ALLOWED_HOSTS = ['localhost', '127.0.0.1', '10.0.2.2', '172.25.209.219', '192.168.137.1', '*']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third-party apps
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    'django_filters',
    'drf_spectacular',
    
    # Local apps
    'users.apps.UsersConfig',
    'ai_tutor.apps.AiTutorConfig',
    'games.apps.GamesConfig',
    'quizzes.apps.QuizzesConfig',
    'videos.apps.VideosConfig',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # For static files
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'gyaan_saarthi.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'gyaan_saarthi.wsgi.application'


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

# Option 1: SQLite (Development - Free)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Option 2: PostgreSQL (Production - Use Supabase Free Tier)
# Uncomment below for production and add DATABASE_URL to .env
# import dj_database_url
# DATABASES['default'] = dj_database_url.config(
#     default=config('DATABASE_URL'),
#     conn_max_age=600,
#     conn_health_checks=True,
# )


# Custom User Model
AUTH_USER_MODEL = 'users.User'


# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 8,
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Kolkata'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# WhiteNoise configuration for static files (FREE)
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'


# Media files (User uploaded content)

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# For production, you can use Cloudinary (FREE tier: 25GB storage)
USE_CLOUDINARY = config('USE_CLOUDINARY', default=False, cast=bool)

if USE_CLOUDINARY:
    # Cloudinary configuration (FREE tier available)
    # Sign up at cloudinary.com
    CLOUDINARY_STORAGE = {
        'CLOUD_NAME': config('CLOUDINARY_CLOUD_NAME', default=''),
        'API_KEY': config('CLOUDINARY_API_KEY', default=''),
        'API_SECRET': config('CLOUDINARY_API_SECRET', default=''),
    }
    
    # Use Cloudinary for media storage
    DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'


# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


# REST Framework Configuration
# https://www.django-rest-framework.org/

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
    'DEFAULT_FILTER_BACKENDS': (
        'django_filters.rest_framework.DjangoFilterBackend',
    ),
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
    'EXCEPTION_HANDLER': 'rest_framework.views.exception_handler',
}


# JWT Settings (JSON Web Tokens for Authentication)
# https://django-rest-framework-simplejwt.readthedocs.io/

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=1),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'UPDATE_LAST_LOGIN': True,
    
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUDIENCE': None,
    'ISSUER': None,
    
    'AUTH_HEADER_TYPES': ('Bearer',),
    'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    
    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
}


# CORS Settings (Cross-Origin Resource Sharing)
# https://github.com/adamchainz/django-cors-headers

CORS_ALLOWED_ORIGINS = config(
    'CORS_ALLOWED_ORIGINS',
    default='http://localhost:3000,http://127.0.0.1:3000',
    cast=Csv()
)

# Allow all origins in development
CORS_ALLOW_ALL_ORIGINS = DEBUG

# Allow credentials (cookies, authorization headers)
CORS_ALLOW_CREDENTIALS = True

# Additional CORS settings
CORS_ALLOW_METHODS = [
    'DELETE',
    'GET',
    'OPTIONS',
    'PATCH',
    'POST',
    'PUT',
]

CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]


# FREE AI Configuration - Ollama
# Download from: https://ollama.com
# Install models: ollama pull llama3.2

OLLAMA_URL = config('OLLAMA_URL', default='http://localhost:11434')
OLLAMA_MODEL = config('OLLAMA_MODEL', default='llama3.2')  # FREE model
OLLAMA_VISION_MODEL = config('OLLAMA_VISION_MODEL', default='llava')  # For image analysis


# FREE Speech Services Configuration

# Vosk (Offline Speech Recognition - FREE)
# Download models from: https://alphacephei.com/vosk/models
VOSK_MODEL_PATH = config('VOSK_MODEL_PATH', default='')

# gTTS (Google Text-to-Speech - FREE tier)
USE_GTTS = config('USE_GTTS', default=True, cast=bool)


# Logging Configuration

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': BASE_DIR / 'logs' / 'django.log',
            'formatter': 'verbose',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': config('DJANGO_LOG_LEVEL', default='INFO'),
            'propagate': False,
        },
        'ai_tutor': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False,
        },
    },
}

# Create logs directory if it doesn't exist
LOGS_DIR = BASE_DIR / 'logs'
LOGS_DIR.mkdir(exist_ok=True)


# DRF Spectacular (API Documentation - FREE)
# https://drf-spectacular.readthedocs.io/

SPECTACULAR_SETTINGS = {
    'TITLE': 'Gyaan Saarthi API - Free Version',
    'DESCRIPTION': 'Educational platform using 100% free services for government schools',
    'VERSION': '1.0.0',
    'SERVE_INCLUDE_SCHEMA': False,
    'SCHEMA_PATH_PREFIX': '/api/',
    'COMPONENT_SPLIT_REQUEST': True,
}


# Email Configuration (Optional - for password reset)
# You can use Gmail for free

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = config('EMAIL_HOST', default='smtp.gmail.com')
EMAIL_PORT = config('EMAIL_PORT', default=587, cast=int)
EMAIL_USE_TLS = config('EMAIL_USE_TLS', default=True, cast=bool)
EMAIL_HOST_USER = config('EMAIL_HOST_USER', default='')
EMAIL_HOST_PASSWORD = config('EMAIL_HOST_PASSWORD', default='')
DEFAULT_FROM_EMAIL = config('DEFAULT_FROM_EMAIL', default='noreply@gyaansaarthi.com')


# Security Settings for Production

if not DEBUG:
    # HTTPS/SSL Settings
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SECURE_BROWSER_XSS_FILTER = True
    SECURE_CONTENT_TYPE_NOSNIFF = True
    X_FRAME_OPTIONS = 'DENY'
    
    # HSTS Settings
    SECURE_HSTS_SECONDS = 31536000  # 1 year
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True
    
    # Trusted origins for CSRF
    CSRF_TRUSTED_ORIGINS = config(
        'CSRF_TRUSTED_ORIGINS',
        default='',
        cast=Csv()
    )


# File Upload Settings

# Maximum file upload size (10MB)
DATA_UPLOAD_MAX_MEMORY_SIZE = 10485760  # 10MB

# Maximum file upload size for images (5MB)
FILE_UPLOAD_MAX_MEMORY_SIZE = 5242880  # 5MB

# Allowed image extensions
ALLOWED_IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif', 'webp']

# Allowed video extensions
ALLOWED_VIDEO_EXTENSIONS = ['mp4', 'webm', 'ogg', 'mov']

# Allowed audio extensions
ALLOWED_AUDIO_EXTENSIONS = ['mp3', 'wav', 'ogg', 'm4a']


# Cache Configuration (Optional - Redis for production)

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'unique-snowflake',
    }
}

# For production with Redis (FREE tier on Redis Cloud):
# CACHES = {
#     'default': {
#         'BACKEND': 'django_redis.cache.RedisCache',
#         'LOCATION': config('REDIS_URL', default='redis://127.0.0.1:6379/1'),
#         'OPTIONS': {
#             'CLIENT_CLASS': 'django_redis.client.DefaultClient',
#         }
#     }
# }


# Session Configuration

SESSION_ENGINE = 'django.contrib.sessions.backends.db'
SESSION_COOKIE_AGE = 1209600  # 2 weeks
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = 'Lax'


# Django Admin Configuration

ADMIN_SITE_HEADER = 'Gyaan Saarthi Administration'
ADMIN_SITE_TITLE = 'Gyaan Saarthi Admin'
ADMIN_INDEX_TITLE = 'Welcome to Gyaan Saarthi Admin Panel'


# Additional Settings

# Pagination settings
DEFAULT_PAGINATION_SIZE = 20
MAX_PAGINATION_SIZE = 100

# Rate limiting (requests per minute)
API_RATE_LIMIT = config('API_RATE_LIMIT', default=60, cast=int)

# Maximum conversation history to send to AI
MAX_CONVERSATION_HISTORY = 10

# Maximum knowledge base search results
MAX_KNOWLEDGE_RESULTS = 3

# AI response timeout (seconds)
AI_RESPONSE_TIMEOUT = 60


# Development/Debug Settings

if DEBUG:
    # Show emails in console during development
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    
    # Debug toolbar (install django-debug-toolbar for this)
    # INSTALLED_APPS += ['debug_toolbar']
    # MIDDLEWARE.insert(0, 'debug_toolbar.middleware.DebugToolbarMiddleware')
    # INTERNAL_IPS = ['127.0.0.1']


# Custom Settings for Gyaan Saarthi

# Supported languages
SUPPORTED_LANGUAGES = ['hindi', 'english']
DEFAULT_LANGUAGE = 'hindi'

# Class levels
MIN_CLASS_LEVEL = 1
MAX_CLASS_LEVEL = 12

# Subjects
AVAILABLE_SUBJECTS = [
    'Mathematics',
    'Science',
    'Hindi',
    'English',
    'Social Studies',
    'Computer Science',
    'General Knowledge',
]

# Game difficulty levels
GAME_DIFFICULTY_LEVELS = ['easy', 'medium', 'hard']

# Quiz passing percentage
QUIZ_PASSING_PERCENTAGE = 40

# Video duration limits (seconds)
MAX_VIDEO_DURATION = 1800  # 30 minutes
MIN_VIDEO_DURATION = 10  # 10 seconds