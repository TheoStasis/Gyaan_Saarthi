import 'package:flutter/material.dart';
import 'alphabet_game.dart';

class GamesListScreen extends StatelessWidget {
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Educational Games',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildGameCard(
          context,
          'Alphabet Matching',
          'Match letters with pictures',
          Icons.abc,
          Colors.blue,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AlphabetGame()),
            );
          },
        ),
        _buildGameCard(
          context,
          'Number Game',
          'Learn counting 1 to 100',
          Icons.numbers,
          Colors.green,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Number game coming soon!')),
            );
          },
        ),
        _buildGameCard(
          context,
          'Math Puzzle',
          'Solve addition and subtraction',
          Icons.calculate,
          Colors.orange,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Math puzzle coming soon!')),
            );
          },
        ),
        _buildGameCard(
          context,
          'Word Building',
          'Create words from letters',
          Icons.spellcheck,
          Colors.purple,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Word building coming soon!')),
            );
          },
        ),
        _buildGameCard(
          context,
          'Science Quiz',
          'Test your science knowledge',
          Icons.science,
          Colors.red,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Science quiz coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: color.withValues(alpha: 0.1), // ✅ FIXED: Changed from Colors.black to color
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}