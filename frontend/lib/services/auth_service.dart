import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    int? classLevel,
    String? schoolName,
    String? subjects,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'role': role,
          if (classLevel != null) 'class_level': classLevel,
          if (schoolName != null) 'school_name': schoolName,
          if (subjects != null) 'subjects': subjects,
        },
      );

      await StorageService.saveAccessToken(response.data['access']);
      await StorageService.saveRefreshToken(response.data['refresh']);

      return {
        'success': true,
        'user': User.fromJson(response.data['user']),
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['detail'] ?? 'Registration failed',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      await StorageService.saveAccessToken(response.data['access']);
      await StorageService.saveRefreshToken(response.data['refresh']);

      final userResponse = await getCurrentUser();

      return {
        'success': true,
        'user': userResponse['user'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['detail'] ?? 'Login failed',
      };
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await StorageService.getAccessToken();

      final response = await _dio.get(
        ApiConfig.userMe,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'success': true,
        'user': User.fromJson(response.data),
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.message,
      };
    }
  }

  Future<void> logout() async {
    await StorageService.clearTokens();
  }
}