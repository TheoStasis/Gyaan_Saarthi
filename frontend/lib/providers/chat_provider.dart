import 'dart:io';
import 'package:flutter/material.dart';
import '../models/conversation_model.dart';
import '../services/ai_service.dart';

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _aiService.sendTextMessage(
        conversationId: _currentConversation?.id,
        message: message,
      );

      if (result['success']) {
        // Add user message
        final userMessage = Message(
          id: DateTime.now().toString(),
          role: 'user',
          messageType: 'text',
          textContent: message,
          createdAt: DateTime.now(),
        );

        // Add AI response
        final aiMessage = result['message'] as Message;

        if (_currentConversation == null) {
          _currentConversation = Conversation(
            id: result['conversationId'],
            title: 'New Chat',
            subject: 'general',
            language: 'hindi',
            messageCount: 2,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messages: [userMessage, aiMessage],
          );
        } else {
          _currentConversation = Conversation(
            id: _currentConversation!.id,
            title: _currentConversation!.title,
            subject: _currentConversation!.subject,
            classLevel: _currentConversation!.classLevel,
            language: _currentConversation!.language,
            messageCount: _currentConversation!.messageCount + 2,
            isActive: _currentConversation!.isActive,
            createdAt: _currentConversation!.createdAt,
            updatedAt: DateTime.now(),
            messages: [
              ..._currentConversation!.messages,
              userMessage,
              aiMessage,
            ],
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

  Future<void> sendAudioMessage(File audioFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _aiService.sendAudioMessage(
        conversationId: _currentConversation?.id,
        audioFile: audioFile,
      );

      if (result['success']) {
        final message = result['message'] as Message;
        _currentConversation?.messages.add(message);
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
    notifyListeners();

    try {
      final result = await _aiService.sendImageMessage(
        conversationId: _currentConversation?.id,
        imageFile: imageFile,
        message: message,
      );

      if (result['success']) {
        final aiMessage = result['message'] as Message;
        _currentConversation?.messages.add(aiMessage);
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