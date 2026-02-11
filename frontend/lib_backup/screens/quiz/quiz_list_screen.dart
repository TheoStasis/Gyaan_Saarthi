import 'package:flutter/material.dart';
import 'quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  // Sample quiz data
  final List<Map<String, dynamic>> _quizzes = [
    {
      'id': '1',
      'title': 'Math - Addition & Subtraction',
      'subject': 'Mathematics',
      'class': 5,
      'questions': 10,
      'duration': 15,
      'icon': Icons.calculate,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Science - Plants & Animals',
      'subject': 'Science',
      'class': 5,
      'questions': 15,
      'duration': 20,
      'icon': Icons.science,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Hindi - Grammar Basics',
      'subject': 'Hindi',
      'class': 5,
      'questions': 12,
      'duration': 15,
      'icon': Icons.book,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'English - Comprehension',
      'subject': 'English',
      'class': 5,
      'questions': 10,
      'duration': 20,
      'icon': Icons.language,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Available Quizzes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ..._quizzes.map((quiz) => _buildQuizCard(context, quiz)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quiz creation feature coming soon for teachers!'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Quiz'),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Map<String, dynamic> quiz) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizDetailScreen(quizId: quiz['id']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: (quiz['color'] as Color).withOpacity(0.2),
                    child: Icon(
                      quiz['icon'] as IconData,
                      color: quiz['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${quiz['subject']} - Class ${quiz['class']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.quiz,
                    '${quiz['questions']} Questions',
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    Icons.timer,
                    '${quiz['duration']} min',
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizDetailScreen(quizId: quiz['id']),
                      ),
                    );
                  },
                  child: const Text('Start Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}