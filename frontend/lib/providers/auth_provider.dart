import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(minutes: 2),    // ✅ 2 MINUTES!
    receiveTimeout: const Duration(minutes: 3),    // ✅ 3 MINUTES!
    sendTimeout: const Duration(minutes: 2),       // ✅ 2 MINUTES!
  ));

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      await _loadUserData();
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await StorageService.getUserData();
      if (userData != null) {
        _user = User.fromJson(userData);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// REGISTER
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    int? classLevel,
    String? schoolName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔵 Registering user: $email');
      debugPrint('🔵 URL: ${ApiConfig.baseUrl}${ApiConfig.register}');
      
      final Map<String, dynamic> data = {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'role': role,
      };
      
      if (role == 'student' && classLevel != null) {
        data['class_level'] = classLevel;
      }
      if (schoolName != null && schoolName.isNotEmpty) {
        data['school_name'] = schoolName;
      }
      
      debugPrint('🔵 Sending data: $data');
      
      final response = await _dio.post(
        ApiConfig.register,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
          sendTimeout: const Duration(minutes: 2),      // ✅ OVERRIDE
          receiveTimeout: const Duration(minutes: 3),   // ✅ OVERRIDE
        ),
      );

      debugPrint('🟢 Registration status: ${response.statusCode}');
      debugPrint('🟢 Registration response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        await StorageService.saveAccessToken(responseData['access'] ?? '');
        await StorageService.saveRefreshToken(responseData['refresh'] ?? '');
        
        _user = User.fromJson(responseData['user']);
        await StorageService.saveUserData(_user!.toJson());
        
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('🔴 Registration failed: ${response.statusCode}');
        debugPrint('🔴 Error response: ${response.data}');
        
        if (response.data is Map) {
          final errorData = response.data as Map<String, dynamic>;
          
          if (errorData.containsKey('username')) {
            _error = 'Username: ${errorData['username'][0]}';
          } else if (errorData.containsKey('email')) {
            _error = 'Email: ${errorData['email'][0]}';
          } else if (errorData.containsKey('password')) {
            _error = 'Password: ${errorData['password'][0]}';
          } else if (errorData.containsKey('error')) {
            _error = errorData['error'];
          } else if (errorData.containsKey('detail')) {
            _error = errorData['detail'];
          } else {
            _error = 'Registration failed: ${errorData.toString()}';
          }
        } else {
          _error = 'Registration failed';
        }
        
        _isLoading = false;
        notifyListeners();
        return false;
      }

    } on DioException catch (e) {
      debugPrint('🔴 Registration DioException: ${e.type}');
      debugPrint('🔴 Error message: ${e.message}');
      debugPrint('🔴 Response data: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        _error = 'Cannot connect to server.\n'
                 'Backend: http://172.25.213.34:8000\n'
                 'Is backend running?\n'
                 'Same WiFi?\n'
                 'Firewall disabled?';
      } else if (e.response?.data != null) {
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map<String, dynamic>;
          _error = errorData['error'] ?? 
                   errorData['detail'] ?? 
                   'Registration failed';
        } else {
          _error = 'Registration failed: ${e.response!.data}';
        }
      } else {
        _error = 'Network error: ${e.message}';
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
      
    } catch (e) {
      debugPrint('🔴 Unexpected error: $e');
      _error = 'Unexpected error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// LOGIN
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔵 Logging in: $username');
      debugPrint('🔵 Backend URL: ${ApiConfig.baseUrl}${ApiConfig.login}');
      
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
          sendTimeout: const Duration(minutes: 2),      // ✅ OVERRIDE
          receiveTimeout: const Duration(minutes: 3),   // ✅ OVERRIDE
        ),
      );

      debugPrint('🟢 Login status: ${response.statusCode}');
      debugPrint('🟢 Login response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        await StorageService.saveAccessToken(data['access'] ?? '');
        await StorageService.saveRefreshToken(data['refresh'] ?? '');
        
        _user = User.fromJson(data['user']);
        await StorageService.saveUserData(_user!.toJson());
        
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('🔴 Login failed: ${response.statusCode}');
        debugPrint('🔴 Error: ${response.data}');
        
        if (response.data is Map) {
          final errorData = response.data as Map<String, dynamic>;
          _error = errorData['error'] ?? 
                   errorData['detail'] ?? 
                   'Invalid credentials';
        } else {
          _error = 'Login failed';
        }
        
        _isLoading = false;
        notifyListeners();
        return false;
      }

    } on DioException catch (e) {
      debugPrint('🔴 Login error: ${e.type}');
      debugPrint('🔴 Error message: ${e.message}');
      debugPrint('🔴 Response: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        _error = 'Cannot connect to server.\n'
                 'Backend: http://172.25.213.34:8000\n'
                 'Is backend running?';
      } else if (e.response?.data != null) {
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map<String, dynamic>;
          _error = errorData['error'] ?? 
                   errorData['detail'] ?? 
                   'Invalid credentials';
        } else {
          _error = 'Login failed: ${e.response!.data}';
        }
      } else {
        _error = 'Network error. Check connection.';
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
      
    } catch (e) {
      debugPrint('🔴 Unexpected login error: $e');
      _error = 'Unexpected error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await StorageService.clearAuthData();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// AUTO LOGIN
  Future<void> tryAutoLogin() async {
    final token = await StorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      _isAuthenticated = false;
      return;
    }

    await _loadUserData();
    _isAuthenticated = _user != null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}