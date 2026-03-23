// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    _textController.clear();

    debugPrint('📱 [CHAT_SCREEN] Before: ${chatProvider.messages.length} messages');
    debugPrint('📱 [CHAT_SCREEN] Sending in language: ${langProvider.currentLanguage}');

    await chatProvider.sendTextMessage(text, langProvider);

    debugPrint('📱 [CHAT_SCREEN] After: ${chatProvider.messages.length} messages');

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatProvider, AuthProvider, LanguageProvider>(
      builder: (context, chatProvider, authProvider, langProvider, child) {
        debugPrint('🟣 [CHAT_SCREEN] Building with ${chatProvider.messages.length} messages');

        // ✅ FIX: Use Material instead of Scaffold — fixes TextField Material ancestor
        // error WITHOUT breaking auth/token when embedded inside HomeScreen's IndexedStack
        return Material(
          color: Colors.white,
          child: Column(
            children: [
              // Messages List
              Expanded(
                child: chatProvider.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              langProvider.translate('type_message'),
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              langProvider.translate('ai_tutor_desc'),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          return MessageBubble(
                            message: message,
                            isUser: message.isUser,
                          );
                        },
                      ),
              ),

              // Error Display
              if (chatProvider.error != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red[100],
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Image Button
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () {},
                    ),

                    // Text Input
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: langProvider.translate('type_message'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendTextMessage(),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Send Button
                    chatProvider.isSending
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: _sendTextMessage,
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}