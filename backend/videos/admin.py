from django.contrib import admin
from .models import Video, VideoView


@admin.register(Video)
class VideoAdmin(admin.ModelAdmin):
    list_display = ['title', 'uploaded_by', 'subject', 'class_level', 'view_count', 'is_published', 'created_at']
    list_filter = ['subject', 'class_level', 'is_published', 'created_at']
    search_fields = ['title', 'description', 'uploaded_by__username']
    readonly_fields = ['id', 'view_count', 'created_at', 'updated_at']


@admin.register(VideoView)
class VideoViewAdmin(admin.ModelAdmin):
    list_display = ['video', 'user', 'watched_duration', 'completed', 'created_at']
    list_filter = ['completed', 'created_at']
    search_fields = ['video__title', 'user__username']
    readonly_fields = ['id', 'created_at', 'updated_at']