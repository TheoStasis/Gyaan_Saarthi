import 'package:flutter/material.dart';

class ScienceQuizPlants extends StatefulWidget {
  const ScienceQuizPlants({super.key});

  @override
  State<ScienceQuizPlants> createState() => _ScienceQuizPlantsState();
}

class _ScienceQuizPlantsState extends State<ScienceQuizPlants> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    // Plants Questions
    {
      'question': 'What do plants need to make food?',
      'options': ['Darkness', 'Sunlight', 'Rain only', 'Wind'],
      'correct': 1,
      'explanation': 'Plants need sunlight for photosynthesis to make their food.',
    },
    {
      'question': 'Which part of the plant takes in water from the soil?',
      'options': ['Leaves', 'Flowers', 'Roots', 'Stem'],
      'correct': 2,
      'explanation': 'Roots absorb water and minerals from the soil.',
    },
    {
      'question': 'What gas do plants release during photosynthesis?',
      'options': ['Carbon Dioxide', 'Nitrogen', 'Oxygen', 'Hydrogen'],
      'correct': 2,
      'explanation': 'Plants release oxygen during photosynthesis, which we breathe.',
    },
    {
      'question': 'Which of these is NOT a part of a flower?',
      'options': ['Petal', 'Leaf', 'Stamen', 'Pistil'],
      'correct': 1,
      'explanation': 'Leaves are not part of a flower; they are a separate part of the plant.',
    },
    {
      'question': 'What is the process called when plants make their own food?',
      'options': ['Respiration', 'Photosynthesis', 'Digestion', 'Transpiration'],
      'correct': 1,
      'explanation': 'Photosynthesis is the process where plants make food using sunlight.',
    },
    // Animals Questions
    {
      'question': 'Which animal is called the "King of the Jungle"?',
      'options': ['Tiger', 'Lion', 'Elephant', 'Bear'],
      'correct': 1,
      'explanation': 'The lion is known as the King of the Jungle.',
    },
    {
      'question': 'What do herbivores eat?',
      'options': ['Meat', 'Plants', 'Fish', 'Insects'],
      'correct': 1,
      'explanation': 'Herbivores are animals that eat only plants.',
    },
    {
      'question': 'Which of these animals is a mammal?',
      'options': ['Fish', 'Bird', 'Whale', 'Frog'],
      'correct': 2,
      'explanation': 'Whales are mammals that live in water and breathe air.',
    },
    {
      'question': 'How do fish breathe?',
      'options': ['Through lungs', 'Through gills', 'Through skin', 'Through nose'],
      'correct': 1,
      'explanation': 'Fish breathe through gills, which extract oxygen from water.',
    },
    {
      'question': 'Which bird cannot fly?',
      'options': ['Eagle', 'Sparrow', 'Penguin', 'Parrot'],
      'correct': 2,
      'explanation': 'Penguins cannot fly but are excellent swimmers.',
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
        title: const Text('🌿 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco, size: 60, color: Colors.green),
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
                color: Colors.green,
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getGrade() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage >= 90) return '🌟 Science Expert!';
    if (percentage >= 70) return '🌱 Great Knowledge!';
    if (percentage >= 50) return '🌿 Good Try!';
    return '🌾 Keep Learning!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Science Quiz'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 8,
            ),
            
            const SizedBox(height: 20),
            
            // Question number & Score
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
            
            // Question Card
            Card(
              elevation: 4,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.quiz, size: 40, color: Colors.green),
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
            
            // Options
            ...List.generate(
              currentQuestion['options'].length,
              (index) {
                final option = currentQuestion['options'][index];
                final isCorrect = index == currentQuestion['correct'];
                final isSelected = _selectedAnswer == index;
                
                Color getColor() {
                  if (!_hasAnswered) {
                    return isSelected ? Colors.green[100]! : Colors.white;
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
                          color: isSelected ? Colors.green : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.green,
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
            
            // Explanation (shown after answer)
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
            
            // Action Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _hasAnswered ? _nextQuestion : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasAnswered ? Colors.orange : Colors.green,
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