from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Game, GameProgress, GameSession
from .serializers import GameSerializer, GameProgressSerializer, GameSessionSerializer


class GameViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = GameSerializer
    permission_classes = [IsAuthenticated]
    queryset = Game.objects.filter(is_active=True)


class GameProgressViewSet(viewsets.ModelViewSet):
    serializer_class = GameProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return GameProgress.objects.filter(student=self.request.user)


class GameSessionViewSet(viewsets.ModelViewSet):
    serializer_class = GameSessionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return GameSession.objects.filter(student=self.request.user)