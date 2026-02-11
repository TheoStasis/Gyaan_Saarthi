from django.contrib import admin
from .models import User, TeacherProfile, StudentProfile, UserPreference


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['username', 'email', 'role', 'first_name', 'last_name', 'created_at']
    list_filter = ['role', 'created_at']
    search_fields = ['username', 'email', 'first_name', 'last_name']


@admin.register(TeacherProfile)
class TeacherProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'school_name', 'subjects', 'experience_years', 'is_verified']
    list_filter = ['is_verified', 'experience_years']
    search_fields = ['user__username', 'school_name', 'subjects']


@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'class_level', 'school_name', 'section', 'preferred_language']
    list_filter = ['class_level', 'preferred_language']
    search_fields = ['user__username', 'school_name', 'roll_number']


@admin.register(UserPreference)
class UserPreferenceAdmin(admin.ModelAdmin):
    list_display = ['user', 'dark_mode', 'ai_voice_enabled', 'text_size']
    list_filter = ['dark_mode', 'ai_voice_enabled']