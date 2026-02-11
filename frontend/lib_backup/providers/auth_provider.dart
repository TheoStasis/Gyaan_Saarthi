import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.login(
      username: username,
      password: password,
    );

    _isLoading = false;

    if (result['success']) {
      _user = result['user'];
      await StorageService.saveUserId(_user!.id);
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      notifyListeners();
      return false;
    }
  }

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

    final result = await _authService.register(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      classLevel: classLevel,
      schoolName: schoolName,
    );

    _isLoading = false;

    if (result['success']) {
      _user = result['user'];
      await StorageService.saveUserId(_user!.id);
      notifyListeners();
      return true;
    } else {
      _error = result['error'];
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final token = await StorageService.getAccessToken();
    if (token == null) return;

    final result = await _authService.getCurrentUser();
    if (result['success']) {
      _user = result['user'];
      notifyListeners();
    }
  }
}