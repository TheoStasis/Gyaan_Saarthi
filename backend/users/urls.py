"""
Users App - URLs
File Location: backend/users/urls.py
"""

from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    # Authentication
    path('register/', views.register_user, name='register'),
    path('login/', views.login_user, name='login'),
    
    # User Profile
    path('me/', views.get_current_user, name='current-user'),
    path('me/update/', views.update_user, name='update-user'),
    
    # Preferences
    path('preferences/', views.get_user_preferences, name='get-preferences'),
    path('preferences/update/', views.update_user_preferences, name='update-preferences'),
]