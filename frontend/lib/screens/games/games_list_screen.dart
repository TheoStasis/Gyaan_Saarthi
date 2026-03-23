import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import 'alphabet_game.dart';
import 'number_arrangement_game.dart';
import 'math_puzzle.dart';
import 'word_building_game.dart';
import 'science_game.dart';

class GamesListScreen extends StatelessWidget {
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        // ✅ FIX: Wrapped in Scaffold so background is white instead of black
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildGameCard(
                  context,
                  title: 'Alphabet\nMatching',
                  icon: Icons.headphones,
                  color: Colors.blue,
                  description: 'Listen & match letters',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlphabetMatchingGame(),
                      ),
                    );
                  },
                ),
                _buildGameCard(
                  context,
                  title: 'Number\nGame',
                  icon: Icons.filter_1,
                  color: Colors.green,
                  description: 'Arrange numbers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NumberArrangementGame(),
                      ),
                    );
                  },
                ),
                _buildGameCard(
                  context,
                  title: 'Math\nPuzzle',
                  icon: Icons.calculate,
                  color: Colors.orange,
                  description: 'Solve math problems',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MathPuzzleGame(),
                      ),
                    );
                  },
                ),
                _buildGameCard(
                  context,
                  title: 'Word\nBuilding',
                  icon: Icons.abc,
                  color: Colors.purple,
                  description: 'Spell words correctly',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WordBuildingGame(),
                      ),
                    );
                  },
                ),
                _buildGameCard(
                  context,
                  title: 'Science\nQuiz',
                  icon: Icons.science,
                  color: Colors.teal,
                  description: 'Test your science knowledge',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScienceQuizGame(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // ignore: deprecated_member_use
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}