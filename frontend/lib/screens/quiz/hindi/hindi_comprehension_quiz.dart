import 'package:flutter/material.dart';

class HindiComprehensionQuiz extends StatefulWidget {
  const HindiComprehensionQuiz({super.key});

  @override
  State<HindiComprehensionQuiz> createState() => _HindiComprehensionQuizState();
}

class _HindiComprehensionQuizState extends State<HindiComprehensionQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '"राम रोज सुबह पार्क में दौड़ता है।" इस वाक्य में राम क्या करता है?',
      'options': ['सोता है', 'दौड़ता है', 'पढ़ता है', 'खेलता है'],
      'correct': 1,
      'explanation': 'वाक्य में लिखा है कि राम दौड़ता है।',
    },
    {
      'question': '"सूरज पूरब से निकलता है।" सूरज किस दिशा से निकलता है?',
      'options': ['पश्चिम', 'पूरब', 'उत्तर', 'दक्षिण'],
      'correct': 1,
      'explanation': 'सूरज पूरब दिशा से निकलता है।',
    },
    {
      'question': '"मेहनत का फल मीठा होता है।" इस कहावत का अर्थ क्या है?',
      'options': ['फल मीठे होते हैं', 'मेहनत करने से अच्छा परिणाम मिलता है', 'फल खाना चाहिए', 'कोई नहीं'],
      'correct': 1,
      'explanation': 'मेहनत करने से हमेशा अच्छा परिणाम मिलता है।',
    },
    {
      'question': '"पानी बचाओ, जीवन बचाओ।" इस नारे का क्या संदेश है?',
      'options': ['पानी पीना चाहिए', 'पानी की बचत करनी चाहिए', 'जीवन जीना चाहिए', 'कोई नहीं'],
      'correct': 1,
      'explanation': 'यह नारा पानी बचाने के लिए प्रेरित करता है।',
    },
    {
      'question': '"चिड़िया रानी, चिड़िया रानी, कहाँ गई थी?" यह किस विधा की पंक्ति है?',
      'options': ['कहानी', 'निबंध', 'कविता', 'पत्र'],
      'correct': 2,
      'explanation': 'यह एक बाल कविता की पंक्ति है।',
    },
    {
      'question': '"आम का पेड़ बगीचे में है।" पेड़ कहाँ है?',
      'options': ['घर में', 'बगीचे में', 'सड़क पर', 'छत पर'],
      'correct': 1,
      'explanation': 'वाक्य में स्पष्ट लिखा है कि पेड़ बगीचे में है।',
    },
    {
      'question': '"अपना हाथ जगन्नाथ।" इस कहावत का अर्थ है?',
      'options': ['हाथ बड़ा होता है', 'अपना काम खुद करना चाहिए', 'जगन्नाथ महान हैं', 'हाथ धोना चाहिए'],
      'correct': 1,
      'explanation': 'यह कहावत सिखाती है कि अपना काम खुद करना चाहिए।',
    },
    {
      'question': '"किताब मेज़ पर रखी है।" किताब कहाँ है?',
      'options': ['अलमारी में', 'मेज़ पर', 'ज़मीन पर', 'बैग में'],
      'correct': 1,
      'explanation': 'किताब मेज़ पर रखी है।',
    },
    {
      'question': '"जल ही जीवन है।" इस वाक्य में क्या बताया गया है?',
      'options': ['जल पीना चाहिए', 'पानी जीवन के लिए ज़रूरी है', 'जीवन अच्छा है', 'कोई नहीं'],
      'correct': 1,
      'explanation': 'जल यानी पानी जीवन के लिए अत्यंत आवश्यक है।',
    },
    {
      'question': '"सच्चाई की हमेशा जीत होती है।" इससे क्या सीख मिलती है?',
      'options': ['हमेशा जीतना चाहिए', 'सच बोलना चाहिए', 'झूठ बोलना चाहिए', 'कुछ नहीं'],
      'correct': 1,
      'explanation': 'हमें हमेशा सच बोलना चाहिए क्योंकि सच की जीत होती है।',
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
        title: const Text('📖 क्विज पूर्ण!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            Text('आपका स्कोर', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 10),
            Text('$_score / ${_questions.length}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange)),
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
    if (percentage >= 90) return '⭐ उत्कृष्ट!';
    if (percentage >= 70) return '👍 बहुत अच्छा!';
    if (percentage >= 50) return '👌 अच्छा प्रयास!';
    return '💪 और मेहनत करें!';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('हिंदी पठन'),
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
                Text('प्रश्न ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('स्कोर: $_score', style: const TextStyle(fontSize: 16, color: Colors.orange)),
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
                    const Icon(Icons.auto_stories, size: 40, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
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
                if (!_hasAnswered) return isSelected ? Colors.orange[100]! : Colors.white;
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
                          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
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
                          Text('व्याख्या:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  backgroundColor: _hasAnswered ? Colors.green : Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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