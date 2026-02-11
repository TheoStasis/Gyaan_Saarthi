from rest_framework import serializers
from .models import Video, VideoView


class VideoSerializer(serializers.ModelSerializer):
    uploaded_by_name = serializers.CharField(source='uploaded_by.get_full_name', read_only=True)
    
    class Meta:
        model = Video
        fields = '__all__'


class VideoViewSerializer(serializers.ModelSerializer):
    class Meta:
        model = VideoView
        fields = '__all__'