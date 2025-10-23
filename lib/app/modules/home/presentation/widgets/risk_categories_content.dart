import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_header.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_container.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_info_container.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/results_risk_section_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';

/// Widget principal que contiene todo el contenido de la pantalla de categorías de riesgo
class RiskCategoriesContent extends StatelessWidget {
  final List<String> classifications;
  final String selectedEvent;
  final Map<String, CategoryState> categoryStates;
  final Function(String, String, bool) onCategoryTap;
  final HomeState homeState;

  const RiskCategoriesContent({
    super.key,
    required this.classifications,
    required this.selectedEvent,
    required this.categoryStates,
    required this.onCategoryTap,
    required this.homeState,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const RiskCategoriesHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Contenedor de categorías
                  RiskCategoriesContainer(
                    classifications: classifications,
                    selectedEvent: selectedEvent,
                    categoryStates: categoryStates,
                    onCategoryTap: onCategoryTap,
                  ),
                  const SizedBox(height: 24),
                  
                  // Información
                  const RiskInfoContainer(),
                  const SizedBox(height: 24),
                  
                  // Resultados Riesgo
                  ResultsRiskSectionWidget(
                    homeState: homeState,
                    selectedEvent: selectedEvent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
