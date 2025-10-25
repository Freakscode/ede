import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/domain/entities/category_state.dart';

/// Widget para el contenedor de categorías de riesgo
class RiskCategoriesContainer extends StatelessWidget {
  final String selectedEvent;
  final Function(String, String, bool) onCategoryTap;
  final Function(String) getCategoryState;

  const RiskCategoriesContainer({
    super.key,
    required this.selectedEvent,
    required this.onCategoryTap,
    required this.getCategoryState,
  });

  @override
  Widget build(BuildContext context) {
    // Clasificaciones fijas para el análisis de riesgo
    final classifications = ['Amenaza', 'Vulnerabilidad'];
    
    return Column(
      children: [
        // Generar CategoryCards dinámicamente basadas en las clasificaciones
        ...classifications.asMap().entries.map((entry) {
          final index = entry.key;
          final classification = entry.value;
          final categoryState = getCategoryState(classification);
          
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < classifications.length - 1 ? 16.0 : 0,
            ),
            child: _buildCategoryCard(
              context,
              classification,
              categoryState,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String classification,
    CategoryState categoryState,
  ) {
    final trailingIcon = _buildTrailingIcon(categoryState);
    final title = '$classification $selectedEvent';

    return CategoryCard(
      title: title,
      trailingIcon: trailingIcon,
      onTap: () => onCategoryTap(classification, selectedEvent, categoryState.progressPercentage == 100),
    );
  }

  Widget? _buildTrailingIcon(CategoryState categoryState) {
    print('=== DEBUG _buildTrailingIcon ===');
    print('progressPercentage: ${categoryState.progressPercentage}');
    
    // Lógica simplificada basada en el porcentaje de progreso
    if (categoryState.progressPercentage == 100) {
      print('Mostrando checkmark (100%)');
      // Si 100%: mostrar checkmark
      return SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(AppIcons.checkCircle, width: 24, height: 24),
      );
    } else if (categoryState.progressPercentage > 0 && categoryState.progressPercentage < 100) {
      print('Mostrando icono de borrador (${categoryState.progressPercentage}%)');
      // Si entre 1% y 99%: mostrar icono de borrador
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
      print('No mostrando icono (0%)');
      // Si 0%: no mostrar nada
      return const SizedBox.shrink();
    }
  }
}
