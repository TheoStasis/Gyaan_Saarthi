"""
AI Tutor Models
Location: backend/ai_tutor/models.py
"""

from django.db import models
from django.conf import settings
from django.contrib.auth import get_user_model
from django.core.validators import MinValueValidator, MaxValueValidator
import uuid

User = get_user_model()


class Conversation(models.Model):
    """Conversation between student and AI tutor"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='conversations'
    )
    
    title = models.CharField(max_length=255, default='New Conversation')
    subject = models.CharField(max_length=100, default='general')
    class_level = models.IntegerField(
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(12)]
    )
    language = models.CharField(max_length=10, default='hindi')
    
    message_count = models.IntegerField(default=0)
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"{self.user.username} - {self.title}"


class Message(models.Model):
    """Individual message in a conversation"""
    
    class Role(models.TextChoices):
        USER = 'user', 'User'
        ASSISTANT = 'assistant', 'Assistant'
    
    class MessageType(models.TextChoices):
        TEXT = 'text', 'Text'
        AUDIO = 'audio', 'Audio'
        IMAGE = 'image', 'Image'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='messages'
    )
    
    role = models.CharField(max_length=10, choices=Role.choices)
    message_type = models.CharField(
        max_length=10,
        choices=MessageType.choices,
        default=MessageType.TEXT
    )
    
    text_content = models.TextField()
    audio_file = models.FileField(upload_to='ai_tutor/audio/', null=True, blank=True)
    audio_duration = models.IntegerField(null=True, blank=True)
    transcribed_text = models.TextField(blank=True)
    
    tokens_used = models.IntegerField(default=0)
    response_time = models.FloatField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['created_at']
    
    def __str__(self):
        return f"{self.role} - {self.text_content[:50]}"


class MessageImage(models.Model):
    """Images attached to messages"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    message = models.ForeignKey(
        Message,
        on_delete=models.CASCADE,
        related_name='images'
    )
    
    image = models.ImageField(upload_to='ai_tutor/images/')
    caption = models.CharField(max_length=255, blank=True)
    ocr_text = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Image for {self.message.id}"


class AIAnalytics(models.Model):
    """Daily analytics for AI usage"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='ai_analytics'
    )
    
    date = models.DateField()
    total_messages = models.IntegerField(default=0)
    total_tokens = models.IntegerField(default=0)
    total_audio_seconds = models.IntegerField(default=0)
    total_images = models.IntegerField(default=0)
    
    subject_usage = models.JSONField(default=dict)
    avg_response_time = models.FloatField(default=0.0)
    satisfaction_rating = models.FloatField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'date']
        ordering = ['-date']


class Feedback(models.Model):
    """User feedback on AI responses"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    message = models.ForeignKey(
        Message,
        on_delete=models.CASCADE,
        related_name='feedback'
    )
    
    rating = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)],
        null=True,
        blank=True
    )
    is_helpful = models.BooleanField(null=True, blank=True)
    comment = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Feedback for {self.message.id}"


class TextbookContent(models.Model):
    """Stores educational content from textbooks for RAG"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    source = models.CharField(max_length=200, help_text='Source of content')
    class_level = models.CharField(max_length=20, help_text='Class level')
    subject = models.CharField(max_length=100, help_text='Subject name')
    chapter = models.CharField(max_length=100, help_text='Chapter identifier')
    content = models.TextField(help_text='Actual content')
    embedding_id = models.CharField(
        max_length=100,
        unique=True,
        help_text='ID in vector database'
    )
    metadata = models.JSONField(default=dict, help_text='Additional metadata')
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'textbook_content'
        indexes = [
            models.Index(fields=['class_level', 'subject']),
            models.Index(fields=['subject']),
        ]
        verbose_name = 'Textbook Content'
        verbose_name_plural = 'Textbook Contents'
        ordering = ['class_level', 'subject', 'chapter']
    
    def __str__(self):
        return f"{self.class_level} - {self.subject} - {self.chapter}"


class KnowledgeBase(models.Model):
    """Textbook content for RAG (legacy model - consider using TextbookContent instead)"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    source = models.CharField(max_length=255)
    class_level = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(12)]
    )
    subject = models.CharField(max_length=100)
    chapter = models.CharField(max_length=255)
    
    text = models.TextField()
    word_count = models.IntegerField(default=0)
    language = models.CharField(max_length=10, default='hindi')
    
    embeddings = models.JSONField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['class_level', 'subject', 'chapter']
    
    def save(self, *args, **kwargs):
        if not self.word_count:
            self.word_count = len(self.text.split())
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"Class {self.class_level} - {self.subject} - {self.chapter}"