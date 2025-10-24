import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/dagrd_colors.dart';
import '../../../core/icons/app_icons.dart';

/// Widget reutilizable para SnackBars personalizados con el tema DAGRD
class CustomSnackBar {
  CustomSnackBar._(); // Constructor privado

  /// Mostrar SnackBar de éxito
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.checkCirclev2,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.success,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title ?? 'Ubicación guardada',
                    style: const TextStyle(
                      color: DAGRDColors.onSurface,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: DAGRDColors.onSurface,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        backgroundColor: Colors.white,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: DAGRDColors.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  /// Mostrar SnackBar de error
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.siren,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.error,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title ?? 'Error',
                    style: const TextStyle(
                      color: DAGRDColors.onSurface,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: DAGRDColors.onSurface,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        backgroundColor: Colors.white,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: DAGRDColors.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  /// Mostrar SnackBar de advertencia
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.warning,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.warning,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title ?? 'Advertencia',
                    style: const TextStyle(
                      color: DAGRDColors.onSurface,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: DAGRDColors.onSurface,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        backgroundColor: Colors.white,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: DAGRDColors.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  /// Mostrar SnackBar informativo
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.info,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.info,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title ?? 'Información',
                    style: const TextStyle(
                      color: DAGRDColors.onSurface,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: DAGRDColors.onSurface,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        backgroundColor: Colors.white,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: DAGRDColors.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  /// Mostrar SnackBar personalizado
  static void showCustom(
    BuildContext context, {
    required Widget content,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: DAGRDColors.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
        margin: margin ?? const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
  }

  /// Limpiar todos los SnackBars
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
