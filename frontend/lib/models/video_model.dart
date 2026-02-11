class Video {
  final String id;
  final String title;
  final String description;
  final String subject;
  final int classLevel;
  final String videoFile;
  final String? thumbnail;
  final int? duration;
  final int viewCount;
  final DateTime createdAt;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.classLevel,
    required this.videoFile,
    this.thumbnail,
    this.duration,
    required this.viewCount,
    required this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      subject: json['subject'],
      classLevel: json['class_level'],
      videoFile: json['video_file'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      viewCount: json['view_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get durationText {
    if (duration == null) return '0:00';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}