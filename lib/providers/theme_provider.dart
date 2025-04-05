import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadTheme();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _themeMode = ThemeMode.dark;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void toggleTheme() {
    if (!_isInitialized) return;
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }
}