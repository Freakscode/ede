import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dagrd_colors.dart';

/// Tema principal de la aplicación DAGRD
/// Configuración completa del tema siguiendo Material Design 3
class AppTheme {
  AppTheme._(); // Constructor privado

  // ============================================================================
  // CONFIGURACIÓN DEL TEMA PRINCIPAL
  // ============================================================================

  /// Tema principal de la aplicación
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    
    // Configuración de colores
    colorScheme: _colorScheme,
    
    // Configuración de fuentes
    fontFamily: 'Work Sans',
    
    // Configuración de AppBar
    appBarTheme: _appBarTheme,
    
    // Configuración de Scaffold
    scaffoldBackgroundColor: DAGRDColors.surface,
    
    // Configuración de Cards
    cardTheme: _cardTheme,
    
    // Configuración de botones
    elevatedButtonTheme: _elevatedButtonTheme,
    textButtonTheme: _textButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    
    // Configuración de inputs
    inputDecorationTheme: _inputDecorationTheme,
    
    // Configuración de texto
    textTheme: _textTheme,
    
    // Configuración de iconos
    iconTheme: _iconTheme,
    
    // Configuración de dividers
    dividerTheme: _dividerTheme,
    
    // Configuración de bottom navigation
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    
    // Configuración de snackbar
    snackBarTheme: _snackBarTheme,
    
    // Configuración de dialog
    dialogTheme: _dialogTheme,
    
    // Configuración de tooltip
    tooltipTheme: _tooltipTheme,
    
    // Configuración de switch
    switchTheme: _switchTheme,
    
    // Configuración de checkbox
    checkboxTheme: _checkboxTheme,
    
