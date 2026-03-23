from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .services import AITutorService

# Try to import models, but don't fail if they don't exist
try:
    from .models import Conversation, ChatMessage
    HAS_MODELS = True
except ImportError:
    HAS_MODELS = False
    print("⚠️ WARNING: Conversation/ChatMessage models not found - running without DB storage")


class AITutorViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ai_service = AITutorService()
    
    @action(detail=False, methods=['post'], url_path='chat/text')
    def chat_text(self, request):
        """Handle text-based chat with AI tutor"""
        try:
            # Get request data
            question = request.data.get('question', '').strip()
            conversation_id = request.data.get('conversation_id')
            language = request.data.get('language', 'english')
            
            # Debug logging
            print("=" * 60)
            print("🔵 INCOMING CHAT REQUEST")
            print(f"🔵 User: {request.user.username}")
            print(f"🔵 Question: {question}")
            print(f"🔵 Language: {language}")
            print(f"🔵 Conversation ID: {conversation_id}")
            print("=" * 60)
            
            # Validate question
            if not question:
                print("🔴 ERROR: Question is empty!")
                return Response(
                    {'error': 'Question is required'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Get user's class level
            class_level = 5
            if hasattr(request.user, 'student_profile'):
                class_level = request.user.student_profile.class_level
            elif hasattr(request.user, 'teacher_profile'):
                class_level = 8
            
            print(f"🔵 Class level: {class_level}")
            
            # Generate AI response
            try:
                print(f"🔵 Calling AI service...")
                result = self.ai_service.generate_response(
                    question=question,
                    class_level=class_level,
                    subject='General',
                    language=language,
                    conversation_history=None,
                    include_knowledge=True
                )
                print(f"🟢 Response generated successfully")
                print(f"🟢 Answer preview: {result['answer'][:100]}...")
            except Exception as e:
                print(f"🔴 ERROR generating response: {e}")
                import traceback
                traceback.print_exc()
                return Response(
                    {'error': f'AI service error: {str(e)}'},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
            
            # Save to database if models are available
            conversation = None
            if HAS_MODELS:
                try:
                    # Create or get conversation
                    if conversation_id:
                        try:
                            conversation = Conversation.objects.get(
                                id=conversation_id,
                                user=request.user
                            )
                            print(f"🟢 Using existing conversation: {conversation_id}")
                        except Conversation.DoesNotExist:
                            print(f"🟡 Conversation {conversation_id} not found, creating new")
                            conversation = Conversation.objects.create(
                                user=request.user,
                                title=question[:50]
                            )
                    else:
                        conversation = Conversation.objects.create(
                            user=request.user,
                            title=question[:50]
                        )
                        print(f"🟢 Created new conversation: {conversation.id}")
                    
                    # Save messages
                    ChatMessage.objects.create(
                        conversation=conversation,
                        content=question,
                        is_user=True
                    )
                    
                    ChatMessage.objects.create(
                        conversation=conversation,
                        content=result['answer'],
                        is_user=False,
                        metadata=result.get('metadata', {})
                    )
                    print(f"🟢 Messages saved to database")
                    
                except Exception as e:
                    print(f"🔴 ERROR saving to database: {e}")
                    # Continue without saving
                    conversation = None
            else:
                print(f"⚠️ Skipping database save (models not available)")
            
            # Prepare response
            response_data = {
                'answer': result['answer'],
                'conversation_id': str(conversation.id) if conversation else None,
                'metadata': result.get('metadata', {}),
                'language': language,
            }
            
            print(f"🟢 Sending response to client")
            print("=" * 60)
            
            return Response(response_data, status=status.HTTP_200_OK)
            
        except Exception as e:
            print(f"🔴 FATAL ERROR in chat_text: {e}")
            import traceback
            traceback.print_exc()
            print("=" * 60)
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    @action(detail=False, methods=['get'], url_path='conversations')
    def get_conversations(self, request):
        """Get user's conversation history"""
        if not HAS_MODELS:
            return Response(
                {'error': 'Conversation storage not available'},
                status=status.HTTP_501_NOT_IMPLEMENTED
            )
        
        try:
            conversations = Conversation.objects.filter(
                user=request.user
            ).order_by('-updated_at')[:20]
            
            data = [{
                'id': str(conv.id),
                'title': conv.title,
                'created_at': conv.created_at.isoformat(),
                'updated_at': conv.updated_at.isoformat(),
            } for conv in conversations]
            
            return Response(data, status=status.HTTP_200_OK)
            
        except Exception as e:
            print(f"🔴 ERROR getting conversations: {e}")
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )