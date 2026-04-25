import 'package:flutter/material.dart';

class ShanataniColors {
  static const saffron = Color(0xFFF08C22);
  static const deepSaffron = Color(0xFFD96B00);
  static const gold = Color(0xFFFFC94A);
  static const cream = Color(0xFFFFF5E6);
  static const maroon = Color(0xFF7A1F1F);
  static const pine = Color(0xFF29544B);
  static const whatsapp = Color(0xFF25D366);
  static const ink = Color(0xFF3B2314);
}

ThemeData buildShanataniTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ShanataniColors.saffron,
      brightness: Brightness.light,
      primary: ShanataniColors.saffron,
      secondary: ShanataniColors.gold,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: ShanataniColors.cream,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ShanataniColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: ShanataniColors.ink,
      displayColor: ShanataniColors.ink,
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.88),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ShanataniColors.saffron,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
  );
}
