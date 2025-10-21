import 'package:flutter/material.dart';

/// Colores oficiales de DAGRD para la aplicación Caja de Herramientas
/// Organizados por categorías para mejor mantenimiento
class DAGRDColors {
  DAGRDColors._(); // Constructor privado para evitar instancias

  // ============================================================================
  // COLORES PRINCIPALES DAGRD
  // ============================================================================

  /// Color azul principal de DAGRD
  static const Color azulDAGRD = Color(0xFF232B48);
  
  /// Color amarillo principal de DAGRD
  static const Color amarilloDAGRD = Color(0xFFFBBF24);
  
  /// Color amarillo alternativo DAGRD
  static const Color amarDAGRD = Color(0xFFFFCC00);

  // ============================================================================
  // COLORES SECUNDARIOS DAGRD
  // ============================================================================

  /// Color azul secundario DAGRD
  static const Color azulSecundario = Color(0xFF2563EB);

  /// Color azul 3D DAGRD para backgrounds destacados
  static const Color azul3DAGRD = Color(0xFF2D3E91);

  // ============================================================================
  // COLORES NEUTROS
  // ============================================================================

  /// Color blanco para textos sobre fondos azules
  static const Color blancoDAGRD = Color(0xFFFFFFFF);
  
  /// Color negro para textos principales
  static const Color negroDAGRD = Color(0xFF1E1E1E);
  
  /// Color gris claro para fondos
  static const Color grisClaro = Color(0xFFF7FAFC);
  
  /// Color gris medio para textos secundarios
  static const Color grisMedio = Color(0xFF718096);
  
  /// Color gris oscuro para textos principales
  static const Color grisOscuro = Color(0xFF2D3748);

  // ============================================================================
  // GRADIENTES
  // ============================================================================

  /// Gradiente azul DAGRD para headers y elementos destacados
  static const LinearGradient gradienteAzul = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF232B48),
      Color(0xFF1A202C),
    ],
  );

  /// Gradiente amarillo DAGRD
  static const LinearGradient gradienteAmarillo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFBBF24),
      Color(0xFFF59E0B),
    ],
  );

  // ============================================================================
  // COLORES DE ESTADO Y ALERTAS
  // ============================================================================

  /// Color de éxito
  static const Color success = Color(0xFF38A169);
  
  /// Color de advertencia
  static const Color warning = Color(0xFFD69E2E);
  
  /// Color de error
  static const Color error = Color(0xFFE53E3E);
  
  /// Color informativo
  static const Color info = Color(0xFF3182CE);

  // ============================================================================
  // COLORES PARA NIVELES DE AMENAZA/VULNERABILIDAD
  // ============================================================================

  /// Color para nivel BAJO (Verde)
  static const Color nivelBajo = Color(0xFF22C55E);
  
  /// Color para nivel MEDIO BAJO (Amarillo)
  static const Color nivelMedioBajo = Color(0xFFFDE047);
  
  /// Color para nivel MEDIO ALTO (Naranja)
  static const Color nivelMedioAlto = Color(0xFFFB923C);
  
  /// Color para nivel ALTO (Rojo)
  static const Color nivelAlto = Color(0xFFFF0000);

  // ============================================================================
  // COLORES SEMÁNTICOS
  // ============================================================================

  /// Color para fondos de superficie
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Color para fondos de superficie secundaria
  static const Color surfaceVariant = Color(0xFFF7FAFC);
  
  /// Color para bordes
  static const Color outline = Color(0xFFE5E7EB);
  
  /// Color para bordes de enfoque
  static const Color outlineVariant = Color(0xFFD1D5DB);

  // ============================================================================
  // COLORES DE TEXTO
  // ============================================================================

  /// Color para texto primario
  static const Color onSurface = Color(0xFF1E1E1E);
  
  /// Color para texto secundario
  static const Color onSurfaceVariant = Color(0xFF718096);
  
  /// Color para texto sobre fondos oscuros
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  /// Color para texto sobre fondos de acento
  static const Color onSecondary = Color(0xFF232B48);

  // ============================================================================
  // MÉTODOS UTILITARIOS
  // ============================================================================

  /// Obtener color de nivel según el valor
  static Color getNivelColor(String nivel) {
    switch (nivel.toUpperCase()) {
      case 'BAJO':
        return nivelBajo;
      case 'MEDIO BAJO':
        return nivelMedioBajo;
      case 'MEDIO ALTO':
        return nivelMedioAlto;
      case 'ALTO':
        return nivelAlto;
      default:
        return grisMedio;
    }
  }

  /// Obtener color de estado según el tipo
  static Color getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'success':
      case 'éxito':
        return success;
      case 'warning':
      case 'advertencia':
        return warning;
      case 'error':
        return error;
      case 'info':
      case 'información':
        return info;
      default:
        return grisMedio;
    }
  }

  /// Verificar si un color es claro (para determinar color de texto)
  static bool isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Obtener color de texto apropiado para un fondo dado
  static Color getTextColorForBackground(Color backgroundColor) {
    return isLightColor(backgroundColor) ? onSurface : onPrimary;
  }
}