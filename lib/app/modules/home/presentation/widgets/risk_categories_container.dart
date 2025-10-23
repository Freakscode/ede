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
              const CategoryState(isAvailable: false, isCompleted: false);

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
        }).toList(),
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
            ? () => onCategoryTap(classification, selectedEvent, categoryState.isCompleted)
            : () => _showDisabledMessage(context, categoryState.disabledMessage),
      ),
    );
  }

  // Construir el ícono trailing según el estado
  Widget? _buildTrailingIcon(CategoryState categoryState) {
    if (categoryState.isCompleted) {
      return SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(AppIcons.checkCircle, width: 24, height: 24),
      );
    } else if (!categoryState.isAvailable) {
      return const Icon(
        Icons.lock_outlined,
        color: DAGRDColors.grisMedio,
        size: 16,
      );
    }
    return null;
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
  final bool isCompleted;
  final String? disabledMessage;
  
  const CategoryState({
    required this.isAvailable,
    required this.isCompleted,
    this.disabledMessage,
  });
}
