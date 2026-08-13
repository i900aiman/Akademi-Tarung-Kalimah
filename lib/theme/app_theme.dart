import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF0F382C); // Hijau Gelap Header/Banner
  static const Color primaryGreen = Color(0xFF7CA038); // Hijau Utama Button & Active
  static const Color lightGreen = Color(0xFFE8F0DC);   // Hijau Soft Chip / Background
  static const Color bgGrey = Color(0xFFF7F9F6);       // Background Skrin
  static const Color textDark = Color(0xFF1E2421);
  static const Color textMuted = Color(0xFF757E7A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgGrey,
      primaryColor: primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryGreen,
      ),
      fontFamily: 'Sans-Serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: bgGrey,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}