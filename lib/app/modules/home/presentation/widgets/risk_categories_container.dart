import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/category_card.dart';

/// Widget para el contenedor de categorías de riesgo
class RiskCategoriesContainer extends StatelessWidget {
  final List<String> classifications;
  final String selectedEvent;
  final Map<String, CategoryState> categoryStates;
  final Function(String, String, bool) onCategoryTap;

  const RiskCategoriesContainer({
    super.key,
    required this.classifications,
    required this.selectedEvent,
    required this.categoryStates,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Generar CategoryCards dinámicamente basadas en las clasificaciones del modelo
        ...classifications.asMap().entries.map((entry) {
          final index = entry.key;
          final classification = entry.value;
          final categoryState = categoryStates[classification] ?? 
              const CategoryState(isAvailable: false, progressPercentage: 0);

          return Column(
            children: [
              _buildCategoryCard(
                context,
                classification,
                categoryState,
              ),
              // Agregar espaciado entre cards, excepto después del último
              if (index < classifications.length - 1)
                const SizedBox(height: 18),
            ],
          );
        }),
      ],
    );
  }

  // Construir la tarjeta de categoría
  Widget _buildCategoryCard(
    BuildContext context,
    String classification,
    CategoryState categoryState,
  ) {
    final trailingIcon = _buildTrailingIcon(categoryState);
    final title = '$classification $selectedEvent';

    return Opacity(
      opacity: categoryState.isAvailable ? 1.0 : 0.6,
      child: CategoryCard(
        title: title,
        trailingIcon: trailingIcon,
        onTap: categoryState.isAvailable
            ? () => onCategoryTap(classification, selectedEvent, categoryState.progressPercentage == 100)
            : () => _showDisabledMessage(context, categoryState.disabledMessage),
      ),
    );
  }

  // Construir el ícono trailing según el estado
  Widget? _buildTrailingIcon(CategoryState categoryState) {
    if (!categoryState.isAvailable) {
      return const Icon(
        Icons.lock_outlined,
        color: DAGRDColors.grisMedio,
        size: 16,
      );
    }
    
    // Lógica simplificada basada en porcentaje de progreso
    if (categoryState.progressPercentage == 100) {
      // Si está al 100%: mostrar checkmark
      return SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(AppIcons.checkCircle, width: 24, height: 24),
      );
    } else if (categoryState.progressPercentage > 0 && categoryState.progressPercentage < 100) {
      // Si está entre 1% y 99%: mostrar icono de borrador
      return SizedBox(
        width: 18,
        height: 17,
        child: SvgPicture.asset(
          AppIcons.borrar,
          width: 18,
          height: 17,
          colorFilter: const ColorFilter.mode(
            Color(0xFF2563EB), // Azul informativo
            BlendMode.srcIn,
          ),
        ),
      );
    } else {
      // Si está al 0%: no mostrar nada
      return const SizedBox.shrink();
    }
  }

  // Mostrar mensaje cuando la categoría está deshabilitada
  void _showDisabledMessage(BuildContext context, String? message) {
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: DAGRDColors.warning,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// Clase para manejar el estado de cada categoría
class CategoryState {
  final bool isAvailable;
  final int progressPercentage;
  final String? disabledMessage;
  
  const CategoryState({
    required this.isAvailable,
    required this.progressPercentage,
    this.disabledMessage,
  });
}
