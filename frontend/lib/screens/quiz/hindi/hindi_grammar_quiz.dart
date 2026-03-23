import 'package:flutter/material.dart';

class HindiQuiz extends StatefulWidget {
  const HindiQuiz({super.key});

  @override
  State<HindiQuiz> createState() => _HindiQuizState();
}

class _HindiQuizState extends State<HindiQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '"राम स्कूल जाता है।" इस वाक्य में क्रिया क्या है?',
      'options': ['राम', 'स्कूल', 'जाता है', 'है'],
      'correct': 2,
      'explanation': '"जाता है" क्रिया है क्योंकि यह काम को दर्शाता है।',
    },
    {
      'question': 'संज्ञा किसे कहते हैं?',
      'options': ['काम का नाम', 'व्यक्ति, स्थान या वस्तु का नाम', 'गुण का नाम', 'संख्या का नाम'],
      'correct': 1,
      'explanation': 'संज्ञा किसी व्यक्ति, स्थान या वस्तु के नाम को कहते हैं।',
    },
    {
      'question': '"सुंदर" किस प्रकार का शब्द है?',
      'options': ['संज्ञा', 'सर्वनाम', 'विशेषण', 'क्रिया'],
      'correct': 2,
      'explanation': '"सुंदर" विशेषण है जो संज्ञा की विशेषता बताता है।',
    },
    {
      'question': '"मैं, तुम, वह" ये क्या हैं?',
      'options': ['संज्ञा', 'सर्वनाम', 'विशेषण', 'क्रिया'],
      'correct': 1,
      'explanation': 'मैं, तुम, वह सर्वनाम हैं जो संज्ञा की जगह प्रयोग होते हैं।',
    },
    {
      'question': 'हिंदी में लिंग कितने प्रकार के होते हैं?',
      'options': ['एक', 'दो', 'तीन', 'चार'],
      'correct': 1,
      'explanation': 'हिंदी में लिंग दो प्रकार के होते हैं - पुल्लिंग और स्त्रीलिंग।',
    },
    {
      'question': '"किताब" कौन सा लिंग है?',
      'options': ['पुल्लिंग', 'स्त्रीलिंग', 'दोनों', 'कोई नहीं'],
      'correct': 1,
      'explanation': '"किताब" स्त्रीलिंग शब्द है।',
    },
    {
      'question': 'वचन कितने प्रकार के होते हैं?',
      'options': ['एक', 'दो', 'तीन', 'चार'],
      'correct': 1,
      'explanation': 'वचन दो प्रकार के होते हैं - एकवचन और बहुवचन।',
    },
    {
      'question': '"लड़का" का बहुवचन क्या है?',
      'options': ['लड़की', 'लड़के', 'लड़कियाँ', 'लड़कों'],
      'correct': 1,
      'explanation': '"लड़का" का बहुवचन "लड़के" होता है।',
    },
    {
      'question': '"पर, से, का, की" ये क्या हैं?',
      'options': ['संज्ञा', 'सर्वनाम', 'कारक चिह्न', 'विशेषण'],
      'correct': 2,
      'explanation': 'ये कारक चिह्न हैं जो संज्ञा या सर्वनाम के साथ प्रयोग होते हैं।',
    },
    {
      'question': '"धीरे-धीरे" किस प्रकार का शब्द है?',
      'options': ['संज्ञा', 'क्रिया', 'क्रिया-विशेषण', 'विशेषण'],
      'correct': 2,
      'explanation': '"धीरे-धीरे" क्रिया-विशेषण है जो क्रिया की विशेषता बताता है।',
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
        title: const Text('📚 Quiz पूर्ण!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.book, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'आपका स्कोर',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              '$_score / ${_questions.length}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
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
            child: const Text('बंद करें'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('फिर से करें'),
          ),
        ],
      ),
    );
  }

  String _getGrade() {
    final percentage = (_score / _questions.length) * 100;
    if (percentage >= 90) return '⭐ बहुत बढ़िया!';
    if (percentage >= 70) return '👍 अच्छा काम!';
    if (percentage >= 50) return '👌 ठीक है!';
    return '💪 मेहनत करें!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('हिंदी क्विज'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
              minHeight: 8,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'प्रश्न ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'स्कोर: $_score',
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            Card(
              elevation: 4,
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.quiz, size: 40, color: Colors.orange),
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
                    return isSelected ? Colors.orange[100]! : Colors.white;
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
                          color: isSelected ? Colors.orange : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
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
                            'व्याख्या:',
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
                  backgroundColor: _hasAnswered ? Colors.green : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _hasAnswered 
                    ? (_currentQuestionIndex == _questions.length - 1 ? 'परिणाम देखें' : 'अगला प्रश्न')
                    : 'उत्तर जमा करें',
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