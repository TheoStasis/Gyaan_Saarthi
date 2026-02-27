import 'dart:io';
import 'package:flutter/material.dart';
import '../models/conversation_model.dart';
import '../services/ai_service.dart';

class ChatProvider with ChangeNotifier {
  final AIService _aiService = AIService();

  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isSending = false;  // ✅ Separate flag for sending
  bool _isOfflineMode = false;  // ✅ Offline mode flag
  String? _error;

  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;  // ✅ Add getter
  bool get isOfflineMode => _isOfflineMode;  // ✅ Offline mode getter
  String? get error => _error;

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _aiService.getConversations();
      // ✅ DON'T automatically set current conversation
      // Let the UI handle this
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading conversations: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendTextMessage(String message) async {
    debugPrint('🟢 [PROVIDER] Starting sendTextMessage: $message');

    _isSending = true;  // ✅ Use separate flag
    _error = null;
    notifyListeners();

    try {
      // Create user message
      final userMessage = Message(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        role: 'user',
        messageType: 'text',
        textContent: message,
        createdAt: DateTime.now(),
      );

      // ✅ Add user message immediately using copyWith
      if (_currentConversation != null) {
        _currentConversation = _currentConversation!.copyWith(
          messages: [..._currentConversation!.messages, userMessage],
          messageCount: _currentConversation!.messageCount + 1,
          updatedAt: DateTime.now(),
        );
        notifyListeners(); // Show user message immediately
        debugPrint('🟢 [PROVIDER] User message added. Total: ${_currentConversation!.messages.length}');
      }

      debugPrint('🟢 [PROVIDER] Calling AIService...');

      // Call backend
      final result = await _aiService.sendTextMessage(
        conversationId: _currentConversation?.id,
        message: message,
      );

      debugPrint('🟢 [PROVIDER] Got result: ${result['success']}');

      if (result['success']) {
        final aiMessage = result['message'] as Message;

        // ✅ Check if response is from offline mode
        _isOfflineMode = result['isOffline'] ?? false;

        debugPrint('🟢 [PROVIDER] AI message: ${aiMessage.textContent.substring(0, 50)}...');
        debugPrint('🟢 [PROVIDER] Offline mode: $_isOfflineMode');

        if (_currentConversation == null) {
          // First message - create new conversation
          debugPrint('🟢 [PROVIDER] Creating NEW conversation');

          _currentConversation = Conversation(
            id: result['conversationId'] ?? DateTime.now().toString(),
            title: message.length > 30 ? "${message.substring(0, 30)}..." : message,
            subject: 'general',
            language: 'hindi',
            messageCount: 2,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messages: [userMessage, aiMessage],
          );
        } else {
          // ✅ Add AI message using copyWith
          debugPrint('🟢 [PROVIDER] Adding AI message');

          _currentConversation = _currentConversation!.copyWith(
            messages: [..._currentConversation!.messages, aiMessage],
            messageCount: _currentConversation!.messageCount + 1,
            updatedAt: DateTime.now(),
          );
        }

        debugPrint('🟢 [PROVIDER] Total messages: ${_currentConversation!.messages.length}');
      } else {
        debugPrint('🔴 [PROVIDER] Error: ${result['error']}');
        _error = result['error'];

        // ✅ Remove user message if failed using copyWith
        if (_currentConversation != null) {
          _currentConversation = _currentConversation!.copyWith(
            messages: _currentConversation!.messages
                .where((m) => m.id != userMessage.id)
                .toList(),
            messageCount: _currentConversation!.messageCount - 1,
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 [PROVIDER] Exception: $e');
      debugPrint('🔴 [PROVIDER] Stack: $stackTrace');
      _error = "Connection error. Check if Ollama is running.";
    }

    _isSending = false;
    notifyListeners();

    debugPrint('🟢 [PROVIDER] COMPLETED. Messages: ${_currentConversation?.messages.length ?? 0}');
  }

  Future<void> sendAudioMessage(File audioFile) async {
    _isSending = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _aiService.sendAudioMessage(
        conversationId: _currentConversation?.id,
        audioFile: audioFile,
      );

      if (result['success']) {
        final aiMessage = result['message'] as Message;

        // ✅ Check if response is from offline mode
        _isOfflineMode = result['isOffline'] ?? false;

        if (_currentConversation == null) {
          _currentConversation = Conversation(
            id: result['conversationId'],
            title: 'Audio Chat',
            subject: 'general',
            language: 'hindi',
            messageCount: 1,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messages: [aiMessage],
          );
        } else {
          _currentConversation = _currentConversation!.copyWith(
            messages: [..._currentConversation!.messages, aiMessage],
            messageCount: _currentConversation!.messageCount + 1,
          );
        }
      } else {
        _error = result['error'];
      }
    } catch (e) {
      _error = e.toString();
    }

    _isSending = false;
    notifyListeners();
  }

  Future<void> sendImageMessage(File imageFile, {String? message}) async {
    _isSending = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _aiService.sendImageMessage(
        conversationId: _currentConversation?.id,
        imageFile: imageFile,
        message: message,
      );

      if (result['success']) {
        final aiMessage = result['message'] as Message;

        // ✅ Check if response is from offline mode
        _isOfflineMode = result['isOffline'] ?? false;

        if (_currentConversation == null) {
          _currentConversation = Conversation(
            id: result['conversationId'],
            title: 'Image Question',
            subject: 'general',
            language: 'hindi',
            messageCount: 1,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messages: [aiMessage],
          );
        } else {
          _currentConversation = _currentConversation!.copyWith(
            messages: [..._currentConversation!.messages, aiMessage],
            messageCount: _currentConversation!.messageCount + 1,
          );
        }
      } else {
        _error = result['error'];
      }
    } catch (e) {
      _error = e.toString();
    }

    _isSending = false;
    notifyListeners();
  }

  void startNewConversation() {
    _currentConversation = null;
    _isOfflineMode = false;  // ✅ Reset offline mode on new conversation
    notifyListeners();
  }

  void setCurrentConversation(Conversation? conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }
}