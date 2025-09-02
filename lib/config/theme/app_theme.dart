import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF002342);
  static const secondaryColor = Color(0xFFFAD502);
  static const backgroundColor = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
    // Colores principales
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    primaryColorLight: const Color(0xFF003366),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),

    // AppBar tema
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: backgroundColor,
      elevation: 0,
    ),

    // Scaffold tema
    scaffoldBackgroundColor: backgroundColor,

    // Card tema
    cardTheme: CardThemeData(
      color: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // FloatingActionButton tema
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: primaryColor,
    ),

    // Input decoración
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: primaryColor),
    ),

    // Botón tema
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Texto tema
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: primaryColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: primaryColor,
        fontSize: 14,
      ),
    ),
  );
} 