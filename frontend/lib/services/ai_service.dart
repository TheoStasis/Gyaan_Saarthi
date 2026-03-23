import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class AIService {
  late final Dio _dio;

  AIService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
      ),
    );
  }

  // ✅ NEW: Refresh the access token using the refresh token
  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('🔴 [AI_SERVICE] No refresh token found!');
        return null;
      }

      debugPrint('🔵 [AI_SERVICE] Attempting token refresh...');

      final refreshDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final response = await refreshDio.post(
        ApiConfig.refresh,
        data: {'refresh': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('🔵 [AI_SERVICE] Refresh status: ${response.statusCode}');
      debugPrint('🔵 [AI_SERVICE] Refresh response: ${response.data}');

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        if (newAccessToken != null) {
          await StorageService.saveAccessToken(newAccessToken);
          debugPrint('🟢 [AI_SERVICE] Token refreshed successfully!');
          return newAccessToken;
        }
      }

      debugPrint('🔴 [AI_SERVICE] Token refresh failed: ${response.data}');
      return null;
    } catch (e) {
      debugPrint('🔴 [AI_SERVICE] Token refresh exception: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> sendTextMessage({
    required String question,
    String? conversationId,
    String? language,
  }) async {
    try {
      // Map Flutter language codes to backend expected values
      final languageMap = {
        'en': 'english',
        'hi': 'hindi',
        'bn': 'bengali',
        'ta': 'tamil',
        'te': 'telugu',
        'mr': 'marathi',
      };

      final backendLanguage = languageMap[language] ?? 'english';

      final requestData = {
        'question': question.trim(),
        'language': backendLanguage,
      };

      if (conversationId != null && conversationId.isNotEmpty) {
        requestData['conversation_id'] = conversationId;
      }

      debugPrint('🔵 [AI_SERVICE] ==========================================');
      debugPrint('🔵 [AI_SERVICE] Sending request to: ${ApiConfig.baseUrl}${ApiConfig.chatText}');
      debugPrint('🔵 [AI_SERVICE] Question: $question');
      debugPrint('🔵 [AI_SERVICE] Language: $language → $backendLanguage');
      debugPrint('🔵 [AI_SERVICE] ==========================================');

      // ✅ Get token (may be expired)
      String? token = await StorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('🔴 [AI_SERVICE] ERROR: No access token found!');
        return {
          'success': false,
          'error': 'Not authenticated. Please login again.',
        };
      }

      debugPrint('🔵 [AI_SERVICE] Token exists: ${token.length} chars');

      // ✅ Make first attempt
      var response = await _dio.post(
        ApiConfig.chatText,
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 5),
          validateStatus: (status) => status! < 600,
        ),
      );

      debugPrint('🟢 [AI_SERVICE] Response status: ${response.statusCode}');

      // ✅ If 401, try refreshing the token and retry ONCE
      if (response.statusCode == 401) {
        debugPrint('🔴 [AI_SERVICE] Got 401 - trying token refresh...');

        final newToken = await _refreshAccessToken();

        if (newToken == null) {
          return {
            'success': false,
            'error': 'Session expired. Please login again.',
          };
        }

        // ✅ Retry with new token
        debugPrint('🔵 [AI_SERVICE] Retrying with new token...');
        response = await _dio.post(
          ApiConfig.chatText,
          data: requestData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $newToken',
              'Content-Type': 'application/json',
            },
            sendTimeout: const Duration(minutes: 3),
            receiveTimeout: const Duration(minutes: 5),
            validateStatus: (status) => status! < 600,
          ),
        );

        debugPrint('🟢 [AI_SERVICE] Retry response status: ${response.statusCode}');
      }

      debugPrint('🟢 [AI_SERVICE] Final response data: ${response.data}');
      debugPrint('🔵 [AI_SERVICE] ==========================================');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        debugPrint('🔴 [AI_SERVICE] Backend error: ${response.data}');
        return {
          'success': false,
          'error': response.data['error'] ??
              response.data['detail'] ??
              response.data['message'] ??
              'Server error (${response.statusCode})',
          'data': response.data,
        };
      }
    } on DioException catch (e) {
      debugPrint('🔴 [AI_SERVICE] DioException: ${e.type}');
      debugPrint('🔴 [AI_SERVICE] Message: ${e.message}');

      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout. Check if backend is running.';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Send timeout - request took too long.';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Response timeout - AI is taking too long.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error: ${e.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request cancelled.';
          break;
        default:
          errorMessage = 'Network error: ${e.message}';
      }

      return {
        'success': false,
        'error': errorMessage,
        'data': e.response?.data,
      };
    } catch (e) {
      debugPrint('🔴 [AI_SERVICE] Unexpected error: $e');
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getConversations() async {
    try {
      String? token = await StorageService.getAccessToken();

      var response = await _dio.get(
        ApiConfig.conversations,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 600,
        ),
      );

      // ✅ Auto refresh on 401 for conversations too
      if (response.statusCode == 401) {
        final newToken = await _refreshAccessToken();
        if (newToken != null) {
          response = await _dio.get(
            ApiConfig.conversations,
            options: Options(
              headers: {'Authorization': 'Bearer $newToken'},
              validateStatus: (status) => status! < 600,
            ),
          );
        }
      }

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      }

      return {
        'success': false,
        'error': 'Failed to load conversations',
      };
    } catch (e) {
      debugPrint('🔴 [AI_SERVICE] Error getting conversations: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}