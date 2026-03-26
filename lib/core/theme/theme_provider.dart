import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'theme_scheme.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  final SharedPreferences _prefs;

  ThemeScheme _currentScheme;

  ThemeProvider(this._prefs)
      : _currentScheme = ThemeScheme.values.firstWhere(
          (scheme) => scheme.toString() == _prefs.getString(_themeKey),
          orElse: () => ThemeScheme.default_light,
        );

  ThemeScheme get currentScheme => _currentScheme;
  bool get isDark => _currentScheme.isDark;

  ThemeMode get themeMode =>
      _currentScheme.isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get theme => _createTheme(_currentScheme);

  Future<void> setTheme(ThemeScheme scheme) async {
    if (_currentScheme != scheme) {
      _currentScheme = scheme;
      await _prefs.setString(_themeKey, scheme.toString());
      notifyListeners();
    }
  }

  ThemeData _createTheme(ThemeScheme scheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: scheme.seedColor,
      brightness: scheme.isDark ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      // scaffoldBackgroundColor: colorScheme.surface,
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 2,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}
