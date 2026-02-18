import 'package:flutter/material.dart';

class AlphabetGame extends StatefulWidget {
  const AlphabetGame({super.key});

  @override
  State<AlphabetGame> createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> {
  int score = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Matching Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Score: $score', style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.games, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Game Coming Soon!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Match letters with pictures'),
          ],
        ),
      ),
    );
  }
}