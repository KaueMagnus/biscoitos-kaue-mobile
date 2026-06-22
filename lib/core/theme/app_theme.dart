import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD9231F);
  static const Color gold = Color(0xFFF6C431);
  static const Color caramel = Color(0xFFB65412);
  static const Color lightBackground = Color(0xFFFFF7ED);
  static const Color creamCard = Color(0xFFFFF1E6);
  static const Color darkText = Color(0xFF1F1A17);
  static const Color supportGray = Color(0xFF6B7280);
  static const Color brandBlack = Color(0xFF231F20);
  static const Color successGreen = Color(0xFF15803D);
  static const Color cancelRed = Color(0xFFB91C1C);

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryRed,
      primary: primaryRed,
      secondary: gold,
      surface: creamCard,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFFFE0C2)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE8C7AA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed, width: 1.5),
        ),
        labelStyle: const TextStyle(color: supportGray),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: brandBlack,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: darkText),
      ),
    );
  }
}
