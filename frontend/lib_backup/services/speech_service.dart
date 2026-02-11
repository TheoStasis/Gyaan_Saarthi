import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  
  bool _isListening = false;
  
  Future<void> initialize() async {
    await _speech.initialize();
    await _tts.setLanguage('hi-IN'); // Hindi
    await _tts.setSpeechRate(0.5); // Slower for students
  }

  Future<String?> listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _isListening = true;
        String recognizedText = '';
        
        await _speech.listen(
          onResult: (result) {
            recognizedText = result.recognizedWords;
          },
          localeId: 'hi_IN', // Hindi
        );
        
        await Future.delayed(const Duration(seconds: 5));
        await _speech.stop();
        _isListening = false;
        
        return recognizedText.isNotEmpty ? recognizedText : null;
      }
    }
    return null;
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}