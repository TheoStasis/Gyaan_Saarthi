import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth Tokens
  static Future<void> saveAccessToken(String token) async {
    await _prefs?.setString('access_token', token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString('refresh_token', token);
  }

  static Future<String?> getAccessToken() async {
    return _prefs?.getString('access_token');
  }

  static Future<String?> getRefreshToken() async {
    return _prefs?.getString('refresh_token');
  }

  static Future<void> clearTokens() async {
    await _prefs?.remove('access_token');
    await _prefs?.remove('refresh_token');
  }

  // User Data
  static Future<void> saveUserId(String id) async {
    await _prefs?.setString('user_id', id);
  }

  static Future<String?> getUserId() async {
    return _prefs?.getString('user_id');
  }

  // Preferences
  static Future<void> savePreference(String key, dynamic value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    }
  }

  static dynamic getPreference(String key) {
    return _prefs?.get(key);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}