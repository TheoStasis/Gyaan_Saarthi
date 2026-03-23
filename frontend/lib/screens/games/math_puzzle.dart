import 'package:flutter/material.dart';
import 'dart:math';

class MathPuzzleGame extends StatefulWidget {
  const MathPuzzleGame({super.key});

  @override
  State<MathPuzzleGame> createState() => _MathPuzzleGameState();
}

class _MathPuzzleGameState extends State<MathPuzzleGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  int _score = 0;
  int _totalQuestions = 0;
  int _streak = 0;
  
  final List<String> _operators = ['+', '-', '×', '÷'];

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  void _generateNewProblem() {
    _operator = _operators[_random.nextInt(_operators.length)];
    
    switch (_operator) {
      case '+':
        _num1 = _random.nextInt(50) + 1;
        _num2 = _random.nextInt(50) + 1;
        _correctAnswer = _num1 + _num2;
        break;
      case '-':
        _num1 = _random.nextInt(50) + 20;
        _num2 = _random.nextInt(_num1);
        _correctAnswer = _num1 - _num2;
        break;
      case '×':
        _num1 = _random.nextInt(12) + 1;
        _num2 = _random.nextInt(12) + 1;
        _correctAnswer = _num1 * _num2;
        break;
      case '÷':
        _num2 = _random.nextInt(10) + 1;
        final quotient = _random.nextInt(12) + 1;
        _num1 = _num2 * quotient;
        _correctAnswer = quotient;
        break;
    }
    
    _answerController.clear();
    setState(() {});
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    
    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    _totalQuestions++;
    
    if (userAnswer == _correctAnswer) {
      _score += 10;
      _streak++;
      _showFeedback(true);
    } else {
      _streak = 0;
      _showFeedback(false);
    }
    
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewProblem();
    });
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect 
            ? '✅ Correct! ${_streak > 1 ? "🔥 Streak: $_streak" : ""}' 
            : '❌ Wrong! Correct answer: $_correctAnswer',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _getOperatorSymbol() {
    switch (_operator) {
      case '×':
        return '×';
      case '÷':
        return '÷';
      default:
        return _operator;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Puzzle'),
        backgroundColor: Colors.orange,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_streak > 1)
                    Text(
                      '🔥 $_streak',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(  // ✅ ADDED - Makes it scrollable!
        padding: const EdgeInsets.all(16),  // ✅ REDUCED padding
        child: Column(
          children: [
            // Score Info Card - COMPACT VERSION
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12),  // ✅ REDUCED padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Correct', '$_score', Colors.green),
                    _buildStatColumn('Total', '$_totalQuestions', Colors.blue),
                    if (_totalQuestions > 0)
                      _buildStatColumn(
                        'Accuracy',
                        '${((_score / 10) / _totalQuestions * 100).toStringAsFixed(0)}%',
                        Colors.purple,
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),  // ✅ REDUCED spacing
            
            // Problem Display - COMPACT VERSION
            Container(
              padding: const EdgeInsets.all(20),  // ✅ REDUCED padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Solve this:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),  // ✅ SMALLER font
                  ),
                  const SizedBox(height: 12),  // ✅ REDUCED spacing
                  Wrap(  // ✅ CHANGED to Wrap for better responsiveness
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    children: [
                      Text(
                        _num1.toString(),
                        style: const TextStyle(
                          fontSize: 40,  // ✅ SMALLER font
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        _getOperatorSymbol(),
                        style: const TextStyle(
                          fontSize: 40,  // ✅ SMALLER font
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        _num2.toString(),
                        style: const TextStyle(
                          fontSize: 40,  // ✅ SMALLER font
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Text(
                        '=',
                        style: TextStyle(
                          fontSize: 40,  // ✅ SMALLER font
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        '?',
                        style: TextStyle(
                          fontSize: 40,  // ✅ SMALLER font
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),  // ✅ REDUCED spacing
            
            // Answer Input
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),  // ✅ SMALLER font
              decoration: InputDecoration(
                hintText: 'Your answer',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange, width: 3),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),  // ✅ REDUCED padding
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            
            const SizedBox(height: 20),  // ✅ REDUCED spacing
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,  // ✅ SLIGHTLY smaller
              child: ElevatedButton.icon(
                onPressed: _checkAnswer,
                icon: const Icon(Icons.check_circle, size: 26),
                label: const Text(
                  'Submit Answer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  // ✅ SMALLER font
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            
            const SizedBox(height: 12),  // ✅ REDUCED spacing
            
            // Skip Button
            TextButton.icon(
              onPressed: () {
                _totalQuestions++;
                _streak = 0;
                _generateNewProblem();
              },
              icon: const Icon(Icons.skip_next, size: 20),
              label: const Text('Skip this problem'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 20),  // ✅ Bottom padding for keyboard
          ],
        ),
      ),
    );
  }

  // ✅ HELPER METHOD for stat columns
  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,  // ✅ SMALLER font
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}