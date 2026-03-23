class Message {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? role;
  final String? messageType;
  final String? textContent;
  final DateTime? createdAt;

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.role,
    this.messageType,
    this.textContent,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? json['text_content'] ?? '',
      isUser: json['is_user'] ?? json['role'] == 'user',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      role: json['role'],
      messageType: json['message_type'],
      textContent: json['text_content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      if (role != null) 'role': role,
      if (messageType != null) 'message_type': messageType,
      if (textContent != null) 'text_content': textContent,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}