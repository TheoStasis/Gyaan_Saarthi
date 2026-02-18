import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Storage Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _languageKey = 'language';
  static const String _userDataKey = 'user_data';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // ========================================
  // AUTH TOKENS
  // ========================================

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_accessTokenKey, token);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_refreshTokenKey, token);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_accessTokenKey);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_refreshTokenKey);
  }

  /// Clear both tokens
  static Future<void> clearTokens() async {
    final prefs = await _getPrefs();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ========================================
  // USER DATA
  // ========================================

  /// Save user ID
  static Future<void> saveUserId(String id) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userIdKey, id);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userIdKey);
  }

  /// Save complete user data as JSON string
  static Future<void> saveUserData(String jsonString) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userDataKey, jsonString);
  }

  /// Get complete user data
  static Future<String?> getUserData() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userDataKey);
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    final prefs = await _getPrefs();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);
  }

  // ========================================
  // LANGUAGE SETTINGS
  // ========================================

  /// Save selected language
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get selected language
  static Future<String?> getLanguage() async {
    final prefs = await _getPrefs();
    return prefs.getString(_languageKey);
  }

  // ========================================
  // GENERIC PREFERENCES
  // ========================================

  /// Save any preference
  static Future<void> savePreference(String key, dynamic value) async {
    final prefs = await _getPrefs();
    
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported value type: ${value.runtimeType}');
    }
  }

  /// Get any preference
  static Future<dynamic> getPreference(String key) async {
    final prefs = await _getPrefs();
    return prefs.get(key);
  }

  /// Get string preference
  static Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  /// Get int preference
  static Future<int?> getInt(String key) async {
    final prefs = await _getPrefs();
    return prefs.getInt(key);
  }

  /// Get bool preference
  static Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  /// Get double preference
  static Future<double?> getDouble(String key) async {
    final prefs = await _getPrefs();
    return prefs.getDouble(key);
  }

  /// Get string list preference
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key);
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  /// Remove specific key
  static Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  // ========================================
  // BULK OPERATIONS
  // ========================================

  /// Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  /// Clear only auth-related data (logout)
  static Future<void> clearAuthData() async {
    await clearTokens();
    await clearUserData();
  }

  /// Get all keys
  static Future<Set<String>> getAllKeys() async {
    final prefs = await _getPrefs();
    return prefs.getKeys();
  }

  // ========================================
  // APP SETTINGS
  // ========================================

  /// Save theme mode (light/dark)
  static Future<void> saveThemeMode(String mode) async {
    await savePreference('theme_mode', mode);
  }

  /// Get theme mode
  static Future<String?> getThemeMode() async {
    return getString('theme_mode');
  }

  /// Save notifications enabled
  static Future<void> saveNotificationsEnabled(bool enabled) async {
    await savePreference('notifications_enabled', enabled);
  }

  /// Get notifications enabled
  static Future<bool> getNotificationsEnabled() async {
    final value = await getBool('notifications_enabled');
    return value ?? true; // Default: enabled
  }

  /// Save first time flag
  static Future<void> saveFirstTime(bool isFirstTime) async {
    await savePreference('is_first_time', isFirstTime);
  }

  /// Get first time flag
  static Future<bool> isFirstTime() async {
    final value = await getBool('is_first_time');
    return value ?? true; // Default: first time
  }

  // ========================================
  // LEARNING PROGRESS (Optional)
  // ========================================

  /// Save last quiz score
  static Future<void> saveLastQuizScore(int score) async {
    await savePreference('last_quiz_score', score);
  }

  /// Get last quiz score
  static Future<int?> getLastQuizScore() async {
    return getInt('last_quiz_score');
  }

  /// Save completed lessons
  static Future<void> saveCompletedLessons(List<String> lessonIds) async {
    await savePreference('completed_lessons', lessonIds);
  }

  /// Get completed lessons
  static Future<List<String>> getCompletedLessons() async {
    final lessons = await getStringList('completed_lessons');
    return lessons ?? [];
  }

  /// Add completed lesson
  static Future<void> addCompletedLesson(String lessonId) async {
    final lessons = await getCompletedLessons();
    if (!lessons.contains(lessonId)) {
      lessons.add(lessonId);
      await saveCompletedLessons(lessons);
    }
  }

  // ========================================
  // DEBUG HELPERS
  // ========================================

  /// Print all stored data (for debugging)
  static Future<void> debugPrintAll() async {
    final prefs = await _getPrefs();
    final keys = prefs.getKeys();
    
    print('=== StorageService Debug ===');
    for (final key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    print('===========================');
  }
}