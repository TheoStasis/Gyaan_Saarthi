class ApiConfig {
  // ========================================
  // BASE URL - UPDATE THIS TO YOUR COMPUTER'S IP
  // ========================================
  static const String baseUrl = 'http://10.0.2.2:8000';// ← CHANGE IF NEEDED!
  
  // ========================================
  // API ENDPOINTS
  // ========================================
  
  // Auth endpoints
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String refresh = '/api/auth/refresh/';
  static const String userMe = '/api/auth/me/';
  static const String updateProfile = '/api/auth/me/update/';
  
  // AI Tutor endpoints
  static const String conversations = '/api/ai-tutor/conversations/';
  static const String chatText = '/api/ai-tutor/chat/text/';
  static const String chatAudio = '/api/ai-tutor/chat/audio/';
  static const String chatImage = '/api/ai-tutor/chat/image/';
  static const String feedback = '/api/ai-tutor/feedback/';
  
  // Quiz endpoints
  static const String quizzes = '/api/quizzes/quizzes/';
  static const String quizAttempts = '/api/quizzes/attempts/';
  static const String submitQuiz = '/api/quizzes/attempts/submit/';
  
  // Video endpoints
  static const String videos = '/api/videos/videos/';
  static const String videoViews = '/api/videos/views/';
  
  // Game endpoints
  static const String games = '/api/games/games/';
  static const String gameProgress = '/api/games/progress/';
  static const String gameSessions = '/api/games/sessions/';
  
  // ========================================
  // TIMEOUTS - INCREASED FOR AI PROCESSING
  // ========================================
  static const Duration connectTimeout = Duration(minutes: 3);  // ✅ 3 MINUTES!
  static const Duration receiveTimeout = Duration(minutes: 5);  // ✅ 5 MINUTES!
  static const Duration sendTimeout = Duration(minutes: 3);     // ✅ 3 MINUTES!
  
  // ========================================
  // HELPER METHODS
  // ========================================
  static String conversationDetail(String id) => '$conversations$id/';
  static String quizDetail(String id) => '$quizzes$id/';
  static String videoDetail(String id) => '$videos$id/';
  static String gameDetail(String id) => '$games$id/';
  static String fullUrl(String endpoint) => '$baseUrl$endpoint';
  static String mediaUrl(String path) => '$baseUrl/media/$path';
}