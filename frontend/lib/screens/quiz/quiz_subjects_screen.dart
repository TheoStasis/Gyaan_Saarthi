// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'subject_quizzes_screen.dart';

class QuizSubjectsScreen extends StatelessWidget {
  const QuizSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Use Material instead of Scaffold to fix black background
    // without causing nested Scaffold issues inside HomeScreen
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📚 Choose a Subject',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a subject to see available quizzes',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildSubjectCard(
                    context,
                    title: 'Math',
                    icon: Icons.calculate,
                    color: Colors.blue,
                    quizCount: '2 Quizzes',
                    subject: 'math',
                  ),
                  _buildSubjectCard(
                    context,
                    title: 'Science',
                    icon: Icons.science,
                    color: Colors.green,
                    quizCount: '2 Quizzes',
                    subject: 'science',
                  ),
                  _buildSubjectCard(
                    context,
                    title: 'Hindi',
                    icon: Icons.book,
                    color: Colors.orange,
                    quizCount: '2 Quizzes',
                    subject: 'hindi',
                  ),
                  _buildSubjectCard(
                    context,
                    title: 'English',
                    icon: Icons.language,
                    color: Colors.purple,
                    quizCount: '2 Quizzes',
                    subject: 'english',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String quizCount,
    required String subject,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubjectQuizzesScreen(
                subject: subject,
                subjectName: title,
                subjectColor: color,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 45, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  quizCount,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}