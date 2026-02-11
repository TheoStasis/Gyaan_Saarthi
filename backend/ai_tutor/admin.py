from django.contrib import admin
from .models import Conversation, Message, MessageImage, AIAnalytics, Feedback, KnowledgeBase


@admin.register(Conversation)
class ConversationAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'title', 'subject', 'class_level', 'message_count', 'is_active', 'created_at']
    list_filter = ['subject', 'class_level', 'language', 'is_active', 'created_at']
    search_fields = ['user__username', 'title', 'subject']
    readonly_fields = ['id', 'created_at', 'updated_at']


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ['id', 'conversation', 'role', 'message_type', 'text_preview', 'tokens_used', 'created_at']
    list_filter = ['role', 'message_type', 'created_at']
    search_fields = ['conversation__id', 'text_content', 'transcribed_text']
    readonly_fields = ['id', 'created_at']
    
    def text_preview(self, obj):
        return obj.text_content[:50] + '...' if len(obj.text_content) > 50 else obj.text_content
    text_preview.short_description = 'Content Preview'


@admin.register(MessageImage)
class MessageImageAdmin(admin.ModelAdmin):
    list_display = ['id', 'message', 'image', 'created_at']
    list_filter = ['created_at']
    readonly_fields = ['id', 'created_at']


@admin.register(AIAnalytics)
class AIAnalyticsAdmin(admin.ModelAdmin):
    list_display = ['user', 'date', 'total_messages', 'total_tokens', 'total_images', 'avg_response_time']
    list_filter = ['date']
    search_fields = ['user__username']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ['message', 'rating', 'is_helpful', 'created_at']
    list_filter = ['rating', 'is_helpful', 'created_at']
    readonly_fields = ['created_at']


@admin.register(KnowledgeBase)
class KnowledgeBaseAdmin(admin.ModelAdmin):
    list_display = ['source', 'class_level', 'subject', 'chapter', 'word_count', 'language', 'created_at']
    list_filter = ['class_level', 'subject', 'language', 'created_at']
    search_fields = ['source', 'subject', 'chapter', 'text']
    readonly_fields = ['word_count', 'created_at', 'updated_at']