import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/risk_categories_header.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/risk_categories_container.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/risk_info_container.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/results_risk_section_widget.dart';

/// Widget principal que contiene todo el contenido de la pantalla de categorías de riesgo
class RiskCategoriesContent extends StatelessWidget {
  final String selectedEvent;
  final Function(String, String, bool) onCategoryTap;
  final Function(String) getCategoryState;

  const RiskCategoriesContent({
    super.key,
    required this.selectedEvent,
    required this.onCategoryTap,
    required this.getCategoryState,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header con información del evento
            RiskCategoriesHeader(selectedEvent: selectedEvent),
            
            const SizedBox(height: 16),
            
            // Contenedor principal con las categorías
            RiskCategoriesContainer(
              selectedEvent: selectedEvent,
              onCategoryTap: onCategoryTap,
              getCategoryState: getCategoryState,
            ),
            
            const SizedBox(height: 16),
            
            // Información adicional sobre el riesgo
            const RiskInfoContainer(),
            
            const SizedBox(height: 16),
            
            // Sección de resultados si está disponible
            const ResultsRiskSectionWidget(),
          ],
        ),
      ),
    );
  }
}
