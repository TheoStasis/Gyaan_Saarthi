import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

class AlphabetMatchingGame extends StatefulWidget {
  const AlphabetMatchingGame({super.key});

  @override
  State<AlphabetMatchingGame> createState() => _AlphabetMatchingGameState();
}

class _AlphabetMatchingGameState extends State<AlphabetMatchingGame> {
  final FlutterTts _flutterTts = FlutterTts();
  final Random _random = Random();
  
  String _currentLetter = 'A';
  int _score = 0;
  int _totalQuestions = 0;
  bool _isPlaying = false;
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _generateNewQuestion();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _generateNewQuestion() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    _currentLetter = letters[_random.nextInt(letters.length)];
    
    // Generate 4 options including the correct one
    final optionSet = <String>{_currentLetter};
    while (optionSet.length < 4) {
      optionSet.add(letters[_random.nextInt(letters.length)]);
    }
    
    _options = optionSet.toList()..shuffle();
    setState(() {});
  }

  Future<void> _playSound() async {
    setState(() => _isPlaying = true);
    await _flutterTts.speak(_currentLetter);
    setState(() => _isPlaying = false);
  }

  void _checkAnswer(String selected) {
    _totalQuestions++;
    
    if (selected == _currentLetter) {
      _score++;
      _showFeedback(true);
    } else {
      _showFeedback(false);
    }
    
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewQuestion();
    });
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? '✅ Correct! Well done!' : '❌ Wrong! It was $_currentLetter',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Matching'),
        backgroundColor: Colors.blue,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Score: $_score/$_totalQuestions',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instructions
            const Text(
              '🎧 Listen to the letter and select the correct one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 40),
            
            // Play Sound Button
            ElevatedButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow, size: 40),
              label: Text(
                _isPlaying ? 'Playing...' : 'Play Sound',
                style: const TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Options Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final letter = _options[index];
                return ElevatedButton(
                  onPressed: _isPlaying ? null : () => _checkAnswer(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Reset Button
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _score = 0;
                  _totalQuestions = 0;
                });
                _generateNewQuestion();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Game'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}