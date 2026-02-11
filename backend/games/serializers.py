from rest_framework import serializers
from .models import Game, GameProgress, GameSession


class GameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Game
        fields = '__all__'


class GameProgressSerializer(serializers.ModelSerializer):
    game_name = serializers.CharField(source='game.name', read_only=True)
    
    class Meta:
        model = GameProgress
        fields = '__all__'


class GameSessionSerializer(serializers.ModelSerializer):
    game_name = serializers.CharField(source='game.name', read_only=True)
    
    class Meta:
        model = GameSession
        fields = '__all__'