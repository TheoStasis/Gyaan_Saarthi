import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';
import '../services/ai_service.dart';
import '../providers/language_provider.dart';

class ChatProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  
  List<Message> _messages = [];
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  List<Message> get messages => _messages;
  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get error => _error;

  Future<void> sendTextMessage(String text, LanguageProvider langProvider) async {
    if (text.trim().isEmpty) return;

    _isSending = true;
    _error = null;
    notifyListeners();

    // Add user message immediately
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    _messages.add(userMessage);
    notifyListeners();

    debugPrint('🔵 [PROVIDER] ==========================================');
    debugPrint('🔵 [PROVIDER] Sending message');
    debugPrint('🔵 [PROVIDER] Text: $text');
    debugPrint('🔵 [PROVIDER] Language: ${langProvider.currentLanguage}');
    debugPrint('🔵 [PROVIDER] Language name: ${langProvider.currentLanguageName}');
    debugPrint('🔵 [PROVIDER] ==========================================');

    try {
      // Add a "thinking" message
      final thinkingMessage = Message(
        id: 'thinking_${DateTime.now().millisecondsSinceEpoch}',
        content: 'AI is thinking...',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(thinkingMessage);
      notifyListeners();

      final response = await _aiService.sendTextMessage(
        question: text,
        conversationId: _currentConversation?.id,
        language: langProvider.currentLanguage,
      );

      // Remove thinking message
      _messages.removeWhere((m) => m.id.startsWith('thinking_'));

      if (response['success'] == true) {
        final data = response['data'];
        final aiMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: data['answer'] ?? 'No response',
          isUser: false,
          timestamp: DateTime.now(),
        );
        
        _messages.add(aiMessage);
        debugPrint('🟢 [PROVIDER] AI response added');
        debugPrint('🟢 [PROVIDER] Answer: ${aiMessage.content.substring(0, 50)}...');
      } else {
        // Remove thinking message
        _messages.removeWhere((m) => m.id.startsWith('thinking_'));
        
        _error = response['error'] ?? 'Unknown error';
        debugPrint('🔴 [PROVIDER] Error: $_error');
        
        // Add error message to chat
        final errorMessage = Message(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          content: '❌ Error: $_error',
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(errorMessage);
      }
    } catch (e) {
      // Remove thinking message
      _messages.removeWhere((m) => m.id.startsWith('thinking_'));
      
      _error = e.toString();
      debugPrint('🔴 [PROVIDER] Exception: $e');
      debugPrint('🔴 [PROVIDER] Stack: ${StackTrace.current}');
      
      // Add error message to chat
      final errorMessage = Message(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        content: '❌ Error: $_error',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isSending = false;
      notifyListeners();
      debugPrint('🟢 [PROVIDER] COMPLETED. Messages: ${_messages.length}');
      debugPrint('🔵 [PROVIDER] ==========================================');
    }
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _aiService.getConversations();
      
      if (response['success'] == true) {
        final data = response['data'] as List;
        _conversations = data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        _error = response['error'];
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('🔴 [PROVIDER] Error loading conversations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages = [];
    _currentConversation = null;
    _error = null;
    notifyListeners();
  }

  void setCurrentConversation(Conversation conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }
}