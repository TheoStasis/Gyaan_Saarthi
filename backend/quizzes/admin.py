from django.contrib import admin
from .models import Quiz, Question, QuizAttempt, Answer


class QuestionInline(admin.TabularInline):
    model = Question
    extra = 1
    fields = ['question_text', 'question_type', 'correct_answer', 'points', 'order']


@admin.register(Quiz)
class QuizAdmin(admin.ModelAdmin):
    list_display = ['title', 'created_by', 'subject', 'class_level', 'is_published', 'is_active', 'created_at']
    list_filter = ['subject', 'class_level', 'is_published', 'is_active', 'created_at']
    search_fields = ['title', 'description', 'created_by__username']
    inlines = [QuestionInline]
    readonly_fields = ['id', 'created_at', 'updated_at']


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ['quiz', 'question_type', 'question_preview', 'points', 'order']
    list_filter = ['question_type', 'quiz__subject']
    search_fields = ['question_text', 'quiz__title']
    readonly_fields = ['id', 'created_at']
    
    def question_preview(self, obj):
        return obj.question_text[:50] + '...' if len(obj.question_text) > 50 else obj.question_text
    question_preview.short_description = 'Question'


@admin.register(QuizAttempt)
class QuizAttemptAdmin(admin.ModelAdmin):
    list_display = ['student', 'quiz', 'percentage', 'passed', 'is_completed', 'started_at']
    list_filter = ['passed', 'is_completed', 'started_at']
    search_fields = ['student__username', 'quiz__title']
    readonly_fields = ['id', 'started_at']


@admin.register(Answer)
class AnswerAdmin(admin.ModelAdmin):
    list_display = ['attempt', 'question', 'is_correct', 'points_earned', 'created_at']
    list_filter = ['is_correct', 'created_at']
    readonly_fields = ['id', 'created_at']