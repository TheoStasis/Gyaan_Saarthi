from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Video, VideoView
from .serializers import VideoSerializer, VideoViewSerializer


class VideoViewSet(viewsets.ModelViewSet):
    serializer_class = VideoSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        if self.request.user.role == 'teacher':
            return Video.objects.filter(uploaded_by=self.request.user)
        return Video.objects.filter(is_published=True)


class VideoViewViewSet(viewsets.ModelViewSet):
    serializer_class = VideoViewSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return VideoView.objects.filter(user=self.request.user)