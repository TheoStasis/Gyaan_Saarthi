import 'package:flutter/material.dart';

class ScienceHumanBodySolarSystemQuiz extends StatefulWidget {
  const ScienceHumanBodySolarSystemQuiz({super.key});

  @override
  State<ScienceHumanBodySolarSystemQuiz> createState() => _ScienceHumanBodySolarSystemQuizState();
}

class _ScienceHumanBodySolarSystemQuizState extends State<ScienceHumanBodySolarSystemQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    // Human Body Questions
    {
      'question': 'Which organ pumps blood throughout the body?',
      'options': ['Brain', 'Lungs', 'Heart', 'Liver'],
      'correct': 2,
      'explanation': 'The heart pumps blood to all parts of the body.',
    },
    {
      'question': 'How many bones are in the adult human body?',
      'options': ['106', '156', '206', '256'],
      'correct': 2,
      'explanation': 'An adult human body has 206 bones.',
    },
    {
      'question': 'Which organ helps us breathe?',
      'options': ['Heart', 'Lungs', 'Kidneys', 'Stomach'],
      'correct': 1,
      'explanation': 'The lungs help us breathe by taking in oxygen and releasing carbon dioxide.',
    },
    {
      'question': 'What is the largest organ in the human body?',
      'options': ['Liver', 'Brain', 'Skin', 'Heart'],
      'correct': 2,
      'explanation': 'The skin is the largest organ, covering our entire body.',
    },
    {
      'question': 'Which part of the body controls all our actions?',
      'options': ['Heart', 'Brain', 'Stomach', 'Muscles'],
      'correct': 1,
      'explanation': 'The brain controls all our thoughts, movements, and body functions.',
    },
    // Solar System Questions
    {
      'question': 'How many planets are in our solar system?',
      'options': ['7', '8', '9', '10'],
      'correct': 1,
      'explanation': 'There are 8 planets in our solar system.',
    },
    {
      'question': 'Which is the largest planet in our solar system?',
      'options': ['Earth', 'Saturn', 'Jupiter', 'Neptune'],
      'correct': 2,
      'explanation': 'Jupiter is the largest planet in our solar system.',
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Mercury', 'Saturn'],
      'correct': 1,
      'explanation': 'Mars is called the Red Planet because of its reddish appearance.',
    },
    {
      'question': 'What is at the center of our solar system?',
      'options': ['Earth', 'Moon', 'Sun', 'Jupiter'],
      'correct': 2,
      'explanation': 'The Sun is at the center of our solar system.',
    },
    {
      'question': 'Which is the closest planet to the Sun?',
      'options': ['Venus', 'Mercury', 'Earth', 'Mars'],
      'correct': 1,
      'explanation': 'Mercury is the closest planet to the Sun.',
    },
  ];

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    setState(() => _selectedAnswer = index);
  }

  void _submitAnswer() {
    if (_selectedAnswer == null || _hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      if (_selectedAnswer == _questions[_currentQuestionIndex]['correct']) {
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
        title: const Text('🌟 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.science, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text('Your Score', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 10),
            Text(
              '$_score / ${_questions.length}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              '${((_score / _questions.length) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 24, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(_getGrade(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getGrade() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage >= 90) return '🌟 Science Star!';
    if (percentage >= 70) return '🎯 Well Done!';
    if (percentage >= 50) return '👍 Good Try!';
    return '📚 Keep Learning!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body & Space Quiz'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Score: $_score', style: const TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      _currentQuestionIndex < 5 ? Icons.favorite : Icons.public,
                      size: 40,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ...List.generate(currentQuestion['options'].length, (index) {
              final option = currentQuestion['options'][index];
              final isCorrect = index == currentQuestion['correct'];
              final isSelected = _selectedAnswer == index;
              
              Color getColor() {
                if (!_hasAnswered) return isSelected ? Colors.green[100]! : Colors.white;
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
                        color: isSelected ? Colors.green : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(option, style: const TextStyle(fontSize: 16))),
                        if (_hasAnswered && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green, size: 28),
                        if (_hasAnswered && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red, size: 28),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (_hasAnswered)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(currentQuestion['explanation'], style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _hasAnswered ? _nextQuestion : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasAnswered ? Colors.orange : Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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