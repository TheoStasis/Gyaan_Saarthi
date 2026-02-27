import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    // ✅ REMOVED loadConversations - don't load on every init
    // This was overwriting the new messages!
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendTextMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    debugPrint('📱 [CHAT_SCREEN] Sending: $message');

    _messageController.clear();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    debugPrint(
        '📱 [CHAT_SCREEN] Before: ${chatProvider.currentConversation?.messages.length ?? 0} messages');

    await chatProvider.sendTextMessage(message);

    debugPrint(
        '📱 [CHAT_SCREEN] After: ${chatProvider.currentConversation?.messages.length ?? 0} messages');

    _scrollToBottom();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _isRecording = false;
        });

        // ignore: use_build_context_synchronously
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        await chatProvider.sendAudioMessage(File(path));

        _scrollToBottom();
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String? text = await _showImageTextDialog();

      // ignore: use_build_context_synchronously
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.sendImageMessage(File(image.path), message: text);

      _scrollToBottom();
    }
  }

  Future<String?> _showImageTextDialog() async {
    String? text;
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Question (Optional)'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'What do you want to know about this image?',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () {
                text = controller.text.trim();
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messages = chatProvider.currentConversation?.messages ?? [];

        // ✅ Debug print
        debugPrint('🟣 [CHAT_SCREEN] Building with ${messages.length} messages');

        return Column(
          children: [
            // ✅ Offline Mode Indicator
            if (chatProvider.isOfflineMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.orange.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 16, color: Colors.orange.shade900),
                    const SizedBox(width: 8),
                    Text(
                      'Offline Mode - Limited Responses',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Messages list
            Expanded(
              child: chatProvider.isSending && messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          key: ValueKey('messages_${messages.length}'), // ✅ ADD KEY
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                              key: ValueKey(messages[index].id), // ✅ ADD KEY
                              message: messages[index],
                            );
                          },
                        ),
            ),

            // Loading indicator
            if (chatProvider.isSending)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('AI is thinking...'),
                  ],
                ),
              ),

            // Error message
            if (chatProvider.error != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade100,
                child: Text(
                  chatProvider.error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),

            // Input area
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask a question...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendTextMessage(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording ? Colors.red : null,
                      ),
                      onPressed: _toggleRecording,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed:
                          chatProvider.isSending ? null : _sendTextMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'नमस्ते! मैं आपका AI शिक्षक हूं',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'मुझसे कोई भी सवाल पूछें',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}