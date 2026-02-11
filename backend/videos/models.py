from django.db import models
from django.conf import settings
import uuid


class Video(models.Model):
    """Science practical videos"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    uploaded_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='uploaded_videos'
    )
    
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    
    subject = models.CharField(max_length=100, default='Science')
    class_level = models.IntegerField()
    chapter = models.CharField(max_length=100, blank=True)
    topic = models.CharField(max_length=255, blank=True)
    
    video_file = models.FileField(upload_to='videos/science_practicals/')
    thumbnail = models.ImageField(upload_to='videos/thumbnails/', blank=True, null=True)
    duration = models.IntegerField(help_text="Duration in seconds", null=True)
    file_size = models.BigIntegerField(help_text="File size in bytes", null=True)
    
    view_count = models.IntegerField(default=0)
    is_published = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - Class {self.class_level}"


class VideoView(models.Model):
    """Track video views"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    video = models.ForeignKey(Video, on_delete=models.CASCADE, related_name='views')
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='video_views'
    )
    
    watched_duration = models.IntegerField(default=0)
    completed = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
        unique_together = ['video', 'user']