import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'hi'; // Default: Hindi

  String get currentLanguage => _currentLanguage;

  Map<String, String> get languages => {
    'hi': 'हिंदी',
    'en': 'English',
    'bn': 'বাংলা',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
  };

  String get currentLanguageName => languages[_currentLanguage] ?? 'हिंदी';

  Future<void> loadLanguage() async {
    final saved = await StorageService.getLanguage();
    if (saved != null && languages.containsKey(saved)) {
      _currentLanguage = saved;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languages.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      await StorageService.saveLanguage(languageCode);
      notifyListeners();
    }
  }

  // Translations
  Map<String, Map<String, String>> get translations => {
    'home': {
      'hi': 'होम',
      'en': 'Home',
      'bn': 'হোম',
      'ta': 'முகப்பு',
      'te': 'హోమ్',
      'mr': 'होम',
    },
    'ai_tutor': {
      'hi': 'AI शिक्षक',
      'en': 'AI Tutor',
      'bn': 'AI শিক্ষক',
      'ta': 'AI ஆசிரியர்',
      'te': 'AI ట్యూటర్',
      'mr': 'AI शिक्षक',
    },
    'quizzes': {
      'hi': 'क्विज़',
      'en': 'Quizzes',
      'bn': 'কুইজ',
      'ta': 'வினாடி வினா',
      'te': 'క్విజ్‌లు',
      'mr': 'क्विझ',
    },
    'games': {
      'hi': 'खेल',
      'en': 'Games',
      'bn': 'গেম',
      'ta': 'விளையாட்டுகள்',
      'te': 'ఆటలు',
      'mr': 'खेळ',
    },
    'videos': {
      'hi': 'वीडियो',
      'en': 'Videos',
      'bn': 'ভিডিও',
      'ta': 'வீடியோக்கள்',
      'te': 'వీడియోలు',
      'mr': 'व्हिडिओ',
    },
    'progress': {
      'hi': 'प्रगति',
      'en': 'Progress',
      'bn': 'অগ্রগতি',
      'ta': 'முன்னேற்றம்',
      'te': 'పురోగతి',
      'mr': 'प्रगती',
    },
    'profile': {
      'hi': 'प्रोफाइल',
      'en': 'Profile',
      'bn': 'প্রোফাইল',
      'ta': 'சுயவிவரம்',
      'te': 'ప్రొఫైల్',
      'mr': 'प्रोफाइल',
    },
    'logout': {
      'hi': 'लॉगआउट',
      'en': 'Logout',
      'bn': 'প্রস্থান',
      'ta': 'வெளியேறு',
      'te': 'లాగ్అవుట్',
      'mr': 'बाहेर पडा',
    },
    'greeting': {
      'hi': 'नमस्ते',
      'en': 'Hello',
      'bn': 'নমস্কার',
      'ta': 'வணக்கம்',
      'te': 'నమస్కారం',
      'mr': 'नमस्कार',
    },
    'welcome_message': {
      'hi': 'सीखने के लिए तैयार हैं?',
      'en': 'Ready to Learn?',
      'bn': 'শিখতে প্রস্তুত?',
      'ta': 'கற்க தயாரா?',
      'te': 'నేర్చుకోవడానికి సిద్ధంగా ఉన్నారా?',
      'mr': 'शिकायला तयार आहात?',
    },
  };

  String translate(String key) {
    return translations[key]?[_currentLanguage] ?? key;
  }
}