import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  
  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();
    final passed = percentage >= 40;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              size: 100,
              color: passed ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              passed ? 'Passed!' : 'Not Passed',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$score / $totalQuestions',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Quizzes'),
            ),
          ],
        ),
      ),
    );
  }
}