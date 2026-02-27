import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/api_config.dart';
import '../models/conversation_model.dart';
import 'storage_service.dart';
import 'offline_responses.dart';

class AIService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),      // ✅ 30 seconds to connect
      receiveTimeout: const Duration(seconds: 180),     // ✅ 3 minutes to receive (AI is slow!)
      sendTimeout: const Duration(seconds: 30),         // ✅ 30 seconds to send
    ),
  );

  AIService() {
    // Add interceptor for debugging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🔵 REQUEST: ${options.method} ${options.path}');
          debugPrint('🔵 HEADERS: ${options.headers}');
          debugPrint('🔵 DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('🟢 RESPONSE: ${response.statusCode}');
          debugPrint('🟢 DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('🔴 ERROR: ${error.response?.statusCode}');
          debugPrint('🔴 ERROR DATA: ${error.response?.data}');
          debugPrint('🔴 ERROR MESSAGE: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Check internet connectivity
  Future<bool> isOnline() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getToken() async {
    final token = await StorageService.getAccessToken();
    debugPrint('🔑 TOKEN: ${token ?? "NULL"}');
    return token;
  }

  Future<List<Conversation>> getConversations() async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConfig.conversations,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;
      if (data is Map && data.containsKey('results')) {
        return (data['results'] as List)
            .map((json) => Conversation.fromJson(json))
            .toList();
      } else if (data is List) {
        return data.map((json) => Conversation.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      throw Exception('Failed to load conversations: $e');
    }
  }

  Future<Map<String, dynamic>> sendTextMessage({
    String? conversationId,
    required String message,
    String? subject,
    String? language,
  }) async {
    try {
      // Check connectivity first
      final online = await isOnline();

      if (!online) {
        // OFFLINE MODE - Use cached responses
        debugPrint('⚠️ [AI_SERVICE] Offline mode - using cached responses');

        final offlineResponse = OfflineResponses.getResponse(
          message,
          language ?? 'hindi',
        );

        return {
          'success': true,
          'conversationId': 'offline_${DateTime.now().millisecondsSinceEpoch}',
          'message': Message(
            id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
            role: 'assistant',
            messageType: 'text',
            textContent: offlineResponse,
            createdAt: DateTime.now(),
          ),
          'isOffline': true, // Flag to show offline indicator
        };
      }

      // ONLINE MODE - Use backend API (Groq)
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'No authentication token found. Please login again.',
        };
      }

      debugPrint('🌐 [AI_SERVICE] Online mode - calling backend API');

      final response = await _dio.post(
        ApiConfig.chatText,
        data: {
          if (conversationId != null) 'conversation_id': conversationId,
          'message': message,
          if (subject != null) 'subject': subject,
          if (language != null) 'language': language,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('✅ [AI_SERVICE] Online response received');

      return {
        'success': true,
        'conversationId': response.data['conversation_id'],
        'message': Message.fromJson(response.data['message']),
        'isOffline': false,
      };

    } on DioException catch (e) {
      debugPrint('🔴 [AI_SERVICE] DioException: ${e.type}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Connection error - treat as offline
        final offlineResponse = OfflineResponses.getResponse(
          message,
          language ?? 'hindi',
        );

        return {
          'success': true,
          'conversationId': 'offline_${DateTime.now().millisecondsSinceEpoch}',
          'message': Message(
            id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
            role: 'assistant',
            messageType: 'text',
            textContent: offlineResponse,
            createdAt: DateTime.now(),
          ),
          'isOffline': true,
        };
      }

      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'error': 'Authentication failed. Please login again.',
        };
      }

      return {
        'success': false,
        'error': e.response?.data['error'] ?? e.message ?? 'Failed to send message',
      };
    } catch (e) {
      debugPrint('🔴 [AI_SERVICE] Unexpected error: $e');
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> sendAudioMessage({
    String? conversationId,
    required File audioFile,
    String? subject,
    String? language,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'No authentication token found. Please login again.',
        };
      }

      FormData formData = FormData.fromMap({
        if (conversationId != null) 'conversation_id': conversationId,
        'audio_file': await MultipartFile.fromFile(audioFile.path),
        if (subject != null) 'subject': subject,
        if (language != null) 'language': language,
        'return_audio': true,
      });

      final response = await _dio.post(
        ApiConfig.chatAudio,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'success': true,
        'conversationId': response.data['conversation_id'],
        'message': Message.fromJson(response.data['message']),
        'audioUrl': response.data['audio_url'],
        'isOffline': false,
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'error': 'Authentication failed. Please login again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data['error'] ?? e.message ?? 'Failed to send audio',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> sendImageMessage({
    String? conversationId,
    required File imageFile,
    String? message,
    String? subject,
    String? language,
  }) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'No authentication token found. Please login again.',
        };
      }

      FormData formData = FormData.fromMap({
        if (conversationId != null) 'conversation_id': conversationId,
        'image': await MultipartFile.fromFile(imageFile.path),
        if (message != null) 'message': message,
        if (subject != null) 'subject': subject,
        if (language != null) 'language': language,
      });

      final response = await _dio.post(
        ApiConfig.chatImage,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'success': true,
        'conversationId': response.data['conversation_id'],
        'message': Message.fromJson(response.data['message']),
        'isOffline': false,
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'error': 'Authentication failed. Please login again.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data['error'] ?? e.message ?? 'Failed to send image',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }
}