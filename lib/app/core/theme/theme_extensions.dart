import 'package:flutter/material.dart';
import 'dagrd_colors.dart';

/// Extensiones de tema personalizadas para DAGRD
/// Permite acceder fácilmente a colores y estilos específicos del tema

/// Extensión para acceder a colores DAGRD desde el contexto
extension DAGRDThemeExtension on BuildContext {
  /// Obtener colores DAGRD desde el tema
  Type get ThemeColors => ThemeColors;
  
  /// Obtener colores del esquema de colores
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Obtener tema de texto
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Verificar si el tema es oscuro
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// Extensión para crear estilos de texto consistentes
extension DAGRDTextStyles on BuildContext {
  /// Estilo para títulos principales
  TextStyle get titleStyle => textTheme.titleLarge!.copyWith(
    color: ThemeColors.onSurface,
    fontWeight: FontWeight.w600,
  );
  
  /// Estilo para subtítulos
  TextStyle get subtitleStyle => textTheme.titleMedium!.copyWith(
    color: ThemeColors.onSurfaceVariant,
    fontWeight: FontWeight.w500,
  );
  
  /// Estilo para texto del cuerpo
  TextStyle get bodyStyle => textTheme.bodyMedium!.copyWith(
    color: ThemeColors.onSurface,
  );
  
  /// Estilo para texto secundario
  TextStyle get captionStyle => textTheme.bodySmall!.copyWith(
    color: ThemeColors.onSurfaceVariant,
  );
  
  /// Estilo para texto de error
  TextStyle get errorStyle => textTheme.bodyMedium!.copyWith(
    color: ThemeColors.error,
  );
  
  /// Estilo para texto de éxito
  TextStyle get successStyle => textTheme.bodyMedium!.copyWith(
    color: ThemeColors.success,
  );
  
  /// Estilo para texto de advertencia
  TextStyle get warningStyle => textTheme.bodyMedium!.copyWith(
    color: ThemeColors.warning,
  );
}

/// Extensión para crear estilos de botones consistentes
extension DAGRDButtonStyles on BuildContext {
  /// Estilo para botón primario
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.azulDAGRD,
    foregroundColor: ThemeColors.onPrimary,
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  /// Estilo para botón secundario
  ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.amarilloDAGRD,
    foregroundColor: ThemeColors.onSecondary,
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  /// Estilo para botón de texto
  ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: ThemeColors.azulDAGRD,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );
  
  /// Estilo para botón outlined
  ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: ThemeColors.azulDAGRD,
    side: const BorderSide(color: ThemeColors.azulDAGRD),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

/// Extensión para crear estilos de cards consistentes
extension DAGRDCardStyles on BuildContext {
  /// Estilo para card estándar
  BoxDecoration get cardDecoration => BoxDecoration(
    color: ThemeColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: ThemeColors.grisOscuro.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  /// Estilo para card elevada
  BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: ThemeColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: ThemeColors.grisOscuro.withOpacity(0.15),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  /// Estilo para card con borde
  BoxDecoration get borderedCardDecoration => BoxDecoration(
    color: ThemeColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: ThemeColors.outline),
  );
}

/// Extensión para crear estilos de input consistentes
extension DAGRDInputStyles on BuildContext {
  /// Decoración para input estándar
  InputDecoration get standardInputDecoration => InputDecoration(
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
  
  /// Decoración para input con label
  InputDecoration inputDecorationWithLabel(String label) => standardInputDecoration.copyWith(
    labelText: label,
    labelStyle: TextStyle(
      color: ThemeColors.onSurfaceVariant,
      fontSize: 14,
    ),
  );
  
  /// Decoración para input con hint
  InputDecoration inputDecorationWithHint(String hint) => standardInputDecoration.copyWith(
    hintText: hint,
    hintStyle: TextStyle(
      color: ThemeColors.onSurfaceVariant,
      fontSize: 14,
    ),
  );
}

/// Extensión para crear estilos de nivel de amenaza/vulnerabilidad
extension DAGRDLevelStyles on BuildContext {
  /// Obtener color de nivel
  Color getLevelColor(String nivel) => ThemeColors.getNivelColor(nivel);
  
  /// Obtener estilo de texto para nivel
  TextStyle getLevelTextStyle(String nivel) => textTheme.bodyMedium!.copyWith(
    color: getLevelColor(nivel),
    fontWeight: FontWeight.w600,
  );
  
  /// Obtener decoración para card de nivel
  BoxDecoration getLevelCardDecoration(String nivel) => BoxDecoration(
    color: getLevelColor(nivel).withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: getLevelColor(nivel)),
  );
  
  /// Obtener decoración para botón de nivel
  ButtonStyle getLevelButtonStyle(String nivel) => ElevatedButton.styleFrom(
    backgroundColor: getLevelColor(nivel),
    foregroundColor: ThemeColors.getTextColorForBackground(getLevelColor(nivel)),
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  );
}
