import 'package:flutter/material.dart';
import 'dagrd_colors.dart';

class AppTheme {
  static const primaryColor = Color(0xFF002342);
  static const secondaryColor = Color(0xFFFAD502);
  static const backgroundColor = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
    // Colores principales usando DAGRD
    primaryColor: DAGRDColors.azulDAGRD,
    primaryColorDark: DAGRDColors.azulDAGRD,
    primaryColorLight: DAGRDColors.azulDAGRD,
    colorScheme: ColorScheme.light(
      primary: DAGRDColors.azulDAGRD,
      secondary: DAGRDColors.amarilloDAGRD,
      surface: DAGRDColors.blancoDAGRD,
      onPrimary: DAGRDColors.blancoDAGRD,
      onSecondary: DAGRDColors.azulDAGRD,
      onSurface: DAGRDColors.azulDAGRD,
    ),

    // AppBar tema
    appBarTheme: AppBarTheme(
      backgroundColor: DAGRDColors.azulDAGRD,
      foregroundColor: DAGRDColors.blancoDAGRD,
      elevation: 0,
    ),

    // Scaffold tema
    scaffoldBackgroundColor: DAGRDColors.blancoDAGRD,

    // Card tema
    cardTheme: CardThemeData(
      color: DAGRDColors.blancoDAGRD,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // FloatingActionButton tema
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: DAGRDColors.amarilloDAGRD,
      foregroundColor: DAGRDColors.azulDAGRD,
    ),

    // Input decoración
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DAGRDColors.blancoDAGRD,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: DAGRDColors.azulDAGRD),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: DAGRDColors.azulDAGRD),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: DAGRDColors.amarilloDAGRD, width: 2),
      ),
      labelStyle: TextStyle(color: DAGRDColors.azulDAGRD),
    ),

    // Botón tema
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DAGRDColors.amarilloDAGRD,
        foregroundColor: DAGRDColors.azulDAGRD,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Texto tema
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: DAGRDColors.azulDAGRD,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        height: 1.167,
      ),
      titleMedium: TextStyle(
        color: DAGRDColors.azulDAGRD,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        color: DAGRDColors.azulDAGRD,
        fontSize: 16,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: DAGRDColors.azulDAGRD,
        fontSize: 14,
        fontFamily: 'Roboto',
      ),
    ),
    
    // Fuente predeterminada
    fontFamily: 'Roboto',
  );
} 