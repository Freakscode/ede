import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/results_risk_section_widget.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RiskCategoriesScreen extends StatelessWidget {
  const RiskCategoriesScreen({super.key});

  // Método helper para construir las CategoryCard personalizadas
  Widget _buildCategoryCard(
    BuildContext context,
    dynamic classification,
    String selectedEvent,
    bool isAvailable,
    bool isCompleted,
    String? disabledMessage,
  ) {
    Widget? trailingIcon;
    
    if (isCompleted) {
      trailingIcon = SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          AppIcons.checkCircle,
          width: 24, 
          height: 24, 
        ),
      );
    } else if (!isAvailable) {
      trailingIcon = const Icon(Icons.lock_outlined, color: DAGRDColors.grisMedio, size: 16);
    }

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.6,
      child: CategoryCard(
        title: '${classification.name} $selectedEvent',
        trailingIcon: trailingIcon,
        onTap: isAvailable
            ? () {
                // Obtener el estado actual del HomeBloc
                final homeBloc = context.read<HomeBloc>();
                final currentHomeState = homeBloc.state;
                
                // Guardar la categoría seleccionada
                homeBloc.add(
                  SelectRiskCategory(classification.name, selectedEvent),
                );
                
                // DETECTAR SI ES UNA NUEVA EVALUACIÓN
                // Si es Amenaza y no está marcada como completada, es nueva evaluación
                // Si es Vulnerabilidad y Amenaza ya está completada pero Vulnerabilidad no, es continuación
                final isAmenaza = classification.name.toLowerCase() == 'amenaza';
                final amenazaCompleted = currentHomeState.completedEvaluations['${selectedEvent}_amenaza'] ?? false;
                final vulnerabilidadCompleted = currentHomeState.completedEvaluations['${selectedEvent}_vulnerabilidad'] ?? false;
                
                final isNewEvaluation = (isAmenaza && !amenazaCompleted) || 
                                       (!isAmenaza && !vulnerabilidadCompleted && amenazaCompleted);
                
                // Si es una nueva evaluación de Amenaza, resetear todo el progreso del evento
                if (isAmenaza && !amenazaCompleted) {
                  homeBloc.add(ResetEvaluationsForEvent(selectedEvent));
                }
                
                final navigationData = <String, dynamic>{
                  'event': selectedEvent,
                  'classification': classification.name.toLowerCase(),
                  'directToResults': isCompleted && !isNewEvaluation,
                  'forceReset': true, // FORZAR reset del formulario
                  'isNewForm': true,   // SIEMPRE nuevo formulario desde categories
                  'loadExisting': false, // NO cargar datos existentes
                  'source': 'RiskCategoriesScreen', // Para debugging
                };
               
                
                context.go('/risk_threat_analysis', extra: navigationData);
              }
            : () {
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
                        final isAmenaza =
                            classification.name.toLowerCase() == 'amenaza';
                        final isVulnerabilidad =
                            classification.name.toLowerCase() ==
                            'vulnerabilidad';

                        // Determinar si esta categoría está disponible
                        bool isAvailable = true;
                        bool isCompleted = false;
                        String? disabledMessage;

                        if (isAmenaza) {
                          // Amenaza siempre está disponible
                          isAvailable = true;
                          isCompleted =
                              homeState
                                  .completedEvaluations['${selectedEvent}_amenaza'] ??
                              false;
                        } else if (isVulnerabilidad) {
                          // Verificar si amenaza está completa usando HomeBloc
                          final amenazaCompleted =
                              homeState
                                  .completedEvaluations['${selectedEvent}_amenaza'] ??
                              false;
                          isAvailable = amenazaCompleted;
                          if (!isAvailable) {
                            disabledMessage =
                                'Complete primero la sección de Amenaza';
                          }
                          // Verificar si vulnerabilidad está completa
                          isCompleted =
                              homeState
                                  .completedEvaluations['${selectedEvent}_vulnerabilidad'] ??
                              false;
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
                                  'Información',
                                  style: const TextStyle(
                                    color: DAGRDColors.azulSecundario,
                                    fontFamily: 'Work Sans',
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    height: 18 / 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Complete los formularios de Amenaza y Vulnerabilidad para visualizar la evaluación completa del riesgo.',
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
      },
    );
  }




}
