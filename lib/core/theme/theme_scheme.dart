import 'package:flutter/material.dart';

enum ThemeScheme {
  default_light,
  default_dark,
  purple_light,
  purple_dark,
  green_light,
  green_dark,
  orange_light,
  orange_dark,
  blue_light,
  blue_dark,
  red_light,
  red_dark,
  yellow_light,
  yellow_dark,
  pink_light,
  pink_dark,
  teal_light,
  teal_dark,
  cyan_light,
  cyan_dark,
  indigo_light,
  indigo_dark,
  brown_light,
  brown_dark,
  grey_light,
  grey_dark,
  lime_light,
  lime_dark,
  amber_light,
  amber_dark,
}

extension ThemeSchemeExtension on ThemeScheme {
  String get displayName {
    return toString().split('.').last.replaceAll('_', ' ').toTitleCase();
  }

  bool get isDark => toString().contains('dark');

  Color get seedColor {
    switch (this) {
      case ThemeScheme.default_light:
      case ThemeScheme.default_dark:
        return const Color(0xFF6750A4); // Deep Purple

      case ThemeScheme.purple_light:
      case ThemeScheme.purple_dark:
        return const Color(0xFF9C27B0); // Purple

      case ThemeScheme.green_light:
      case ThemeScheme.green_dark:
        return const Color(0xFF4CAF50); // Green

      case ThemeScheme.orange_light:
      case ThemeScheme.orange_dark:
        return const Color(0xFFFF9800); // Orange

      case ThemeScheme.blue_light:
      case ThemeScheme.blue_dark:
        return const Color(0xFF2196F3); // Blue

      case ThemeScheme.red_light:
      case ThemeScheme.red_dark:
        return const Color(0xFFF44336); // Red

      case ThemeScheme.yellow_light:
      case ThemeScheme.yellow_dark:
        return const Color(0xFFFFEB3B); // Yellow

      case ThemeScheme.pink_light:
      case ThemeScheme.pink_dark:
        return const Color(0xFFE91E63); // Pink

      case ThemeScheme.teal_light:
      case ThemeScheme.teal_dark:
        return const Color(0xFF009688); // Teal

      case ThemeScheme.cyan_light:
      case ThemeScheme.cyan_dark:
        return const Color(0xFF00BCD4); // Cyan

      case ThemeScheme.indigo_light:
      case ThemeScheme.indigo_dark:
        return const Color(0xFF3F51B5); // Indigo

      case ThemeScheme.brown_light:
      case ThemeScheme.brown_dark:
        return const Color(0xFF795548); // Brown

      case ThemeScheme.grey_light:
      case ThemeScheme.grey_dark:
        return const Color(0xFF9E9E9E); // Grey

      case ThemeScheme.lime_light:
      case ThemeScheme.lime_dark:
        return const Color(0xFFCDDC39); // Lime

      case ThemeScheme.amber_light:
      case ThemeScheme.amber_dark:
        return const Color(0xFFFFC107); // Amber
    }
  }
}

extension StringExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
