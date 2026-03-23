import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme().then((_) {}); // Safely executes the async function in the background
  }

  Future<void> _loadTheme() async {
    final isDark = await StorageService.getPreference('dark_mode') as bool?;
    _themeMode = (isDark ?? false) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await StorageService.savePreference(
      'dark_mode', 
      _themeMode == ThemeMode.dark
    );
    
    notifyListeners();
  }
}