class Quiz {
  final String id;
  final String title;
  final String description;
  final String subject;
  final int classLevel;
  final int? timeLimit;
  final int passingScore;
  final bool isPublished;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.classLevel,
    this.timeLimit,
    required this.passingScore,
    required this.isPublished,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      subject: json['subject'],
      classLevel: json['class_level'],
      timeLimit: json['time_limit'],
      passingScore: json['passing_score'] ?? 40,
      isPublished: json['is_published'] ?? false,
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }
}

class Question {
  final String id;
  final String questionType; // 'mcq', 'tf', 'fib'
  final String questionText;
  final String? questionImage;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String correctAnswer;
  final String? explanation;
  final int points;

  Question({
    required this.id,
    required this.questionType,
    required this.questionText,
    this.questionImage,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    required this.correctAnswer,
    this.explanation,
    required this.points,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionType: json['question_type'],
      questionText: json['question_text'],
      questionImage: json['question_image'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'],
      points: json['points'] ?? 1,
    );
  }

  List<String> get options {
    return [optionA, optionB, optionC, optionD]
        .where((o) => o != null && o.isNotEmpty)
        .cast<String>()
        .toList();
  }
}