"""
Users Models
Location: backend/users/models.py
"""

from django.contrib.auth.models import AbstractUser
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator


class User(AbstractUser):
    """Custom user model"""
    
    class Role(models.TextChoices):
        STUDENT = 'student', 'Student'
        TEACHER = 'teacher', 'Teacher'
        ADMIN = 'admin', 'Admin'
    
    role = models.CharField(
        max_length=10,
        choices=Role.choices,
        default=Role.STUDENT
    )
    
    phone = models.CharField(max_length=15, blank=True)
    profile_picture = models.ImageField(
        upload_to='profiles/',
        null=True,
        blank=True
    )
    date_of_birth = models.DateField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"


class TeacherProfile(models.Model):
    """Extended profile for teachers"""
    
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='teacher_profile'
    )
    
    school_name = models.CharField(max_length=255)
    school_code = models.CharField(max_length=50, blank=True)
    
    subjects = models.CharField(max_length=255)
    classes_taught = models.CharField(max_length=100, blank=True)
    
    experience_years = models.IntegerField(default=0)
    qualification = models.CharField(max_length=255, blank=True)
    
    is_verified = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.username} - Teacher"


class StudentProfile(models.Model):
    """Extended profile for students"""
    
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='student_profile'
    )
    
    class_level = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(12)]
    )
    school_name = models.CharField(max_length=255)
    roll_number = models.CharField(max_length=50, blank=True)
    section = models.CharField(max_length=10, blank=True)
    
    parent_phone = models.CharField(max_length=15, blank=True)
    
    preferred_language = models.CharField(
        max_length=10,
        choices=[('hindi', 'Hindi'), ('english', 'English')],
        default='hindi'
    )
    
    learning_style = models.CharField(
        max_length=20,
        choices=[
            ('visual', 'Visual'),
            ('auditory', 'Auditory'),
            ('kinesthetic', 'Kinesthetic'),
            ('reading', 'Reading/Writing')
        ],
        blank=True
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.username} - Class {self.class_level}"


class UserPreference(models.Model):
    """User preferences and settings"""
    
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='preferences'
    )
    
    # Notification preferences
    email_notifications = models.BooleanField(default=True)
    push_notifications = models.BooleanField(default=True)
    
    # UI preferences
    dark_mode = models.BooleanField(default=False)
    text_size = models.CharField(
        max_length=10,
        choices=[('small', 'Small'), ('medium', 'Medium'), ('large', 'Large')],
        default='medium'
    )
    
    # AI preferences
    ai_voice_enabled = models.BooleanField(default=True)
    ai_response_speed = models.CharField(
        max_length=10,
        choices=[('slow', 'Slow'), ('normal', 'Normal'), ('fast', 'Fast')],
        default='normal'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.username} Preferences"