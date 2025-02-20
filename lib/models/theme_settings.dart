import 'package:flutter/material.dart';

class ThemeSettings {
  final ThemeMode themeMode;
  final Color primaryColor;
  final bool useMaterial3;
  final double borderRadius;

  ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.primaryColor = const Color(0xFF1E88E5),
    this.useMaterial3 = true,
    this.borderRadius = 12.0,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    bool? useMaterial3,
    double? borderRadius,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}