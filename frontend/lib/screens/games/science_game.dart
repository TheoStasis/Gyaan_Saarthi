import 'package:flutter/material.dart';
import 'dart:math';

class ScienceQuizGame extends StatefulWidget {
  const ScienceQuizGame({super.key});

  @override
  State<ScienceQuizGame> createState() => _ScienceQuizGameState();
}

class _ScienceQuizGameState extends State<ScienceQuizGame> {
  final Random _random = Random();
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How many planets are in our solar system?',
      'options': ['7', '8', '9', '10'],
      'correct': 1,
    },
    {
      'question': 'What do plants need to make food?',
      'options': ['Sunlight', 'Darkness', 'Fire', 'Ice'],
      'correct': 0,
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'correct': 2,
    },
    {
      'question': 'What is water made of?',
      'options': ['Carbon and Oxygen', 'Hydrogen and Oxygen', 'Nitrogen and Oxygen', 'Helium and Oxygen'],
      'correct': 1,
    },
    {
      'question': 'Which organ pumps blood in our body?',
      'options': ['Brain', 'Lungs', 'Heart', 'Stomach'],
      'correct': 2,
    },
    {
      'question': 'What is the process by which plants make food?',
      'options': ['Respiration', 'Photosynthesis', 'Digestion', 'Evaporation'],
      'correct': 1,
    },
    {
      'question': 'What gas do we breathe in?',
      'options': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen'],
      'correct': 1,
    },
    {
      'question': 'How many bones are in the adult human body?',
      'options': ['106', '156', '206', '256'],
      'correct': 2,
    },
    {
      'question': 'What is the center of an atom called?',
      'options': ['Proton', 'Electron', 'Neutron', 'Nucleus'],
      'correct': 3,
    },
    {
      'question': 'What is the hardest natural substance?',
      'options': ['Gold', 'Iron', 'Diamond', 'Steel'],
      'correct': 2,
    },
    {
      'question': 'What force keeps us on the ground?',
      'options': ['Magnetism', 'Gravity', 'Friction', 'Electricity'],
      'correct': 1,
    },
    {
      'question': 'What is the boiling point of water?',
      'options': ['50°C', '100°C', '150°C', '200°C'],
      'correct': 1,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correct': 1,
    },
    {
      'question': 'What is the smallest unit of life?',
      'options': ['Atom', 'Molecule', 'Cell', 'Organ'],
      'correct': 2,
    },
    {
      'question': 'What is the speed of light?',
      'options': ['300,000 km/s', '3,000 km/s', '30,000 km/s', '3 million km/s'],
      'correct': 0,
    },
  ];
  
  Map<String, dynamic>? _currentQuestion;
  int? _selectedOption;
  bool _hasAnswered = false;
  int _score = 0;
  int _questionsAnswered = 0;
  final List<int> _usedQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    if (_usedQuestions.length == _questions.length) {
      _usedQuestions.clear(); // Reset if all questions used
    }
    
    int questionIndex;
    do {
      questionIndex = _random.nextInt(_questions.length);
    } while (_usedQuestions.contains(questionIndex));
    
    _usedQuestions.add(questionIndex);
    
    setState(() {
      _currentQuestion = _questions[questionIndex];
      _selectedOption = null;
      _hasAnswered = false;
    });
  }

  void _selectOption(int index) {
    if (_hasAnswered) return;
    
    setState(() {
      _selectedOption = index;
    });
  }

  void _submitAnswer() {
    if (_selectedOption == null || _hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      _questionsAnswered++;
      
      if (_selectedOption == _currentQuestion!['correct']) {
        _score += 10;
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      _loadNewQuestion();
    });
  }

  Color _getOptionColor(int index) {
    if (!_hasAnswered) {
      return _selectedOption == index ? Colors.blue[100]! : Colors.white;
    }
    
    if (index == _currentQuestion!['correct']) {
      return Colors.green[100]!;
    }
    
    if (index == _selectedOption && _selectedOption != _currentQuestion!['correct']) {
      return Colors.red[100]!;
    }
    
    return Colors.white;
  }

  IconData? _getOptionIcon(int index) {
    if (!_hasAnswered) return null;
    
    if (index == _currentQuestion!['correct']) {
      return Icons.check_circle;
    }
    
    if (index == _selectedOption && _selectedOption != _currentQuestion!['correct']) {
      return Icons.cancel;
    }
    
    return null;
  }

  Color? _getOptionIconColor(int index) {
    if (!_hasAnswered) return null;
    
    if (index == _currentQuestion!['correct']) {
      return Colors.green;
    }
    
    if (index == _selectedOption) {
      return Colors.red;
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Science Quiz'),
        backgroundColor: Colors.teal,
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
                  Text(
                    '$_questionsAnswered Questions',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _usedQuestions.length / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.teal,
              minHeight: 8,
            ),
            
            const SizedBox(height: 20),
            
            // Question number
            Text(
              'Question ${_usedQuestions.length}/${_questions.length}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Question Card
            Card(
              elevation: 4,
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.science,
                      size: 60,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _currentQuestion!['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
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
              _currentQuestion!['options'].length,
              (index) {
                final option = _currentQuestion!['options'][index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _selectOption(index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getOptionColor(index),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedOption == index ? Colors.teal : Colors.grey[300]!,
                          width: _selectedOption == index ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (_getOptionIcon(index) != null)
                            Icon(
                              _getOptionIcon(index),
                              color: _getOptionIconColor(index),
                              size: 30,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const Spacer(),
            
            // Submit Button
            if (!_hasAnswered)
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedOption == null ? null : _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Submit Answer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            
            // Next Question Button
            if (_hasAnswered)
              SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _loadNewQuestion,
                  icon: const Icon(Icons.arrow_forward, size: 30),
                  label: const Text(
                    'Next Question',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}