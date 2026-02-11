"""
Users App - Serializers
File Location: backend/users/serializers.py
"""

from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import TeacherProfile, StudentProfile, UserPreference

User = get_user_model()


class TeacherProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherProfile
        fields = [
            'school_name', 'school_code', 'subjects',
            'classes_taught', 'experience_years', 'qualification',
            'is_verified'
        ]


class StudentProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentProfile
        fields = [
            'class_level', 'school_name', 'roll_number',
            'section', 'parent_phone', 'preferred_language',
            'learning_style'
        ]


class UserSerializer(serializers.ModelSerializer):
    teacher_profile = TeacherProfileSerializer(required=False, allow_null=True)
    student_profile = StudentProfileSerializer(required=False, allow_null=True)
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name',
            'role', 'phone', 'profile_picture', 'date_of_birth',
            'teacher_profile', 'student_profile', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
        extra_kwargs = {'password': {'write_only': True}}
    
    def create(self, validated_data):
        teacher_data = validated_data.pop('teacher_profile', None)
        student_data = validated_data.pop('student_profile', None)
        password = validated_data.pop('password', None)
        
        user = User.objects.create(**validated_data)
        if password:
            user.set_password(password)
            user.save()
        
        # Create profile based on role
        if user.role == 'teacher' and teacher_data:
            TeacherProfile.objects.create(user=user, **teacher_data)
        elif user.role == 'student' and student_data:
            StudentProfile.objects.create(user=user, **student_data)
        
        return user


class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=False, allow_blank=True)
    role = serializers.ChoiceField(choices=['teacher', 'student'], required=True)
    phone = serializers.CharField(required=False, allow_blank=True)
    
    # Student specific
    class_level = serializers.IntegerField(required=False)
    school_name = serializers.CharField(required=False, allow_blank=True)
    preferred_language = serializers.CharField(required=False, default='hindi')
    
    # Teacher specific
    subjects = serializers.CharField(required=False, allow_blank=True)
    
    def validate_username(self, value):
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already exists")
        return value
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists")
        return value
    
    def create(self, validated_data):
        role = validated_data.pop('role')
        password = validated_data.pop('password')
        
        # Separate profile data
        class_level = validated_data.pop('class_level', None)
        school_name = validated_data.pop('school_name', '')
        preferred_language = validated_data.pop('preferred_language', 'hindi')
        subjects = validated_data.pop('subjects', '')
        
        # Create user
        user = User.objects.create(role=role, **validated_data)
        user.set_password(password)
        user.save()
        
        # Create profile
        if role == 'student' and class_level:
            StudentProfile.objects.create(
                user=user,
                class_level=class_level,
                school_name=school_name,
                preferred_language=preferred_language
            )
        elif role == 'teacher':
            TeacherProfile.objects.create(
                user=user,
                school_name=school_name,
                subjects=subjects
            )
        
        return user


class UserPreferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserPreference
        fields = [
            'email_notifications', 'push_notifications',
            'dark_mode', 'text_size', 'ai_voice_enabled',
            'ai_response_speed'
        ]