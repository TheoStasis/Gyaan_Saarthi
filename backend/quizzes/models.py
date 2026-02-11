from django.db import models
from django.conf import settings
from django.core.validators import MinValueValidator, MaxValueValidator
import uuid


class Quiz(models.Model):
    """Quiz created by teachers"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='created_quizzes'
    )
    
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    
    subject = models.CharField(max_length=100)
    class_level = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(12)]
    )
    
    # Quiz settings
    time_limit = models.IntegerField(help_text="Time limit in minutes", null=True, blank=True)
    passing_score = models.IntegerField(
        default=40,
        validators=[MinValueValidator(0), MaxValueValidator(100)]
    )
    show_answers = models.BooleanField(default=True)
    randomize_questions = models.BooleanField(default=False)
    
    # Status
    is_published = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - Class {self.class_level}"


class Question(models.Model):
    """Individual questions in a quiz"""
    
    class QuestionType(models.TextChoices):
        MULTIPLE_CHOICE = 'mcq', 'Multiple Choice'
        TRUE_FALSE = 'tf', 'True/False'
        FILL_BLANK = 'fib', 'Fill in the Blank'
        SHORT_ANSWER = 'sa', 'Short Answer'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name='questions')
    
    question_type = models.CharField(
        max_length=5,
        choices=QuestionType.choices,
        default=QuestionType.MULTIPLE_CHOICE
    )
    
    question_text = models.TextField()
    question_image = models.ImageField(upload_to='quizzes/questions/', blank=True, null=True)
    
    # For MCQ and True/False
    option_a = models.CharField(max_length=500, blank=True)
    option_b = models.CharField(max_length=500, blank=True)
    option_c = models.CharField(max_length=500, blank=True)
    option_d = models.CharField(max_length=500, blank=True)
    
    correct_answer = models.CharField(max_length=500)
    explanation = models.TextField(blank=True)
    
    points = models.IntegerField(default=1)
    order = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['order', 'created_at']
    
    def __str__(self):
        return f"Q{self.order}: {self.question_text[:50]}..."


class QuizAttempt(models.Model):
    """Student's attempt at a quiz"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name='attempts')
    student = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='quiz_attempts'
    )
    
    started_at = models.DateTimeField(auto_now_add=True)
    submitted_at = models.DateTimeField(null=True, blank=True)
    time_taken = models.IntegerField(help_text="Time taken in seconds", null=True)
    
    total_questions = models.IntegerField()
    correct_answers = models.IntegerField(default=0)
    score = models.FloatField(default=0.0)
    percentage = models.FloatField(default=0.0)
    
    is_completed = models.BooleanField(default=False)
    passed = models.BooleanField(default=False)
    
    class Meta:
        ordering = ['-started_at']
    
    def __str__(self):
        return f"{self.student.username} - {self.quiz.title}"


class Answer(models.Model):
    """Student's answer to a question"""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    attempt = models.ForeignKey(QuizAttempt, on_delete=models.CASCADE, related_name='answers')
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    
    student_answer = models.TextField()
    is_correct = models.BooleanField(default=False)
    points_earned = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)