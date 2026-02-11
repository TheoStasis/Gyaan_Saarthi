"""
AI Tutor URLs
Location: backend/ai_tutor/urls.py
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ConversationViewSet, ChatViewSet, FeedbackViewSet, AnalyticsViewSet

router = DefaultRouter()
router.register(r'conversations', ConversationViewSet, basename='conversation')
router.register(r'feedback', FeedbackViewSet, basename='feedback')
router.register(r'analytics', AnalyticsViewSet, basename='analytics')

urlpatterns = [
    path('', include(router.urls)),
    
    # Chat endpoints (custom, not in router)
    path('chat/text/', ChatViewSet.as_view({'post': 'send_text'}), name='chat-text'),
    path('chat/audio/', ChatViewSet.as_view({'post': 'send_audio'}), name='chat-audio'),
    path('chat/image/', ChatViewSet.as_view({'post': 'send_image'}), name='chat-image'),
]