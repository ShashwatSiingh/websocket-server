import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_settings.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_settings';
  late SharedPreferences _prefs;
  ThemeSettings _themeSettings = ThemeSettings();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeSettings get themeSettings => _themeSettings;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.toString() == (_prefs.getString('${_themeKey}_mode') ?? ThemeMode.system.toString()),
      orElse: () => ThemeMode.system,
    );
    final primaryColor = Color(_prefs.getInt('${_themeKey}_color') ?? 0xFF1E88E5);
    final useMaterial3 = _prefs.getBool('${_themeKey}_material3') ?? true;

    _themeSettings = ThemeSettings(
      themeMode: themeMode,
      primaryColor: primaryColor,
      useMaterial3: useMaterial3,
    );
    _themeMode = themeMode;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeSettings = _themeSettings.copyWith(themeMode: mode);
    await _prefs.setString('${_themeKey}_mode', mode.toString());
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> updatePrimaryColor(Color color) async {
    _themeSettings = _themeSettings.copyWith(primaryColor: color);
    await _prefs.setInt('${_themeKey}_color', color.value);
    notifyListeners();
  }

  Future<void> updateUseMaterial3(bool value) async {
    _themeSettings = _themeSettings.copyWith(useMaterial3: value);
    await _prefs.setBool('${_themeKey}_material3', value);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await updateThemeMode(mode);  // This will save to SharedPreferences
    notifyListeners();
  }
}