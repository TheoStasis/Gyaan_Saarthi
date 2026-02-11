from django.contrib import admin
from .models import Game, GameProgress, GameSession


@admin.register(Game)
class GameAdmin(admin.ModelAdmin):
    list_display = ['name', 'game_type', 'subject', 'min_class', 'max_class', 'difficulty', 'is_active']
    list_filter = ['game_type', 'subject', 'difficulty', 'is_active']
    search_fields = ['name', 'description']
    readonly_fields = ['id', 'created_at', 'updated_at']


@admin.register(GameProgress)
class GameProgressAdmin(admin.ModelAdmin):
    list_display = ['student', 'game', 'times_played', 'highest_score', 'average_score', 'levels_completed']
    list_filter = ['game__game_type', 'last_played']
    search_fields = ['student__username', 'game__name']
    readonly_fields = ['id', 'created_at', 'last_played']


@admin.register(GameSession)
class GameSessionAdmin(admin.ModelAdmin):
    list_display = ['student', 'game', 'score', 'level_reached', 'completed', 'started_at']
    list_filter = ['completed', 'started_at']
    search_fields = ['student__username', 'game__name']
    readonly_fields = ['id', 'started_at']
