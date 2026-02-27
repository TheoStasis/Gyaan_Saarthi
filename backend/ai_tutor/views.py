"""
AI Tutor Views
Location: backend/ai_tutor/views.py
"""

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.core.files.storage import default_storage
import uuid

from .models import Conversation, Message, Feedback, AIAnalytics
from .serializers import (
    ConversationSerializer,
    MessageSerializer,
    ChatRequestSerializer,
    AudioChatRequestSerializer,
    ImageChatRequestSerializer,
    FeedbackSerializer,
    AIAnalyticsSerializer
)
from .services import AITutorService


class ConversationViewSet(viewsets.ModelViewSet):
    """Manage conversations"""
    serializer_class = ConversationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Conversation.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ChatViewSet(viewsets.ViewSet):
    """Handle AI chat interactions"""
    permission_classes = [IsAuthenticated]
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.ai_service = AITutorService()
    
    def send_text(self, request):
        """Send text message to AI"""
        serializer = ChatRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        conversation_id = serializer.validated_data.get('conversation_id')
        message_text = serializer.validated_data['message']
        subject = serializer.validated_data.get('subject', 'general')
        language = serializer.validated_data.get('language', 'hindi')
        
        # Get or create conversation
        if conversation_id:
            try:
                conversation = Conversation.objects.get(
                    id=conversation_id,
                    user=request.user
                )
            except Conversation.DoesNotExist:
                conversation = None
        else:
            conversation = None
        
        if not conversation:
            # Get user's class level
            class_level = 5  # Default
            if hasattr(request.user, 'student_profile'):
                class_level = request.user.student_profile.class_level
            
            conversation = Conversation.objects.create(
                user=request.user,
                title=message_text[:50],
                subject=subject,
                class_level=class_level,
                language=language
            )
        
        # Create user message
        user_message = Message.objects.create(
            conversation=conversation,
            role='user',
            message_type='text',
            text_content=message_text
        )
        
        # Get AI response
        ai_response = self.ai_service.generate_response(
        question=message_text,
        class_level=conversation.class_level or 5,
        subject=subject or 'General',
        language=language,
    )
        
        # Create AI message
        ai_message = Message.objects.create(
            conversation=conversation,
            role='assistant',
            message_type='text',
            text_content=ai_response.get('response', 'Sorry, I could not generate a response.'),
            tokens_used=ai_response.get('tokens_used', 0)
        )
        
        # Update conversation
        conversation.message_count += 2
        conversation.save()
        
        return Response({
            'conversation_id': str(conversation.id),
            'message': MessageSerializer(ai_message).data
        })
    
    def send_audio(self, request):
        """Send audio message to AI"""
        serializer = AudioChatRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        return Response({
            'message': 'Audio chat coming soon! Use text for now.'
        }, status=status.HTTP_501_NOT_IMPLEMENTED)
    
    def send_image(self, request):
        """Send image with question to AI"""
        serializer = ImageChatRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        conversation_id = serializer.validated_data.get('conversation_id')
        image = serializer.validated_data['image']
        message_text = serializer.validated_data.get('message', 'What is in this image?')
        subject = serializer.validated_data.get('subject', 'general')
        language = serializer.validated_data.get('language', 'hindi')
        
        # Get or create conversation
        if conversation_id:
            try:
                conversation = Conversation.objects.get(
                    id=conversation_id,
                    user=request.user
                )
            except Conversation.DoesNotExist:
                conversation = None
        else:
            conversation = None
        
        if not conversation:
            class_level = 5
            if hasattr(request.user, 'student_profile'):
                class_level = request.user.student_profile.class_level
            
            conversation = Conversation.objects.create(
                user=request.user,
                title='Image Question',
                subject=subject,
                class_level=class_level,
                language=language
            )
        
        # Save image
        image_path = default_storage.save(
            f'ai_tutor/images/{uuid.uuid4()}.jpg',
            image
        )
        
        # Create user message with image
        user_message = Message.objects.create(
            conversation=conversation,
            role='user',
            message_type='image',
            text_content=message_text
        )
        
        from .models import MessageImage
        MessageImage.objects.create(
            message=user_message,
            image=image_path
        )
        
        # Get AI response
        full_path = default_storage.path(image_path)
        ai_response = self.ai_service.analyze_image_with_question(
            image_path=full_path,
            question=message_text,
            class_level=conversation.class_level or 5,
            subject=subject,
            language=language
        )
        
        # Create AI message
        ai_message = Message.objects.create(
            conversation=conversation,
            role='assistant',
            message_type='text',
            text_content=ai_response.get('response', 'Sorry, I could not analyze the image.'),
            tokens_used=ai_response.get('tokens_used', 0)
        )
        
        # Update conversation
        conversation.message_count += 2
        conversation.save()
        
        return Response({
            'conversation_id': str(conversation.id),
            'message': MessageSerializer(ai_message).data
        })


class FeedbackViewSet(viewsets.ModelViewSet):
    """Manage feedback"""
    serializer_class = FeedbackSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Feedback.objects.filter(
            message__conversation__user=self.request.user
        )


class AnalyticsViewSet(viewsets.ReadOnlyModelViewSet):
    """View AI usage analytics"""
    serializer_class = AIAnalyticsSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return AIAnalytics.objects.filter(user=self.request.user)