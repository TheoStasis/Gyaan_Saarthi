import 'dart:io';
import '../models/conversation_model.dart';
import '../services/ai_service.dart';
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _aiService.getConversations();
      if (_conversations.isNotEmpty) {
        _currentConversation = _conversations.first;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendTextMessage(String message) async {
    if (kDebugMode) {
      print('🟢 [PROVIDER] Starting sendTextMessage: $message');
    }
    
    _isLoading = true;
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

      // ✅ FIX: Add user message immediately to show in UI
      if (_currentConversation != null) {
        // Create NEW conversation object with updated messages
        _currentConversation = Conversation(
          id: _currentConversation!.id,
          title: _currentConversation!.title,
          subject: _currentConversation!.subject,
          classLevel: _currentConversation!.classLevel,
          language: _currentConversation!.language,
          messageCount: _currentConversation!.messageCount + 1,
          isActive: _currentConversation!.isActive,
          createdAt: _currentConversation!.createdAt,
          updatedAt: DateTime.now(),
          messages: [..._currentConversation!.messages, userMessage],
        );
        notifyListeners(); // Show user message immediately
        if (kDebugMode) {
          print('🟢 [PROVIDER] User message added to existing conversation');
        }
      }

      if (kDebugMode) {
        print('🟢 [PROVIDER] Calling AIService...');
      }
      
      // Call backend
      final result = await _aiService.sendTextMessage(
        conversationId: _currentConversation?.id,
        message: message,
      );

      if (kDebugMode) {
        print('🟢 [PROVIDER] Got result: $result');
      }
      if (kDebugMode) {
        print('🟢 [PROVIDER] Success: ${result['success']}');
      }

      if (result['success']) {
        final aiMessage = result['message'] as Message;
        
        if (kDebugMode) {
          print('🟢 [PROVIDER] AI message received: ${aiMessage.textContent.substring(0, 50)}...');
        }

        if (_currentConversation == null) {
          // First message - create new conversation
          if (kDebugMode) {
            print('🟢 [PROVIDER] Creating NEW conversation');
          }
          
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
          // ✅ FIX: Create NEW conversation object (don't modify existing)
          if (kDebugMode) {
            print('🟢 [PROVIDER] Adding AI message to conversation');
          }
          
          _currentConversation = Conversation(
            id: _currentConversation!.id,
            title: _currentConversation!.title,
            subject: _currentConversation!.subject,
            classLevel: _currentConversation!.classLevel,
            language: _currentConversation!.language,
            messageCount: _currentConversation!.messageCount + 1,
            isActive: _currentConversation!.isActive,
            createdAt: _currentConversation!.createdAt,
            updatedAt: DateTime.now(),
            messages: [..._currentConversation!.messages, aiMessage],
          );
        }
        
        if (kDebugMode) {
          print('🟢 [PROVIDER] Total messages: ${_currentConversation!.messages.length}');
        }
      } else {
        if (kDebugMode) {
          print('🔴 [PROVIDER] Error: ${result['error']}');
        }
        _error = result['error'];
        
        // Remove user message if failed
        if (_currentConversation != null) {
          _currentConversation = Conversation(
            id: _currentConversation!.id,
            title: _currentConversation!.title,
            subject: _currentConversation!.subject,
            classLevel: _currentConversation!.classLevel,
            language: _currentConversation!.language,
            messageCount: _currentConversation!.messageCount - 1,
            isActive: _currentConversation!.isActive,
            createdAt: _currentConversation!.createdAt,
            updatedAt: DateTime.now(),
            messages: _currentConversation!.messages.where((m) => m.id != userMessage.id).toList(),
          );
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('🔴 [PROVIDER] Exception: $e');
      }
      if (kDebugMode) {
        print('🔴 [PROVIDER] Stack: $stackTrace');
      }
      _error = "Server connection timed out. Check Ollama on P: drive.";
    }

    _isLoading = false;
    notifyListeners();
    
    if (kDebugMode) {
      print('🟢 [PROVIDER] sendTextMessage COMPLETED. Messages: ${_currentConversation?.messages.length ?? 0}');
    }
  }

  Future<void> sendAudioMessage(File audioFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _aiService.sendAudioMessage(
        conversationId: _currentConversation?.id,
        audioFile: audioFile,
      );

      if (result['success']) {
        final aiMessage = result['message'] as Message;
        
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
          _currentConversation = Conversation(
            id: _currentConversation!.id,
            title: _currentConversation!.title,
            subject: _currentConversation!.subject,
            classLevel: _currentConversation!.classLevel,
            language: _currentConversation!.language,
            messageCount: _currentConversation!.messageCount + 1,
            isActive: _currentConversation!.isActive,
            createdAt: _currentConversation!.createdAt,
            updatedAt: DateTime.now(),
            messages: [..._currentConversation!.messages, aiMessage],
          );
        }
      } else {
        _error = result['error'];
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendImageMessage(File imageFile, {String? message}) async {
    _isLoading = true;
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
          _currentConversation = Conversation(
            id: _currentConversation!.id,
            title: _currentConversation!.title,
            subject: _currentConversation!.subject,
            classLevel: _currentConversation!.classLevel,
            language: _currentConversation!.language,
            messageCount: _currentConversation!.messageCount + 1,
            isActive: _currentConversation!.isActive,
            createdAt: _currentConversation!.createdAt,
            updatedAt: DateTime.now(),
            messages: [..._currentConversation!.messages, aiMessage],
          );
        }
      } else {
        _error = result['error'];
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void startNewConversation() {
    _currentConversation = null;
    notifyListeners();
  }
}