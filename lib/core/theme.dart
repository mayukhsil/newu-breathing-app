import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF630068), // Purple
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
      ),
      fontFamily: 'Quicksand',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
        titleLarge: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
        bodyLarge: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontVariations: <FontVariation>[FontVariation('wght', 500)],
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
          fontVariations: <FontVariation>[FontVariation('wght', 400)],
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF630068),
        secondary: Color(0xFFAB47BC),
        surface: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF630068),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF823386), // Light purple
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
      ),
      fontFamily: 'Quicksand',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontVariations: <FontVariation>[FontVariation('wght', 700)],
        ),
        bodyLarge: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
          fontVariations: <FontVariation>[FontVariation('wght', 500)],
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w400,
          fontVariations: <FontVariation>[FontVariation('wght', 400)],
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF823386),
        secondary: Color(0xFF6A1B9A),
        surface: Color(0xFF3B2D60),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF823386),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
