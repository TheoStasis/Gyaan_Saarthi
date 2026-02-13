class Message {
  final String id;
  final String role; // 'user' or 'assistant'
  final String messageType; // 'text', 'audio', 'image'
  final String textContent;
  final String? audioFile;
  final int? audioDuration;
  final String? transcribedText;
  final List<String>? images;
  final int tokensUsed;
  final double? responseTime;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.role,
    required this.messageType,
    required this.textContent,
    this.audioFile,
    this.audioDuration,
    this.transcribedText,
    this.images,
    this.tokensUsed = 0,
    this.responseTime,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      role: json['role'] ?? 'assistant',
      messageType: json['message_type'] ?? 'text',
      textContent: json['text_content'] ?? '',
      audioFile: json['audio_file'],
      audioDuration: json['audio_duration'],
      transcribedText: json['transcribed_text'],
      images: json['images'] != null 
          ? List<String>.from(json['images'])
          : null,
      tokensUsed: json['tokens_used'] ?? 0,
      responseTime: json['response_time']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'message_type': messageType,
      'text_content': textContent,
      'audio_file': audioFile,
      'audio_duration': audioDuration,
      'transcribed_text': transcribedText,
      'images': images,
      'tokens_used': tokensUsed,
      'response_time': responseTime,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Conversation {
  final String id;
  final int userId;
  final String? userName;
  final String title;
  final String? subject;
  final String? classLevel;
  final String language;
  final int messageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;

  Conversation({
    required this.id,
    this.userId = 0,
    this.userName,
    required this.title,
    this.subject,
    this.classLevel,
    required this.language,
    this.messageCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'].toString(),
      userId: json['user'] ?? 0,
      userName: json['user_name'],
      title: json['title'] ?? 'Untitled',
      subject: json['subject'],
      classLevel: json['class_level']?.toString(),
      language: json['language'] ?? 'hindi',
      messageCount: json['message_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => Message.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'user_name': userName,
      'title': title,
      'subject': subject,
      'class_level': classLevel,
      'language': language,
      'message_count': messageCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  // ✅ copyWith method for immutability
  Conversation copyWith({
    String? id,
    int? userId,
    String? userName,
    String? title,
    String? subject,
    String? classLevel,
    String? language,
    int? messageCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Message>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      classLevel: classLevel ?? this.classLevel,
      language: language ?? this.language,
      messageCount: messageCount ?? this.messageCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}