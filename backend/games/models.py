from django.db import models
from django.conf import settings
import uuid


class Game(models.Model):
    """Educational game definition"""
    
    class GameType(models.TextChoices):
        ALPHABET_MATCH = 'alphabet', 'Alphabet Matching'
        NUMBER_GAME = 'number', 'Number Game'
        WORD_BUILD = 'word', 'Word Building'
        MATH_PUZZLE = 'math', 'Math Puzzle'
        GRAMMAR = 'grammar', 'Grammar Challenge'
        SCIENCE_QUIZ = 'science', 'Science Quiz'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    game_type = models.CharField(max_length=20, choices=GameType.choices)
    description = models.TextField()
    
    min_class = models.IntegerField()
    max_class = models.IntegerField()
    subject = models.CharField(max_length=100)
    
    config = models.JSONField(default=dict)
    
    is_active = models.BooleanField(default=True)
    difficulty = models.CharField(
        max_length=10,
        choices=[('easy', 'Easy'), ('medium', 'Medium'), ('hard', 'Hard')],
        default='easy'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.name} - Class {self.min_class}-{self.max_class}"


class GameProgress(models.Model):
    """Track student progress in games"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    student = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='game_progress'
    )
    game = models.ForeignKey(Game, on_delete=models.CASCADE, related_name='progress')
    
    times_played = models.IntegerField(default=0)
    highest_score = models.IntegerField(default=0)
    total_score = models.IntegerField(default=0)
    average_score = models.FloatField(default=0.0)
    
    levels_completed = models.IntegerField(default=0)
    badges_earned = models.JSONField(default=list)
    
    last_played = models.DateTimeField(auto_now=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['student', 'game']


class GameSession(models.Model):
    """Individual game play session"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    student = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='game_sessions'
    )
    game = models.ForeignKey(Game, on_delete=models.CASCADE, related_name='sessions')
    
    score = models.IntegerField(default=0)
    level_reached = models.IntegerField(default=1)
    time_played = models.IntegerField(help_text="Seconds played")
    completed = models.BooleanField(default=False)
    
    session_data = models.JSONField(default=dict)
    
    started_at = models.DateTimeField(auto_now_add=True)
    ended_at = models.DateTimeField(null=True, blank=True)