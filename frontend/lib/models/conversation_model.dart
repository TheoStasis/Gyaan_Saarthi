class Conversation {
  final String id;
  final String title;
  final String subject;
  final int? classLevel;
  final String language;
  final int messageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.title,
    required this.subject,
    this.classLevel,
    required this.language,
    required this.messageCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'] ?? 'New Conversation',
      subject: json['subject'] ?? 'general',
      classLevel: json['class_level'],
      language: json['language'] ?? 'hindi',
      messageCount: json['message_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      messages: (json['messages'] as List?)
              ?.map((m) => Message.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Message {
  final String id;
  final String role; // 'user' or 'assistant'
  final String messageType; // 'text', 'audio', 'image'
  final String textContent;
  final String? audioFile;
  final String? transcribedText;
  final List<MessageImage> images;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.role,
    required this.messageType,
    required this.textContent,
    this.audioFile,
    this.transcribedText,
    this.images = const [],
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      role: json['role'],
      messageType: json['message_type'] ?? 'text',
      textContent: json['text_content'] ?? '',
      audioFile: json['audio_file'],
      transcribedText: json['transcribed_text'],
      images: (json['images'] as List?)
              ?.map((img) => MessageImage.fromJson(img))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get displayText => transcribedText ?? textContent;
}

class MessageImage {
  final String id;
  final String imageUrl;

  MessageImage({required this.id, required this.imageUrl});

  factory MessageImage.fromJson(Map<String, dynamic> json) {
    return MessageImage(
      id: json['id'],
      imageUrl: json['image'],
    );
  }
}