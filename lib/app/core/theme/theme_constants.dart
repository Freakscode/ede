import 'package:flutter/material.dart';

/// Constantes del tema de la aplicación DAGRD
/// Valores reutilizables para espaciado, tamaños, etc.
class ThemeConstants {
  ThemeConstants._(); // Constructor privado

  // ============================================================================
  // ESPACIADO
  // ============================================================================

  /// Espaciado extra pequeño
  static const double spacingXS = 4.0;
  
  /// Espaciado pequeño
  static const double spacingS = 8.0;
  
  /// Espaciado mediano
  static const double spacingM = 16.0;
  
  /// Espaciado grande
  static const double spacingL = 24.0;
  
  /// Espaciado extra grande
  static const double spacingXL = 32.0;
  
  /// Espaciado extra extra grande
  static const double spacingXXL = 48.0;

  // ============================================================================
  // BORDES Y RADIOS
  // ============================================================================

  /// Radio de borde pequeño
  static const double radiusS = 4.0;
  
  /// Radio de borde mediano
  static const double radiusM = 8.0;
  
  /// Radio de borde grande
  static const double radiusL = 12.0;
  
  /// Radio de borde extra grande
  static const double radiusXL = 16.0;
  
  /// Radio de borde circular
  static const double radiusCircular = 50.0;

  // ============================================================================
  // TAMAÑOS DE ICONOS
  // ============================================================================

  /// Tamaño de icono pequeño
  static const double iconSizeS = 16.0;
  
  /// Tamaño de icono mediano
  static const double iconSizeM = 24.0;
  
  /// Tamaño de icono grande
  static const double iconSizeL = 32.0;
  
  /// Tamaño de icono extra grande
  static const double iconSizeXL = 48.0;

  // ============================================================================
  // TAMAÑOS DE BOTONES
  // ============================================================================

  /// Altura de botón pequeño
  static const double buttonHeightS = 32.0;
  
  /// Altura de botón mediano
  static const double buttonHeightM = 40.0;
  
  /// Altura de botón grande
  static const double buttonHeightL = 48.0;
  
  /// Altura de botón extra grande
  static const double buttonHeightXL = 56.0;

  // ============================================================================
  // TAMAÑOS DE INPUTS
  // ============================================================================

  /// Altura de input pequeño
  static const double inputHeightS = 36.0;
  
  /// Altura de input mediano
  static const double inputHeightM = 44.0;
  
  /// Altura de input grande
  static const double inputHeightL = 52.0;

  // ============================================================================
  // ELEVACIÓN Y SOMBRAS
  // ============================================================================

  /// Elevación baja
  static const double elevationLow = 2.0;
  
  /// Elevación mediana
  static const double elevationMedium = 4.0;
  
  /// Elevación alta
  static const double elevationHigh = 8.0;
  
  /// Elevación extra alta
  static const double elevationExtraHigh = 16.0;

  // ============================================================================
  // DURACIONES DE ANIMACIÓN
  // ============================================================================

  /// Duración de animación rápida
  static const Duration animationFast = Duration(milliseconds: 150);
  
  /// Duración de animación mediana
  static const Duration animationMedium = Duration(milliseconds: 300);
  
  /// Duración de animación lenta
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================================
  // CURVAS DE ANIMACIÓN
  // ============================================================================

  /// Curva de animación estándar
  static const Curve animationCurve = Curves.easeInOut;
  
  /// Curva de animación rápida
  static const Curve animationCurveFast = Curves.easeOut;
  
  /// Curva de animación lenta
  static const Curve animationCurveSlow = Curves.easeIn;

  // ============================================================================
  // TAMAÑOS CUERPO DE TEXTO
  // ============================================================================

  /// Tamaño de texto extra pequeño
  static const double textSizeXS = 10.0;
  
  /// Tamaño de texto pequeño
  static const double textSizeS = 12.0;
  
  /// Tamaño de texto mediano
  static const double textSizeM = 14.0;
  
  /// Tamaño de texto grande
  static const double textSizeL = 16.0;
  
  /// Tamaño de texto extra grande
  static const double textSizeXL = 18.0;
  
  /// Tamaño de texto extra extra grande
  static const double textSizeXXL = 20.0;

  // ============================================================================
  // PESOS DE FUENTE
  // ============================================================================

  /// Peso de fuente ligero
  static const FontWeight fontWeightLight = FontWeight.w300;
  
  /// Peso de fuente normal
  static const FontWeight fontWeightNormal = FontWeight.w400;
  
  /// Peso de fuente mediano
  static const FontWeight fontWeightMedium = FontWeight.w500;
  
  /// Peso de fuente semi-bold
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  
  /// Peso de fuente bold
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  /// Peso de fuente extra bold
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // ============================================================================
  // MÉTODOS UTILITARIOS
  // ============================================================================

  /// Obtener espaciado por índice
  static double getSpacing(int index) {
    switch (index) {
      case 0: return spacingXS;
      case 1: return spacingS;
      case 2: return spacingM;
      case 3: return spacingL;
      case 4: return spacingXL;
      case 5: return spacingXXL;
      default: return spacingM;
    }
  }

  /// Obtener radio por índice
  static double getRadius(int index) {
    switch (index) {
      case 0: return radiusS;
      case 1: return radiusM;
      case 2: return radiusL;
      case 3: return radiusXL;
      default: return radiusM;
    }
  }

  /// Obtener tamaño de icono por índice
  static double getIconSize(int index) {
    switch (index) {
      case 0: return iconSizeS;
      case 1: return iconSizeM;
      case 2: return iconSizeL;
      case 3: return iconSizeXL;
      default: return iconSizeM;
    }
  }

  /// Obtener altura de botón por índice
  static double getButtonHeight(int index) {
    switch (index) {
      case 0: return buttonHeightS;
      case 1: return buttonHeightM;
      case 2: return buttonHeightL;
      case 3: return buttonHeightXL;
      default: return buttonHeightM;
    }
  }

  /// Obtener elevación por índice
  static double getElevation(int index) {
    switch (index) {
      case 0: return elevationLow;
      case 1: return elevationMedium;
      case 2: return elevationHigh;
      case 3: return elevationExtraHigh;
      default: return elevationMedium;
    }
  }
}
