from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import VideoViewSet, VideoViewViewSet

router = DefaultRouter()
router.register(r'videos', VideoViewSet, basename='video')
router.register(r'views', VideoViewViewSet, basename='videoview')

urlpatterns = [
    path('', include(router.urls)),
]