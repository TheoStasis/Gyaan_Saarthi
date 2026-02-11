class User {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'teacher' or 'student'
  final String? phone;
  final String? profilePicture;
  final StudentProfile? studentProfile;
  final TeacherProfile? teacherProfile;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.profilePicture,
    this.studentProfile,
    this.teacherProfile,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'student',
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      studentProfile: json['student_profile'] != null
          ? StudentProfile.fromJson(json['student_profile'])
          : null,
      teacherProfile: json['teacher_profile'] != null
          ? TeacherProfile.fromJson(json['teacher_profile'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'phone': phone,
      'profile_picture': profilePicture,
      'student_profile': studentProfile?.toJson(),
      'teacher_profile': teacherProfile?.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName'.trim();
  bool get isTeacher => role == 'teacher';
  bool get isStudent => role == 'student';
}

class StudentProfile {
  final int classLevel;
  final String schoolName;
  final String? rollNumber;
  final String? section;
  final String preferredLanguage;
  final String? learningStyle;

  StudentProfile({
    required this.classLevel,
    required this.schoolName,
    this.rollNumber,
    this.section,
    required this.preferredLanguage,
    this.learningStyle,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      classLevel: json['class_level'] ?? 1,
      schoolName: json['school_name'] ?? '',
      rollNumber: json['roll_number'],
      section: json['section'],
      preferredLanguage: json['preferred_language'] ?? 'hindi',
      learningStyle: json['learning_style'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_level': classLevel,
      'school_name': schoolName,
      'roll_number': rollNumber,
      'section': section,
      'preferred_language': preferredLanguage,
      'learning_style': learningStyle,
    };
  }

  String get classDisplay => 'Class $classLevel';
}

class TeacherProfile {
  final String schoolName;
  final String? schoolCode;
  final String subjects;
  final String? classesTaught;
  final int experienceYears;
  final bool isVerified;

  TeacherProfile({
    required this.schoolName,
    this.schoolCode,
    required this.subjects,
    this.classesTaught,
    required this.experienceYears,
    required this.isVerified,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      schoolName: json['school_name'] ?? '',
      schoolCode: json['school_code'],
      subjects: json['subjects'] ?? '',
      classesTaught: json['classes_taught'],
      experienceYears: json['experience_years'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'school_code': schoolCode,
      'subjects': subjects,
      'classes_taught': classesTaught,
      'experience_years': experienceYears,
      'is_verified': isVerified,
    };
  }

  List<String> get subjectsList => subjects.split(',').map((s) => s.trim()).toList();
}