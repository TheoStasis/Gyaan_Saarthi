class ApiConfig {
  // ========================================
  // CHANGE THIS TO YOUR BACKEND URL
  // ========================================
  
  // For LOCAL development (Android Emulator):
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // For LOCAL development (iOS Simulator):
  // static const String baseUrl = 'http://localhost:8000/api';
  
  // For PHYSICAL DEVICE (Replace with your computer's IP):
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // For PRODUCTION (After deploying to Render.com):
  // static const String baseUrl = 'https://your-app-name.onrender.com/api';
  
  // ========================================
  // API Endpoints
  // ========================================
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register/';
  static const String login = '$baseUrl/auth/login/';
  static const String refresh = '$baseUrl/auth/refresh/';
  static const String userMe = '$baseUrl/auth/users/me/';
  static const String updateProfile = '$baseUrl/auth/users/update_profile/';
  
  // AI Tutor endpoints
  static const String conversations = '$baseUrl/ai-tutor/conversations/';
  static const String chatText = '$baseUrl/ai-tutor/chat/text/';
  static const String chatAudio = '$baseUrl/ai-tutor/chat/audio/';
  static const String chatImage = '$baseUrl/ai-tutor/chat/image/';
  static const String feedback = '$baseUrl/ai-tutor/feedback/';
  
  // Quiz endpoints
  static const String quizzes = '$baseUrl/quizzes/quizzes/';
  static const String quizAttempts = '$baseUrl/quizzes/attempts/';
  static const String submitQuiz = '$baseUrl/quizzes/attempts/submit/';
  
  // Video endpoints
  static const String videos = '$baseUrl/videos/videos/';
  static const String videoViews = '$baseUrl/videos/views/';
  
  // Game endpoints
  static const String games = '$baseUrl/games/games/';
  static const String gameProgress = '$baseUrl/games/progress/';
  static const String gameSessions = '$baseUrl/games/sessions/';
  
  // ========================================
  // Timeouts
  // ========================================
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // ========================================
  // Helper Methods
  // ========================================
  
  static String conversationDetail(String id) => '$conversations$id/';
  static String quizDetail(String id) => '$quizzes$id/';
  static String videoDetail(String id) => '$videos$id/';
  static String gameDetail(String id) => '$games$id/';
}