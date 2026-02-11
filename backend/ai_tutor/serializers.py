"""
AI Tutor App - Serializers
File Location: backend/ai_tutor/serializers.py
"""

from rest_framework import serializers
from .models import Conversation, Message, MessageImage, AIAnalytics, Feedback, KnowledgeBase


class MessageImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = MessageImage
        fields = ['id', 'image', 'caption', 'ocr_text', 'created_at']


class MessageSerializer(serializers.ModelSerializer):
    images = MessageImageSerializer(many=True, read_only=True)
    
    class Meta:
        model = Message
        fields = [
            'id', 'role', 'message_type', 'text_content',
            'audio_file', 'audio_duration', 'transcribed_text',
            'images', 'tokens_used', 'response_time', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class ConversationSerializer(serializers.ModelSerializer):
    messages = MessageSerializer(many=True, read_only=True)
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    
    class Meta:
        model = Conversation
        fields = [
            'id', 'user', 'user_name', 'title', 'subject',
            'class_level', 'language', 'message_count',
            'is_active', 'messages', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'user', 'message_count', 'created_at', 'updated_at']


class ChatRequestSerializer(serializers.Serializer):
    conversation_id = serializers.UUIDField(required=False, allow_null=True)
    message = serializers.CharField(required=True)
    subject = serializers.CharField(required=False, allow_blank=True)
    language = serializers.CharField(required=False, allow_blank=True)


class AudioChatRequestSerializer(serializers.Serializer):
    conversation_id = serializers.UUIDField(required=False, allow_null=True)
    audio_file = serializers.FileField(required=True)
    subject = serializers.CharField(required=False, allow_blank=True)
    language = serializers.CharField(required=False, allow_blank=True)
    return_audio = serializers.BooleanField(required=False, default=True)


class ImageChatRequestSerializer(serializers.Serializer):
    conversation_id = serializers.UUIDField(required=False, allow_null=True)
    image = serializers.ImageField(required=True)
    message = serializers.CharField(required=False, allow_blank=True)
    subject = serializers.CharField(required=False, allow_blank=True)
    language = serializers.CharField(required=False, allow_blank=True)


class FeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feedback
        fields = ['id', 'message', 'rating', 'is_helpful', 'comment', 'created_at']
        read_only_fields = ['id', 'created_at']


class AIAnalyticsSerializer(serializers.ModelSerializer):
    class Meta:
        model = AIAnalytics
        fields = [
            'id', 'user', 'total_messages', 'total_tokens',
            'total_audio_seconds', 'total_images', 'subject_usage',
            'avg_response_time', 'satisfaction_rating',
            'date', 'created_at'
        ]
        read_only_fields = ['id', 'user', 'created_at']


class KnowledgeBaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = KnowledgeBase
        fields = [
            'id', 'source', 'class_level', 'subject', 'chapter',
            'text', 'word_count', 'language', 'created_at'
        ]
        read_only_fields = ['id', 'word_count', 'created_at']