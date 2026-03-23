"""
Users App - URLs
File Location: backend/users/urls.py
"""

from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView  # ✅ ADD THIS IMPORT
from . import views

app_name = 'users'

urlpatterns = [
    # Authentication
    path('register/', views.register_user, name='register'),
    path('login/', views.login_user, name='login'),
    path('refresh/', TokenRefreshView.as_view(), name='token-refresh'),  # ✅ ADD THIS

    # User Profile
    path('me/', views.get_current_user, name='current-user'),
    path('me/update/', views.update_user, name='update-user'),

    # Preferences
    path('preferences/', views.get_user_preferences, name='get-preferences'),
    path('preferences/update/', views.update_user_preferences, name='update-preferences'),
]