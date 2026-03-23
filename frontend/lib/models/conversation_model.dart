class Conversation {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;

  Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Conversation',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      userId: json['user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (userId != null) 'user_id': userId,
    };
  }
}