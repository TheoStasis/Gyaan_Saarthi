from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Quiz, QuizAttempt
from .serializers import QuizSerializer, QuizAttemptSerializer


class QuizViewSet(viewsets.ModelViewSet):
    serializer_class = QuizSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        if self.request.user.role == 'teacher':
            return Quiz.objects.filter(created_by=self.request.user)
        return Quiz.objects.filter(is_published=True, is_active=True)


class QuizAttemptViewSet(viewsets.ModelViewSet):
    serializer_class = QuizAttemptSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return QuizAttempt.objects.filter(student=self.request.user)