import 'package:flutter/material.dart';

class EnglishQuiz extends StatefulWidget {
  const EnglishQuiz({super.key});

  @override
  State<EnglishQuiz> createState() => _EnglishQuizState();
}

class _EnglishQuizState extends State<EnglishQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the opposite of "hot"?',
      'options': ['Warm', 'Cold', 'Cool', 'Heat'],
      'correct': 1,
      'explanation': 'The opposite of hot is cold - they are antonyms.',
    },
    {
      'question': 'Which word is a noun?',
      'options': ['Run', 'Beautiful', 'Book', 'Quickly'],
      'correct': 2,
      'explanation': '"Book" is a noun because it names a thing.',
    },
    {
      'question': 'Choose the correct verb: "She ___ to school every day."',
      'options': ['go', 'goes', 'going', 'gone'],
      'correct': 1,
      'explanation': 'We use "goes" with "she" in simple present tense.',
    },
    {
      'question': 'What is the plural of "child"?',
      'options': ['Childs', 'Children', 'Childrens', 'Childes'],
      'correct': 1,
      'explanation': 'The plural of child is "children" (irregular plural).',
    },
    {
      'question': '"The cat is ___ the table." Choose the correct preposition.',
      'options': ['at', 'on', 'in', 'of'],
      'correct': 1,
      'explanation': '"On" is used for surfaces, so "on the table" is correct.',
    },
    {
      'question': 'Which sentence is correct?',
      'options': ['He go to school', 'He goes to school', 'He going to school', 'He gone to school'],
      'correct': 1,
      'explanation': '"He goes to school" is the correct form in simple present tense.',
    },
    {
      'question': 'What type of word is "beautiful"?',
      'options': ['Noun', 'Verb', 'Adjective', 'Adverb'],
      'correct': 2,
      'explanation': '"Beautiful" is an adjective that describes a noun.',
    },
    {
      'question': 'Choose the correct article: "___ apple a day keeps the doctor away."',
      'options': ['A', 'An', 'The', 'No article'],
      'correct': 1,
      'explanation': 'We use "an" before words starting with vowel sounds like "apple".',
    },
    {
      'question': 'What is the past tense of "eat"?',
      'options': ['Eated', 'Ate', 'Eaten', 'Eats'],
      'correct': 1,
      'explanation': 'The past tense of eat is "ate" (irregular verb).',
    },
    {
      'question': '"I ___ my homework yesterday." Choose the correct verb.',
      'options': ['do', 'does', 'did', 'done'],
      'correct': 2,
      'explanation': 'We use "did" for past tense actions.',
    },
  ];

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswer = index;
    });
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
        title: const Text('📖 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 60, color: Colors.purple),
            const SizedBox(height: 20),
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
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${((_score / _questions.length) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 24, color: Colors.blue),
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
    if (percentage >= 90) return '⭐ Outstanding!';
    if (percentage >= 70) return '👍 Great Work!';
    if (percentage >= 50) return '👌 Good Effort!';
    return '💪 Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Quiz'),
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
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            Card(
              elevation: 4,
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.quiz, size: 40, color: Colors.purple),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            ...List.generate(
              currentQuestion['options'].length,
              (index) {
                final option = currentQuestion['options'][index];
                final isCorrect = index == currentQuestion['correct'];
                final isSelected = _selectedAnswer == index;
                
                Color getColor() {
                  if (!_hasAnswered) {
                    return isSelected ? Colors.purple[100]! : Colors.white;
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
                          color: isSelected ? Colors.purple : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (_hasAnswered && isCorrect)
                            const Icon(Icons.check_circle, color: Colors.green, size: 28),
                          if (_hasAnswered && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: Colors.red, size: 28),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
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
                          Text(
                            'Explanation:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion['explanation'],
                        style: const TextStyle(fontSize: 14),
                      ),
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