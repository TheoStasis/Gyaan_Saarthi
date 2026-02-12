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
      final userMessage = Message(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        role: 'user',
        messageType: 'text',
        textContent: message,
        createdAt: DateTime.now(),
      );

      if (_currentConversation != null) {
        _currentConversation!.messages.add(userMessage);
        notifyListeners(); 
      }

      final result = await _aiService.sendTextMessage(
        conversationId: _currentConversation?.id,
        message: message,
      );

      if (result['success']) {
        final aiMessage = result['message'] as Message;

        if (_currentConversation == null) {
          _currentConversation = Conversation(
            id: result['conversationId'],
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
          _currentConversation!.messages.add(aiMessage);
        }
      } else {
        _error = result['error'];
        _currentConversation?.messages.remove(userMessage);
      }
    } catch (e) {
      _error = "Server connection timed out. Check Ollama on P: drive.";
    }

    _isLoading = false;
    notifyListeners(); 
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
          _currentConversation!.messages.add(aiMessage);
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

  // FIXED: Separated from sendAudioMessage and added missing brace
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
          _currentConversation!.messages.add(aiMessage);
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