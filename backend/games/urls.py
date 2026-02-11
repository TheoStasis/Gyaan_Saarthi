from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import GameViewSet, GameProgressViewSet, GameSessionViewSet

router = DefaultRouter()
router.register(r'games', GameViewSet, basename='game')
router.register(r'progress', GameProgressViewSet, basename='progress')
router.register(r'sessions', GameSessionViewSet, basename='session')

urlpatterns = [
    path('', include(router.urls)),
]