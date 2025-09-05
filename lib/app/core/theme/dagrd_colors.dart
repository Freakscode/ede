import 'package:flutter/material.dart';

/// Colores oficiales de DAGRD para la aplicación Caja de Herramientas
class DAGRDColors {
  DAGRDColors._(); // Constructor privado para evitar instancias

  /// Color azul principal de DAGRD
  static const Color azulDAGRD = Color(0xFF232B48);
  
  /// Color amarillo de acentos y botones
  static const Color amarilloDAGRD = Color(0xFFFBBF24);
  
  /// Color amarillo alternativo DAGRD
  static const Color amarDAGRD = Color(0xFFFFCC00);
  
  /// Color blanco para textos sobre fondos azules
  static const Color blancoDAGRD = Color(0xFFFFFFFF);
  
  /// Color gris claro para fondos
  static const Color grisClaro = Color(0xFFF7FAFC);
  
  /// Color gris medio para textos secundarios
  static const Color grisMedio = Color(0xFF718096);
  
  /// Color gris oscuro para textos principales
  static const Color grisOscuro = Color(0xFF2D3748);

  /// Gradiente azul DAGRD para headers y elementos destacados
  static const LinearGradient gradienteAzul = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF232B48),
      Color(0xFF1A202C),
    ],
  );

  /// Paleta de colores para estados y alertas
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);
}
