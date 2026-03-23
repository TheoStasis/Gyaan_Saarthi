import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Math Quizzes
import 'math/math_addition_subtraction_quiz.dart';
import 'math/math_multiplication_division_quiz.dart';

// Science Quizzes
import 'science/science_plants_animals_quiz.dart';
import 'science/science_human_body_solar_system_quiz.dart';

// Hindi Quizzes
import 'hindi/hindi_grammar_quiz.dart';
import 'hindi/hindi_comprehension_quiz.dart';

// English Quizzes
import 'english/english_grammar_vocabulary_quiz.dart';
import 'english/english_reading_comprehension_quiz.dart';

class SubjectQuizzesScreen extends StatelessWidget {
  final String subject;
  final String subjectName;
  final Color subjectColor;

  const SubjectQuizzesScreen({
    super.key,
    required this.subject,
    required this.subjectName,
    required this.subjectColor,
  });

  // ✅ STEP 1: Replace this URL with your actual Google Form link
  // To get your form link:
  // 1. Go to forms.google.com
  // 2. Create a new form with questions about quiz creation
  // 3. Click Send → Link icon → Shorten URL
  // 4. Copy the link and paste it here
  static const String _createQuizFormUrl = 'https://forms.gle/kMmYbP7XqN8rR3sT9'; // ← Replace with YOUR form link

  Future<void> _openCreateQuizForm(BuildContext context) async {
    try {
      final url = Uri.parse(_createQuizFormUrl);
      
      // Check if the URL can be launched
      final canLaunch = await canLaunchUrl(url);
      
      if (canLaunch) {
        // Open the form in external browser
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to open form. Please check your internet connection.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening form: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getQuizzesForSubject() {
    switch (subject) {
      case 'math':
        return [
          {
            'title': 'Addition & Subtraction',
            'description': 'Practice basic arithmetic operations',
            'difficulty': 'Easy',
            'questions': 10,
            'widget': const MathQuiz(),
          },
          {
            'title': 'Multiplication & Division',
            'description': 'Master times tables and division',
            'difficulty': 'Medium',
            'questions': 10,
            'widget': const MathMultiplicationDivisionQuiz(),
          },
        ];
      case 'science':
        return [
          {
            'title': 'Plants & Animals',
            'description': 'Learn about living things in nature',
            'difficulty': 'Easy',
            'questions': 10,
            'widget': const ScienceQuizPlants(),
          },
          {
            'title': 'Human Body & Solar System',
            'description': 'Explore body organs and space',
            'difficulty': 'Medium',
            'questions': 10,
            'widget': const ScienceHumanBodySolarSystemQuiz(),
          },
        ];
      case 'hindi':
        return [
          {
            'title': 'व्याकरण मूल बातें',
            'description': 'Hindi grammar fundamentals',
            'difficulty': 'Easy',
            'questions': 10,
            'widget': const HindiQuiz(),
          },
          {
            'title': 'पठन व समझ',
            'description': 'Comprehension and understanding',
            'difficulty': 'Medium',
            'questions': 10,
            'widget': const HindiComprehensionQuiz(),
          },
        ];
      case 'english':
        return [
          {
            'title': 'Grammar & Vocabulary',
            'description': 'English language basics',
            'difficulty': 'Easy',
            'questions': 10,
            'widget': const EnglishQuiz(),
          },
          {
            'title': 'Reading Comprehension',
            'description': 'Read and understand passages',
            'difficulty': 'Medium',
            'questions': 10,
            'widget': const EnglishReadingComprehensionQuiz(),
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = _getQuizzesForSubject();
    final authProvider = Provider.of<AuthProvider>(context);
    final isTeacher = authProvider.user?.role == 'teacher';

    return Scaffold(
      appBar: AppBar(
        title: Text('$subjectName Quizzes'),
        backgroundColor: subjectColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Teacher Create Quiz Button
            if (isTeacher) ...[
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _showCreateQuizDialog(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [subjectColor.withOpacity(0.7), subjectColor],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_circle, size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Create Quiz',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add new $subjectName quiz',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Available Quizzes Header
            Row(
              children: [
                Icon(Icons.quiz, color: subjectColor, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Available Quizzes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quiz Cards
            ...quizzes.map((quiz) => _buildQuizCard(context, quiz)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Map<String, dynamic> quiz) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => quiz['widget']),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.quiz, size: 36, color: subjectColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quiz['description'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: subjectColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${quiz['questions']} Questions',
                            style: TextStyle(
                              fontSize: 12,
                              color: subjectColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            quiz['difficulty'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: subjectColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.quiz, color: subjectColor, size: 30),
            const SizedBox(width: 10),
            Text('Create $subjectName Quiz'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will be redirected to Google Forms to submit your quiz questions for $subjectName.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: subjectColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: subjectColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: subjectColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please fill in all quiz details including questions, options, and correct answers.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openCreateQuizForm(context);
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Form'),
            style: ElevatedButton.styleFrom(
              backgroundColor: subjectColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}