import 'package:flutter/material.dart';

/// Token warna, jarak, bucu dan jenis teks untuk SELURUH app. Simpan semua
/// nombor 'ajaib' (padding, radius, warna) di sini supaya setiap skrin guna
/// rentak visual yang sama — bukan angka lain-lain kat setiap fail.
class AppTheme {
  // ---- Warna ----
  static const Color primaryDark = Color(0xFF0F382C); // Hijau Gelap Header/Banner
  static const Color primaryGreen = Color(0xFF7CA038); // Hijau Utama Button & Active
  static const Color lightGreen = Color(0xFFE8F0DC);   // Hijau Soft Chip / Background
  static const Color bgGrey = Color(0xFFF7F9F6);       // Background Skrin
  static const Color textDark = Color(0xFF1E2421);
  static const Color textMuted = Color(0xFF757E7A);
  static const Color amber = Color(0xFFB8860B);        // aksen amaran (hampir penuh, dll)

  // ---- Jarak (spacing) — guna gandaan 4 supaya rhythm konsisten ----
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // ---- Bucu bulat (radius) ----
  static const double radiusCard = 18;
  static const double radiusBadge = 14;
  static const double radiusChip = 999;

  /// Shadow lembut standard — guna pada semua card putih supaya "kedalaman"
  /// konsisten (jangan campur elevation Material dengan custom shadow lain).
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static BoxDecoration cardDecoration({double radius = radiusCard}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: cardShadow,
    );
  }

  // PILIHAN: untuk look yang lagi 'branded' (bukan font default OS), boleh
  // guna pakej google_fonts:
  //   1) tambah `google_fonts: ^6.2.1` dalam pubspec.yaml, run flutter pub get
  //   2) import 'package:google_fonts/google_fonts.dart';
  //   3) tukar `textTheme: base.textTheme.copyWith(...)` di bawah dengan
  //      `textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(...)`
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgGrey,
      primaryColor: primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryGreen,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: textDark,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: textDark,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: textDark,
          height: 1.4,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          color: textMuted,
          height: 1.3,
        ),
        labelSmall: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: textMuted,
        ),
      ),
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