import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';

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
    scaffoldBackgroundColor: ThemeColors.surface,
    
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
    primary: ThemeColors.azulDAGRD,
    onPrimary: ThemeColors.onPrimary,
    primaryContainer: ThemeColors.azulSecundario,
    onPrimaryContainer: ThemeColors.onPrimary,
    
    // Colores secundarios
    secondary: ThemeColors.amarilloDAGRD,
    onSecondary: ThemeColors.onSecondary,
    secondaryContainer: ThemeColors.amarDAGRD,
    onSecondaryContainer: ThemeColors.onSecondary,
    
    // Colores de superficie
    surface: ThemeColors.surface,
    onSurface: ThemeColors.onSurface,
    surfaceVariant: ThemeColors.surfaceVariant,
    onSurfaceVariant: ThemeColors.onSurfaceVariant,
    
    // Colores de fondo
    background: ThemeColors.surface,
    onBackground: ThemeColors.onSurface,
    
    // Colores de error
    error: ThemeColors.error,
    onError: ThemeColors.onPrimary,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    // Colores de outline
    outline: ThemeColors.outline,
    outlineVariant: ThemeColors.outlineVariant,
    
    // Colores de sombra
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    
    // Colores de superficie inversa
    inverseSurface: ThemeColors.grisOscuro,
    onInverseSurface: ThemeColors.onPrimary,
    inversePrimary: ThemeColors.amarilloDAGRD,
  );

  // ============================================================================
  // CONFIGURACIÓN DE APPBAR
  // ============================================================================

  static AppBarTheme get _appBarTheme => const AppBarTheme(
    backgroundColor: ThemeColors.azulDAGRD,
    foregroundColor: ThemeColors.onPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: ThemeColors.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
    ),
    iconTheme: IconThemeData(
      color: ThemeColors.onPrimary,
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ============================================================================
  // CONFIGURACIÓN DE CARDS
  // ============================================================================

  static CardThemeData get _cardTheme => CardThemeData(
    color: ThemeColors.surface,
    elevation: 2,
    shadowColor: ThemeColors.grisOscuro,
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
      backgroundColor: ThemeColors.azulDAGRD,
      foregroundColor: ThemeColors.onPrimary,
      elevation: 2,
      shadowColor: ThemeColors.grisOscuro,
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
      foregroundColor: ThemeColors.azulDAGRD,
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
      foregroundColor: ThemeColors.azulDAGRD,
      side: const BorderSide(color: ThemeColors.azulDAGRD),
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
    backgroundColor: ThemeColors.amarilloDAGRD,
    foregroundColor: ThemeColors.onSecondary,
    elevation: 4,
  );

  // ============================================================================
  // CONFIGURACIÓN DE INPUTS
  // ============================================================================

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: ThemeColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ThemeColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ThemeColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ThemeColors.azulDAGRD, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ThemeColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ThemeColors.error, width: 2),
    ),
    labelStyle: const TextStyle(
      color: ThemeColors.onSurfaceVariant,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
    hintStyle: const TextStyle(
      color: ThemeColors.onSurfaceVariant,
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
      color: ThemeColors.onSurface,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      fontFamily: 'Work Sans',
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    
    // Títulos
    titleLarge: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.27,
    ),
    titleMedium: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.5,
    ),
    titleSmall: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    
    // Texto del cuerpo
    bodyLarge: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    bodySmall: TextStyle(
      color: ThemeColors.onSurfaceVariant,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    
    // Etiquetas
    labelLarge: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      height: 1.43,
    ),
    labelMedium: TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      height: 1.33,
    ),
    labelSmall: TextStyle(
      color: ThemeColors.onSurfaceVariant,
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
    color: ThemeColors.onSurface,
    size: 24,
  );

  // ============================================================================
  // CONFIGURACIÓN DE DIVIDERS
  // ============================================================================

  static DividerThemeData get _dividerTheme => const DividerThemeData(
    color: ThemeColors.outline,
    thickness: 1,
    space: 1,
  );

  // ============================================================================
  // CONFIGURACIÓN DE BOTTOM NAVIGATION
  // ============================================================================

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme => const BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.surface,
    selectedItemColor: ThemeColors.azulDAGRD,
    unselectedItemColor: ThemeColors.onSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // ============================================================================
  // CONFIGURACIÓN DE SNACKBAR
  // ============================================================================

  static SnackBarThemeData get _snackBarTheme => const SnackBarThemeData(
    backgroundColor: ThemeColors.grisOscuro,
    contentTextStyle: TextStyle(
      color: ThemeColors.onPrimary,
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
    backgroundColor: ThemeColors.surface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    titleTextStyle: const TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Work Sans',
    ),
    contentTextStyle: const TextStyle(
      color: ThemeColors.onSurface,
      fontSize: 14,
      fontFamily: 'Work Sans',
    ),
  );

  // ============================================================================
  // CONFIGURACIÓN DE TOOLTIP
  // ============================================================================

  static TooltipThemeData get _tooltipTheme => const TooltipThemeData(
    decoration: BoxDecoration(
      color: ThemeColors.grisOscuro,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    textStyle: TextStyle(
      color: ThemeColors.onPrimary,
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
        return ThemeColors.azulDAGRD;
      }
      return ThemeColors.grisMedio;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return ThemeColors.azulDAGRD.withOpacity(0.5);
      }
      return ThemeColors.outline;
    }),
  );

  // ============================================================================
  // CONFIGURACIÓN DE CHECKBOX
  // ============================================================================

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return ThemeColors.azulDAGRD;
      }
      return ThemeColors.surface;
    }),
    checkColor: MaterialStateProperty.all(ThemeColors.onPrimary),
    side: const BorderSide(color: ThemeColors.outline),
  );

  // ============================================================================
  // CONFIGURACIÓN DE RADIO
  // ============================================================================

  static RadioThemeData get _radioTheme => RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return ThemeColors.azulDAGRD;
      }
      return ThemeColors.grisMedio;
    }),
  );
}