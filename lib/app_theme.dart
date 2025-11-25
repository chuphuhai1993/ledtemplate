import 'package:flutter/material.dart';

class AppTheme {
  // Base Colors
  static const Color _primary = Color(0xFF00FFE5);
  static const Color _onPrimary = Color(0xFF1C1D1F);
  static const Color _primaryContainer = Color(0xFF041E1C);
  static const Color _onPrimaryContainer = Color(0xFFF9F9F9);

  static const Color _secondary = Color(0xFFEEFF00);
  static const Color _onSecondary = Color(0xFF1C1D1F);
  static const Color _secondaryContainer = Color(0xFF1B1B03);
  static const Color _onSecondaryContainer = Color(0xFFF9F9F9);

  static const Color _tertiary = Color(0xFFFFFFFF);
  static const Color _onTertiary = Color(0xFF1C1D1F);
  static const Color _tertiaryContainer = Color(0xFF292929);
  static const Color _onTertiaryContainer = Color(0xFFF9F9F9);

  static const Color _error = Color(0xFFF2B8B5);
  static const Color _onError = Color(0xFF601410);
  static const Color _errorContainer = Color(0xFF8C1D18);
  static const Color _onErrorContainer = Color(0xFFF9DEDC);

  static const Color _background = Color(0xFF000000);
  static const Color _onBackground = Color(0xFFF9F9F9);

  static const Color _surface = Color(0xFF1F1F1F);
  static const Color _onSurface = Color(0xFFF9F9F9);
  static const Color _surfaceVariant = Color(0xFF49454F);
  static const Color _onSurfaceVariant = Color(0xFFCAC4D0);

  static const Color _outline = Color(0xFF938F99);
  static const Color _outlineVariant = Color(0xFF49454F);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _primary,
        onPrimary: _onPrimary,
        primaryContainer: _primaryContainer,
        onPrimaryContainer: _onPrimaryContainer,
        secondary: _secondary,
        onSecondary: _onSecondary,
        secondaryContainer: _secondaryContainer,
        onSecondaryContainer: _onSecondaryContainer,
        tertiary: _tertiary,
        onTertiary: _onTertiary,
        tertiaryContainer: _tertiaryContainer,
        onTertiaryContainer: _onTertiaryContainer,
        error: _error,
        onError: _onError,
        errorContainer: _errorContainer,
        onErrorContainer: _onErrorContainer,
        background: _background,
        onBackground: _onBackground,
        surface: _surface,
        onSurface: _onSurface,
        surfaceVariant: _surfaceVariant,
        onSurfaceVariant: _onSurfaceVariant,
        outline: _outline,
        outlineVariant: _outlineVariant,
      ),
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: _onSurface),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surface,
        selectedItemColor: _primary,
        unselectedItemColor: _outline,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        color: _surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      useMaterial3: true,
    );
  }
}
