import 'package:flutter/material.dart';
import 'dart:math';

class MathQuiz extends StatefulWidget {
  const MathQuiz({super.key});

  @override
  State<MathQuiz> createState() => _MathQuizState();
}

class _MathQuizState extends State<MathQuiz> {
  final Random _random = Random();
  
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    // Generate 10 random math questions
    for (int i = 0; i < 10; i++) {
      final isAddition = _random.nextBool();
      
      if (isAddition) {
        // Addition question
        final num1 = _random.nextInt(50) + 1;
        final num2 = _random.nextInt(50) + 1;
        final correct = num1 + num2;
        
        _questions.add({
          'question': 'What is $num1 + $num2?',
          'correct': correct,
          'options': _generateOptions(correct),
        });
      } else {
        // Subtraction question
        final num1 = _random.nextInt(50) + 20;
        final num2 = _random.nextInt(num1);
        final correct = num1 - num2;
        
        _questions.add({
          'question': 'What is $num1 - $num2?',
          'correct': correct,
          'options': _generateOptions(correct),
        });
      }
    }
  }

  List<int> _generateOptions(int correct) {
    final options = <int>{correct};
    while (options.length < 4) {
      final offset = _random.nextInt(20) - 10;
      if (correct + offset > 0) {
        options.add(correct + offset);
      }
    }
    return options.toList()..shuffle();
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null || _hasAnswered) return;
    
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedValue = currentQuestion['options'][_selectedAnswer!];
    
    setState(() {
      _hasAnswered = true;
      if (selectedValue == currentQuestion['correct']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              '$_score / ${_questions.length}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${((_score / _questions.length) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(
              _getGrade(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedAnswer = null;
                _hasAnswered = false;
                _questions.clear();
              });
              _generateQuestions();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getGrade() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage >= 90) return '⭐ Excellent!';
    if (percentage >= 70) return '👍 Good Job!';
    if (percentage >= 50) return '👌 Not Bad!';
    return '💪 Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Quiz'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 8,
            ),
            
            const SizedBox(height: 20),
            
            // Question number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Question
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Options
            ...List.generate(
              currentQuestion['options'].length,
              (index) {
                final option = currentQuestion['options'][index];
                final isCorrect = option == currentQuestion['correct'];
                final isSelected = _selectedAnswer == index;
                
                Color getColor() {
                  if (!_hasAnswered) {
                    return isSelected ? Colors.blue[100]! : Colors.white;
                  }
                  if (isCorrect) return Colors.green[100]!;
                  if (isSelected && !isCorrect) return Colors.red[100]!;
                  return Colors.white;
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _selectAnswer(index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            option.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_hasAnswered && isCorrect)
                            const Icon(Icons.check_circle, color: Colors.green, size: 30),
                          if (_hasAnswered && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: Colors.red, size: 30),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const Spacer(),
            
            // Action Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _hasAnswered ? _nextQuestion : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasAnswered ? Colors.orange : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _hasAnswered 
                    ? (_currentQuestionIndex == _questions.length - 1 ? 'Show Results' : 'Next Question')
                    : 'Submit Answer',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}