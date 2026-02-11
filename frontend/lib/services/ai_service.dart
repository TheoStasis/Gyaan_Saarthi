import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/conversation_model.dart';
import 'storage_service.dart';

class AIService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
    ),
  );

  Future<String?> _getToken() async {
    return await StorageService.getAccessToken();
  }

  Future<List<Conversation>> getConversations() async {
    try {
      final token = await _getToken();

      final response = await _dio.get(
        ApiConfig.conversations,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return (response.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } catch (e) {
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
      final token = await _getToken();

      final response = await _dio.post(
        ApiConfig.chatText,
        data: {
          if (conversationId != null) 'conversation_id': conversationId,
          'message': message,
          if (subject != null) 'subject': subject,
          if (language != null) 'language': language,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'success': true,
        'conversationId': response.data['conversation_id'],
        'message': Message.fromJson(response.data['message']),
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error'] ?? 'Failed to send message',
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
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error'] ?? 'Failed to send audio',
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
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error'] ?? 'Failed to send image',
      };
    }
  }
}