import 'package:flutter/material.dart';
import 'dart:math';

class WordBuildingGame extends StatefulWidget {
  const WordBuildingGame({super.key});

  @override
  State<WordBuildingGame> createState() => _WordBuildingGameState();
}

class _WordBuildingGameState extends State<WordBuildingGame> {
  final Random _random = Random();
  
  // Word database with categories
  final Map<String, List<Map<String, String>>> _wordDatabase = {
    'Nouns': [
      {'word': 'CAT', 'hint': 'A small furry pet that says meow'},
      {'word': 'DOG', 'hint': 'A loyal pet that barks'},
      {'word': 'TREE', 'hint': 'Tall plant with leaves'},
      {'word': 'BOOK', 'hint': 'You read this'},
      {'word': 'BALL', 'hint': 'Round toy you can throw'},
      {'word': 'HOUSE', 'hint': 'Where you live'},
      {'word': 'WATER', 'hint': 'You drink this'},
      {'word': 'APPLE', 'hint': 'Red or green fruit'},
      {'word': 'CHAIR', 'hint': 'You sit on this'},
      {'word': 'TABLE', 'hint': 'You eat on this'},
    ],
    'Adjectives': [
      {'word': 'BIG', 'hint': 'Opposite of small'},
      {'word': 'HAPPY', 'hint': 'Feeling joy'},
      {'word': 'FAST', 'hint': 'Moving quickly'},
      {'word': 'COLD', 'hint': 'Not hot'},
      {'word': 'BRIGHT', 'hint': 'Full of light'},
      {'word': 'CLEAN', 'hint': 'Not dirty'},
      {'word': 'SWEET', 'hint': 'Like sugar'},
      {'word': 'SOFT', 'hint': 'Not hard'},
    ],
    'Verbs': [
      {'word': 'RUN', 'hint': 'Move fast on feet'},
      {'word': 'JUMP', 'hint': 'Go up in the air'},
      {'word': 'PLAY', 'hint': 'Have fun with games'},
      {'word': 'SING', 'hint': 'Make music with voice'},
      {'word': 'READ', 'hint': 'Look at words in a book'},
      {'word': 'WRITE', 'hint': 'Put words on paper'},
      {'word': 'SLEEP', 'hint': 'Rest at night'},
      {'word': 'DANCE', 'hint': 'Move to music'},
    ],
  };
  
  String _currentWord = '';
  String _currentHint = '';
  String _currentCategory = '';
  List<String> _scrambledLetters = [];
  List<String> _userWord = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  void _generateNewWord() {
    // Pick random category
    final categories = _wordDatabase.keys.toList();
    _currentCategory = categories[_random.nextInt(categories.length)];
    
    // Pick random word from category
    final words = _wordDatabase[_currentCategory]!;
    final wordData = words[_random.nextInt(words.length)];
    
    _currentWord = wordData['word']!;
    _currentHint = wordData['hint']!;
    
    // Scramble letters
    _scrambledLetters = _currentWord.split('')..shuffle();
    _userWord = [];
    
    setState(() {});
  }

  void _addLetter(String letter, int index) {
    setState(() {
      _userWord.add(letter);
      _scrambledLetters[index] = '';
    });
  }

  void _removeLetter(int userIndex) {
    final letter = _userWord[userIndex];
    setState(() {
      _userWord.removeAt(userIndex);
      // Put letter back in first empty spot
      final emptyIndex = _scrambledLetters.indexOf('');
      if (emptyIndex != -1) {
        _scrambledLetters[emptyIndex] = letter;
      }
    });
  }

  void _checkWord() {
    final userAnswer = _userWord.join('');
    
    if (userAnswer == _currentWord) {
      _score += _currentWord.length * 5;
      _showFeedback(true);
      Future.delayed(const Duration(seconds: 2), () {
        _generateNewWord();
      });
    } else {
      _showFeedback(false);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _userWord = [];
          _scrambledLetters = _currentWord.split('')..shuffle();
        });
      });
    }
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect 
            ? '🎉 Perfect spelling! "$_currentWord"' 
            : '❌ Not quite! Try again!',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Building'),
        backgroundColor: Colors.purple,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: Text(
                _currentCategory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Hint Card
            Card(
              color: Colors.purple[50],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'Hint:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // User's Word Area
            const Text(
              'Build the word:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: _userWord.isEmpty
                  ? const Text(
                      'Tap letters below',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  : Wrap(
                      spacing: 8,
                      children: _userWord.asMap().entries.map((entry) {
                        final index = entry.key;
                        final letter = entry.value;
                        return GestureDetector(
                          onTap: () => _removeLetter(index),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            
            const SizedBox(height: 30),
            
            // Available Letters
            const Text(
              'Available letters:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _scrambledLetters.asMap().entries.map((entry) {
                final index = entry.key;
                final letter = entry.value;
                return letter.isEmpty
                    ? const SizedBox(width: 50, height: 50)
                    : GestureDetector(
                        onTap: () => _addLetter(letter, index),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      );
              }).toList(),
            ),
            
            const Spacer(),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userWord.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _userWord = [];
                              _scrambledLetters = _currentWord.split('')..shuffle();
                            });
                          },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userWord.length != _currentWord.length
                        ? null
                        : _checkWord,
                    icon: const Icon(Icons.check),
                    label: const Text('Check'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Skip Button
            TextButton.icon(
              onPressed: () {
                _generateNewWord();
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('Skip this word'),
            ),
          ],
        ),
      ),
    );
  }
}