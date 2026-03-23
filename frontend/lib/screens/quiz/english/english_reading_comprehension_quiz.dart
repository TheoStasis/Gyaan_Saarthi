import 'package:flutter/material.dart';

class EnglishReadingComprehensionQuiz extends StatefulWidget {
  const EnglishReadingComprehensionQuiz({super.key});

  @override
  State<EnglishReadingComprehensionQuiz> createState() => _EnglishReadingComprehensionQuizState();
}

class _EnglishReadingComprehensionQuizState extends State<EnglishReadingComprehensionQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    {
      'passage': 'The sun rises in the east and sets in the west.',
      'question': 'Where does the sun rise?',
      'options': ['West', 'East', 'North', 'South'],
      'correct': 1,
      'explanation': 'The passage states that the sun rises in the east.',
    },
    {
      'passage': 'Lions are called the kings of the jungle. They are strong and brave.',
      'question': 'Why are lions called kings of the jungle?',
      'options': ['They are small', 'They are strong and brave', 'They are weak', 'They can fly'],
      'correct': 1,
      'explanation': 'The passage says lions are strong and brave, which is why they are called kings.',
    },
    {
      'passage': 'Books are our best friends. They give us knowledge and wisdom.',
      'question': 'What do books give us?',
      'options': ['Money', 'Knowledge and wisdom', 'Food', 'Toys'],
      'correct': 1,
      'explanation': 'According to the passage, books give us knowledge and wisdom.',
    },
    {
      'passage': 'The earth revolves around the sun. It takes 365 days to complete one revolution.',
      'question': 'How long does it take for Earth to revolve around the sun?',
      'options': ['30 days', '100 days', '365 days', '500 days'],
      'correct': 2,
      'explanation': 'The passage clearly states it takes 365 days.',
    },
    {
      'passage': 'Water is essential for life. We should not waste water.',
      'question': 'What should we not waste?',
      'options': ['Time', 'Water', 'Food', 'Paper'],
      'correct': 1,
      'explanation': 'The passage tells us we should not waste water.',
    },
    {
      'passage': 'Birds have wings and can fly. They build nests to lay eggs.',
      'question': 'Why do birds build nests?',
      'options': ['To sleep', 'To lay eggs', 'To play', 'To eat'],
      'correct': 1,
      'explanation': 'Birds build nests to lay eggs, as mentioned in the passage.',
    },
    {
      'passage': 'Honesty is the best policy. Always speak the truth.',
      'question': 'What should we always do?',
      'options': ['Lie', 'Speak the truth', 'Fight', 'Sleep'],
      'correct': 1,
      'explanation': 'The passage advises us to always speak the truth.',
    },
    {
      'passage': 'Trees give us oxygen, fruits, and shade. We should plant more trees.',
      'question': 'What do trees give us?',
      'options': ['Only fruits', 'Only oxygen', 'Oxygen, fruits, and shade', 'Nothing'],
      'correct': 2,
      'explanation': 'Trees give us oxygen, fruits, AND shade according to the passage.',
    },
    {
      'passage': 'Exercise keeps us healthy and fit. We should exercise daily.',
      'question': 'What keeps us healthy and fit?',
      'options': ['Sleeping all day', 'Exercise', 'Eating junk food', 'Watching TV'],
      'correct': 1,
      'explanation': 'Exercise keeps us healthy and fit, as stated in the passage.',
    },
    {
      'passage': 'The Taj Mahal is in Agra, India. It is made of white marble.',
      'question': 'What is the Taj Mahal made of?',
      'options': ['Wood', 'Brick', 'White marble', 'Iron'],
      'correct': 2,
      'explanation': 'The passage tells us the Taj Mahal is made of white marble.',
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
        title: const Text('📚 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 60, color: Colors.purple),
            const SizedBox(height: 20),
            Text('Your Score', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 10),
            Text('$_score / ${_questions.length}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 10),
            Text('${((_score / _questions.length) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 24, color: Colors.blue)),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getGrade() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage >= 90) return '⭐ Excellent Reader!';
    if (percentage >= 70) return '📖 Great Work!';
    if (percentage >= 50) return '👍 Good Effort!';
    return '📚 Keep Reading!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Quiz'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.purple,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Score: $_score', style: const TextStyle(fontSize: 16, color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 20),
            // Passage Card
            Card(
              elevation: 4,
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_stories, color: Colors.purple, size: 24),
                        SizedBox(width: 8),
                        Text('Read the passage:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple.withOpacity(0.3)),
                      ),
                      child: Text(
                        currentQuestion['passage'],
                        style: const TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Question Card
            Card(
              elevation: 4,
              color: Colors.purple[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentQuestion['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ...List.generate(currentQuestion['options'].length, (index) {
              final option = currentQuestion['options'][index];
              final isCorrect = index == currentQuestion['correct'];
              final isSelected = _selectedAnswer == index;
              
              Color getColor() {
                if (!_hasAnswered) return isSelected ? Colors.purple[100]! : Colors.white;
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
                        color: isSelected ? Colors.purple : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
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
                          Icon(Icons.lightbulb, color: Colors.blue),
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
                  backgroundColor: _hasAnswered ? Colors.green : Colors.purple,
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