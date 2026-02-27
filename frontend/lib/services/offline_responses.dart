/// Offline responses for common questions
/// Used when internet is not available
class OfflineResponses {
  // Greetings
  static const Map<String, Map<String, String>> greetings = {
    'hi': {
      'hindi': 'नमस्ते! मैं ऑफलाइन मोड में हूं। इंटरनेट कनेक्ट करने पर मैं बेहतर मदद कर सकता हूं।',
      'english': 'Hello! I am in offline mode. Connect to internet for better help.',
    },
    'hello': {
      'hindi': 'नमस्ते! इंटरनेट कनेक्ट करें पूर्ण सुविधाओं के लिए।',
      'english': 'Hello! Connect to internet for full features.',
    },
    'नमस्ते': {
      'hindi': 'नमस्ते! मैं आपका AI शिक्षक हूं। कृपया इंटरनेट कनेक्ट करें।',
      'english': 'Namaste! I am your AI teacher. Please connect to internet.',
    },
  };

  // Common educational content (for offline use)
  static const Map<String, Map<String, String>> commonQuestions = {
    // Mathematics
    'what is addition': {
      'hindi': 'जोड़ (Addition): दो या अधिक संख्याओं को मिलाना। उदाहरण: 2 + 3 = 5',
      'english': 'Addition: Combining two or more numbers. Example: 2 + 3 = 5',
    },
    'what is subtraction': {
      'hindi': 'घटाव (Subtraction): एक संख्या से दूसरी संख्या घटाना। उदाहरण: 5 - 2 = 3',
      'english': 'Subtraction: Taking one number from another. Example: 5 - 2 = 3',
    },
    'what is multiplication': {
      'hindi': 'गुणा (Multiplication): संख्या को बार-बार जोड़ना। उदाहरण: 2 × 3 = 6',
      'english': 'Multiplication: Repeated addition. Example: 2 × 3 = 6',
    },
    'what is division': {
      'hindi': 'भाग (Division): किसी संख्या को समान भागों में बांटना। उदाहरण: 6 ÷ 2 = 3',
      'english': 'Division: Splitting a number into equal parts. Example: 6 ÷ 2 = 3',
    },

    // Science
    'what is photosynthesis': {
      'hindi': 'प्रकाश संश्लेषण: पौधे सूर्य के प्रकाश से भोजन बनाते हैं। पत्तियों में क्लोरोफिल होता है।',
      'english': 'Photosynthesis: Plants make food using sunlight. Leaves have chlorophyll.',
    },
    'what is water cycle': {
      'hindi': 'जल चक्र: पानी वाष्पीकरण → बादल → बारिश → नदी → समुद्र → फिर वाष्पीकरण',
      'english': 'Water Cycle: Water evaporation → clouds → rain → rivers → ocean → evaporation again',
    },

    // General
    'help': {
      'hindi': '''
ऑफलाइन मोड में उपलब्ध:
- बुनियादी गणित (जोड़, घटाव, गुणा, भाग)
- विज्ञान के सामान्य सवाल
- सामान्य अभिवादन

पूर्ण AI सहायता के लिए इंटरनेट कनेक्ट करें।
''',
      'english': '''
Available in Offline Mode:
- Basic math (add, subtract, multiply, divide)
- General science questions
- Common greetings

Connect to internet for full AI help.
''',
    },
  };

  /// Get offline response for a question
  static String getResponse(String question, String language) {
    final normalizedQuestion = question.toLowerCase().trim();
    
    // Check greetings
    if (greetings.containsKey(normalizedQuestion)) {
      return greetings[normalizedQuestion]?[language] ?? 
             greetings[normalizedQuestion]?['hindi'] ?? 
             _defaultOfflineMessage(language);
    }
    
    // Check common questions
    if (commonQuestions.containsKey(normalizedQuestion)) {
      return commonQuestions[normalizedQuestion]?[language] ?? 
             commonQuestions[normalizedQuestion]?['hindi'] ?? 
             _notFoundMessage(language);
    }
    
    // Not found in offline database
    return _notFoundMessage(language);
  }

  static String _defaultOfflineMessage(String language) {
    const messages = {
      'hindi': 'मैं ऑफलाइन मोड में हूं। इंटरनेट कनेक्ट करने पर मैं आपकी बेहतर मदद कर सकता हूं।',
      'english': 'I am in offline mode. Connect to internet for better assistance.',
    };
    return messages[language] ?? messages['hindi']!;
  }

  static String _notFoundMessage(String language) {
    const messages = {
      'hindi': '''
इस सवाल का जवाब ऑफलाइन मोड में उपलब्ध नहीं है।

कृपया इंटरनेट कनेक्ट करें पूर्ण AI सहायता के लिए। 🌐

ऑफलाइन में उपलब्ध विषय:
- बुनियादी गणित
- सामान्य विज्ञान
- सामान्य सवाल
''',
      'english': '''
This question is not available in offline mode.

Please connect to internet for full AI assistance. 🌐

Available offline topics:
- Basic mathematics
- General science
- Common questions
''',
    };
    return messages[language] ?? messages['hindi']!;
  }
}