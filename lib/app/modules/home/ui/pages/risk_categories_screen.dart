import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RiskCategoriesScreen extends StatelessWidget {
  const RiskCategoriesScreen({super.key});

  // Método helper para verificar si la amenaza está completa
  bool _isAmenazaCompleted(RiskThreatAnalysisBloc bloc, RiskThreatAnalysisState state, String selectedEvent) {
    // Verificar si el evento seleccionado coincide con el del bloc
    if (state.selectedRiskEvent != selectedEvent) {
      return false;
    }
    
    // Verificar si hay selecciones de amenaza
    final hasAmenazaSelections = state.probabilidadSelections.isNotEmpty && 
                                 state.intensidadSelections.isNotEmpty;
    
    if (!hasAmenazaSelections) {
      return false;
    }
    
    // Para ser más estricto, podemos verificar que todas las categorías estén completas
    // Obtener todas las subclasificaciones de amenaza
    final amenazaSubClassifications = bloc.getAmenazaSubClassifications();
    
    for (final subClassification in amenazaSubClassifications) {
      final categories = bloc.getCategoriesForSubClassification(subClassification.id);
      Map<String, String> selections;
      
      if (subClassification.id == 'probabilidad') {
        selections = state.probabilidadSelections;
      } else if (subClassification.id == 'intensidad') {
        selections = state.intensidadSelections;
      } else {
        selections = state.dynamicSelections[subClassification.id] ?? {};
      }
      
      // Verificar que todas las categorías de esta subclasificación estén completadas
      for (final category in categories) {
        if (!selections.containsKey(category.title) || 
            selections[category.title]?.isEmpty == true) {
          return false;
        }
      }
    }
    
    return true;
  }

  // Método helper para construir las CategoryCard personalizadas
  Widget _buildCategoryCard(
    BuildContext context,
    dynamic classification,
    String selectedEvent,
    bool isAvailable,
    bool isCompleted,
    String? disabledMessage,
  ) {
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.6,
      child: Stack(
        children: [
          CategoryCard(
            title: '${classification.name} $selectedEvent',
            onTap: isAvailable ? () {
              // Guardar la categoría seleccionada
              context.read<HomeBloc>().add(
                SelectRiskCategory(classification.name, selectedEvent),
              );
              // Navegar a siguiente pantalla pasando tanto el evento como la clasificación
              final navigationData = {
                'event': selectedEvent,
                'classification': classification.name.toLowerCase(),
              };
              context.go('/risk_threat_analysis', extra: navigationData);
            } : () {
              // Mostrar mensaje de que debe completar amenaza primero
              if (disabledMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(disabledMessage),
                    backgroundColor: DAGRDColors.warning,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          // Indicador de completitud
          if (isCompleted)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: DAGRDColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          // Indicador de no disponible
          if (!isAvailable)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: DAGRDColors.warning,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final selectedEvent = homeState.selectedRiskEvent;
        
        // Obtener las clasificaciones del evento seleccionado a través del Bloc
        final homeBloc = context.read<HomeBloc>();
        final classifications = homeBloc.getEventClassifications(selectedEvent);
        
        return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
          builder: (context, riskState) {
            final riskBloc = context.read<RiskThreatAnalysisBloc>();
            
            // Verificar si la amenaza está completa
            final isAmenazaCompleted = _isAmenazaCompleted(riskBloc, riskState, selectedEvent);
        
        return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            Center(
              child: Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48), // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20, // 140% line-height
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Seleccione una categoría',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF706F6F), // GrisDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556% line-height
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Generar CategoryCards dinámicamente basadas en las clasificaciones del modelo
                  ...classifications.asMap().entries.map((entry) {
                    final index = entry.key;
                    final classification = entry.value;
                    final isAmenaza = classification.name.toLowerCase() == 'amenaza';
                    final isVulnerabilidad = classification.name.toLowerCase() == 'vulnerabilidad';
                    
                    // Determinar si esta categoría está disponible
                    bool isAvailable = true;
                    bool isCompleted = false;
                    String? disabledMessage;
                    
                    if (isAmenaza) {
                      // Amenaza siempre está disponible
                      isAvailable = true;
                      isCompleted = isAmenazaCompleted;
                    } else if (isVulnerabilidad) {
                      // Vulnerabilidad solo está disponible si amenaza está completa
                      isAvailable = isAmenazaCompleted;
                      if (!isAvailable) {
                        disabledMessage = 'Complete primero la sección de Amenaza';
                      }
                      // TODO: Verificar si vulnerabilidad está completa
                      isCompleted = false;
                    }
                    
                    return Column(
                      children: [
                        _buildCategoryCard(
                          context,
                          classification,
                          selectedEvent,
                          isAvailable,
                          isCompleted,
                          disabledMessage,
                        ),
                        // Agregar espaciado entre cards, excepto después del último
                        if (index < classifications.length - 1) 
                          const SizedBox(height: 18),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Información con progreso
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progreso de Evaluación',
                              style: const TextStyle(
                                color: DAGRDColors.azulSecundario,
                                fontFamily: 'Work Sans',
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                height: 18 / 13,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isAmenazaCompleted ? DAGRDColors.success : DAGRDColors.warning,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isAmenazaCompleted ? '1/2 Completado' : '0/2 Completado',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Work Sans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Barra de progreso visual
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: isAmenazaCompleted ? 0.5 : 0.0,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isAmenazaCompleted ? DAGRDColors.success : DAGRDColors.warning,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isAmenazaCompleted 
                            ? '✓ Amenaza completada. Puede continuar con Vulnerabilidad.'
                            : '1. Complete primero la sección de Amenaza\n2. Luego podrá acceder a Vulnerabilidad',
                          style: const TextStyle(
                            color: DAGRDColors.azulSecundario,
                            fontFamily: 'Work Sans',
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 18 / 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resultados Riesgo
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFE5E7EB,
                      ), // Updated background color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(9.882),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC6C6C6), // Gris2DAGRD
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: SvgPicture.asset(
                            AppIcons.warning,
                            width: 24.707, // Updated width from CSS
                            height: 22.059, // Updated height from CSS
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF706F6F), // GrisDAGRD fill color
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Resultados Riesgo',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF706F6F), // GrisDAGRD
                                  fontFamily: 'Work Sans',
                                  fontSize: 18,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  height: 24 / 18, // 133.333% line-height
                                ),
                              ),
                              Text(
                                selectedEvent,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF706F6F), // GrisDAGRD
                                  fontFamily: 'Work Sans',
                                  fontSize: 18,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  height: 24 / 18, // 133.333% line-height
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Debug info - mostrar categoría seleccionada
            if (homeState.selectedRiskCategory != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DAGRDColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: DAGRDColors.success,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Última categoría seleccionada:',
                        style: const TextStyle(
                          color: DAGRDColors.azulSecundario,
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        homeState.selectedRiskCategory!,
                        style: const TextStyle(
                          color: DAGRDColors.azulSecundario,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
          },
        );
      },
    );
  }
}
