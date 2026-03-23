from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AITutorViewSet

router = DefaultRouter()
router.register(r'', AITutorViewSet, basename='ai-tutor')

urlpatterns = [
    path('', include(router.urls)),
]