    // Configuración de radio
    radioTheme: _radioTheme,
  );

  // ============================================================================
  // CONFIGURACIÓN DE COLORES
  // ============================================================================

  static ColorScheme get _colorScheme => const ColorScheme.light(
    // Colores primarios
    primary: DAGRDColors.azulDAGRD,
    onPrimary: DAGRDColors.onPrimary,
    primaryContainer: DAGRDColors.azulSecundario,
    onPrimaryContainer: DAGRDColors.onPrimary,
    
    // Colores secundarios
    secondary: DAGRDColors.amarilloDAGRD,
    onSecondary: DAGRDColors.onSecondary,
    secondaryContainer: DAGRDColors.amarDAGRD,
    onSecondaryContainer: DAGRDColors.onSecondary,
    
    // Colores de superficie
    surface: DAGRDColors.surface,
    onSurface: DAGRDColors.onSurface,
    surfaceVariant: DAGRDColors.surfaceVariant,
    onSurfaceVariant: DAGRDColors.onSurfaceVariant,
    
    // Colores de fondo
    background: DAGRDColors.surface,
    onBackground: DAGRDColors.onSurface,
    
    // Colores de error
    error: DAGRDColors.error,
    onError: DAGRDColors.onPrimary,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    // Colores de outline
    outline: DAGRDColors.outline,
    outlineVariant: DAGRDColors.outlineVariant,
    
    // Colores de sombra
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    
    // Colores de superficie inversa
    inverseSurface: DAGRDColors.grisOscuro,
    onInverseSurface: DAGRDColors.onPrimary,
    inversePrimary: DAGRDColors.amarilloDAGRD,
  );

  // ============================================================================
  // CONFIGURACIÓN DE APPBAR
  // ============================================================================

  static AppBarTheme get _appBarTheme => const AppBarTheme(
    backgroundColor: DAGRDColors.azulDAGRD,
    foregroundColor: DAGRDColors.onPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: DAGRDColors.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
    ),
    iconTheme: IconThemeData(
      color: DAGRDColors.onPrimary,
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ============================================================================
  // CONFIGURACIÓN DE CARDS
  // ============================================================================

  static CardThemeData get _cardTheme => CardThemeData(
    color: DAGRDColors.surface,
    elevation: 2,
    shadowColor: DAGRDColors.grisOscuro,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(8),
  );

  // ============================================================================
  // CONFIGURACIÓN DE BOTONES
  // ============================================================================

  static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DAGRDColors.azulDAGRD,
      foregroundColor: DAGRDColors.onPrimary,
      elevation: 2,
      shadowColor: DAGRDColors.grisOscuro,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Work Sans',
      ),
    ),
  );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: DAGRDColors.azulDAGRD,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Work Sans',
      ),
    ),
  );

  static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: DAGRDColors.azulDAGRD,
      side: const BorderSide(color: DAGRDColors.azulDAGRD),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Work Sans',
      ),
    ),
  );

  static FloatingActionButtonThemeData get _floatingActionButtonTheme => const FloatingActionButtonThemeData(
    backgroundColor: DAGRDColors.amarilloDAGRD,
    foregroundColor: DAGRDColors.onSecondary,
    elevation: 4,
  );

  // ============================================================================
  // CONFIGURACIÓN DE INPUTS
  // ============================================================================

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: DAGRDColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: DAGRDColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: DAGRDColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: DAGRDColors.azulDAGRD, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: DAGRDColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: DAGRDColors.error, width: 2),
    ),
    labelStyle: const TextStyle(
      color: DAGRDColors.onSurfaceVariant,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
    hintStyle: const TextStyle(
      color: DAGRDColors.onSurfaceVariant,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // ============================================================================
  // CONFIGURACIÓN DE TEXTO
  // ============================================================================

  static TextTheme get _textTheme => const TextTheme(
    // Títulos grandes
    headlineLarge: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: 'Work Sans',
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    
    // Títulos
    titleLarge: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.27,
    ),
    titleMedium: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.5,
    ),
    titleSmall: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    
    // Texto del cuerpo
    bodyLarge: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    bodySmall: TextStyle(
      color: DAGRDColors.onSurfaceVariant,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    
    // Etiquetas
    labelLarge: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    labelMedium: TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    labelSmall: TextStyle(
      color: DAGRDColors.onSurfaceVariant,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      height: 1.45,
    ),
  );

  // ============================================================================
  // CONFIGURACIÓN DE ICONOS
  // ============================================================================

  static IconThemeData get _iconTheme => const IconThemeData(
    color: DAGRDColors.onSurface,
    size: 24,
  );

  // ============================================================================
  // CONFIGURACIÓN DE DIVIDERS
  // ============================================================================

  static DividerThemeData get _dividerTheme => const DividerThemeData(
    color: DAGRDColors.outline,
    thickness: 1,
    space: 1,
  );

  // ============================================================================
  // CONFIGURACIÓN DE BOTTOM NAVIGATION
  // ============================================================================

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme => const BottomNavigationBarThemeData(
    backgroundColor: DAGRDColors.surface,
    selectedItemColor: DAGRDColors.azulDAGRD,
    unselectedItemColor: DAGRDColors.onSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // ============================================================================
  // CONFIGURACIÓN DE SNACKBAR
  // ============================================================================

  static SnackBarThemeData get _snackBarTheme => const SnackBarThemeData(
    backgroundColor: DAGRDColors.grisOscuro,
    contentTextStyle: TextStyle(
      color: DAGRDColors.onPrimary,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    behavior: SnackBarBehavior.floating,
  );

  // ============================================================================
  // CONFIGURACIÓN DE DIALOG
  // ============================================================================

  static DialogThemeData get _dialogTheme => DialogThemeData(
    backgroundColor: DAGRDColors.surface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    titleTextStyle: const TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
    ),
    contentTextStyle: const TextStyle(
      color: DAGRDColors.onSurface,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
  );

  // ============================================================================
  // CONFIGURACIÓN DE TOOLTIP
  // ============================================================================

  static TooltipThemeData get _tooltipTheme => const TooltipThemeData(
    decoration: BoxDecoration(
      color: DAGRDColors.grisOscuro,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    textStyle: TextStyle(
      color: DAGRDColors.onPrimary,
      fontSize: 12,
      fontFamily: 'Work Sans',
    ),
  );

  // ============================================================================
  // CONFIGURACIÓN DE SWITCH
  // ============================================================================

  static SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return DAGRDColors.azulDAGRD;
      }
      return DAGRDColors.grisMedio;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return DAGRDColors.azulDAGRD.withOpacity(0.5);
      }
      return DAGRDColors.outline;
    }),
  );

  // ============================================================================
  // CONFIGURACIÓN DE CHECKBOX
  // ============================================================================

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return DAGRDColors.azulDAGRD;
      }
      return DAGRDColors.surface;
    }),
    checkColor: MaterialStateProperty.all(DAGRDColors.onPrimary),
    side: const BorderSide(color: DAGRDColors.outline),
  );

  // ============================================================================
  // CONFIGURACIÓN DE RADIO
  // ============================================================================

  static RadioThemeData get _radioTheme => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return DAGRDColors.azulDAGRD;
      }
      return DAGRDColors.grisMedio;
    }),
  );
}