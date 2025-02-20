import 'package:flutter/material.dart';

class CustomTheme {
  static const double borderRadius = 12.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  // Add any other theme constants you need
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  static const double spacing = 24.0;

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration gradientCard(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
    );
  }

  // Add color name helper
  static String getColorName(Color color) {
    final Map<int, String> colorNames = {
      0xFF1E88E5: 'Blue',
      0xFF43A047: 'Green',
      0xFFE53935: 'Red',
      0xFF8E24AA: 'Purple',
      0xFFF4511E: 'Orange',
    };

    return colorNames[color.value] ?? 'Custom';
  }

  // Add theme color schemes
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  );

  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  );
}