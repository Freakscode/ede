import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/results_risk_section_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RiskCategoriesScreen extends StatefulWidget {
  const RiskCategoriesScreen({super.key});

  @override
  State<RiskCategoriesScreen> createState() => _RiskCategoriesScreenState();
}

class _RiskCategoriesScreenState extends State<RiskCategoriesScreen> {

  // Método simple para calcular progreso basado en datos guardados
  Future<double> _getProgressForCategory(String eventName, String categoryType, String? formId) async {
    if (formId == null) return 0.0;
    
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm == null) return 0.0;
      
      // Lógica simplificada: contar selecciones vs total esperado
      if (categoryType.toLowerCase() == 'amenaza') {
        final totalSelections = completeForm.amenazaProbabilidadSelections.length + 
                               completeForm.amenazaIntensidadSelections.length;
        return totalSelections > 0 ? (totalSelections / 6.0).clamp(0.0, 1.0) : 0.0; // Asumiendo 6 categorías totales
      } else if (categoryType.toLowerCase() == 'vulnerabilidad') {
        int totalSelections = 0;
        for (final subClassSelections in completeForm.vulnerabilidadSelections.values) {
          if (subClassSelections.isNotEmpty) {
            totalSelections += subClassSelections.length;
          }
        }
        return totalSelections > 0 ? (totalSelections / 8.0).clamp(0.0, 1.0) : 0.0; // Asumiendo 8 categorías totales
      }
    } catch (e) {
      print('Error al calcular progreso: $e');
    }
    
    return 0.0;
  }

  // Método helper para construir las CategoryCard personalizadas
  Widget _buildCategoryCard(
    BuildContext context,
    dynamic classification,
    String selectedEvent,
    bool isAvailable,
    bool isCompleted,
    String? disabledMessage,
    String? activeFormId,
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
      child: FutureBuilder<double>(
        future: _getProgressForCategory(selectedEvent, classification, activeFormId),
        builder: (context, snapshot) {
          String title = '$classification $selectedEvent';
          
          // No mostrar porcentaje de progreso en los títulos de categorías
          // El progreso se maneja internamente para la funcionalidad
          
          return CategoryCard(
            title: title,
            trailingIcon: trailingIcon,
        onTap: isAvailable
            ? () {
                // Obtener el estado actual del HomeBloc
                final homeBloc = context.read<HomeBloc>();
                
                // Guardar la categoría seleccionada
                homeBloc.add(
                      SelectRiskCategory(
                        categoryType: classification,
                        eventName: selectedEvent,
                      ),
                );
                
                // Obtener el estado actual del HomeBloc
                final currentHomeState = homeBloc.state;
                
                final navigationData = <String, dynamic>{
                  'event': selectedEvent,
                  'classification': classification.toLowerCase(),
                  'directToResults': isCompleted,
                  'source': 'RiskCategoriesScreen', // Para debugging
                };
                
                // Usar el campo isCreatingNew para determinar el tipo de formulario
                print('RiskCategoriesScreen: Estado actual del HomeBloc:');
                print('  - isCreatingNew: ${currentHomeState.isCreatingNew}');
                print('  - activeFormId: ${currentHomeState.activeFormId}');
                print('  - selectedRiskEvent: ${currentHomeState.selectedRiskEvent}');
                
                if (currentHomeState.isCreatingNew) {
                  // Crear formulario nuevo - resetear todo
                  navigationData['forceReset'] = true;
                  navigationData['isNewForm'] = true;
                  print('RiskCategoriesScreen: Creando formulario nuevo - isCreatingNew: true');
                } else {
                  // Editar formulario existente - cargar datos guardados
                  navigationData['loadSavedForm'] = true;
                  navigationData['formId'] = currentHomeState.activeFormId;
                  print('RiskCategoriesScreen: Continuando formulario existente - isCreatingNew: false, formId: ${currentHomeState.activeFormId}');
                }
               
                
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
          );
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
                            classification.toLowerCase() == 'amenaza';
                        final isVulnerabilidad =
                            classification.toLowerCase() ==
                            'vulnerabilidad';

                        // Determinar si esta categoría está disponible
                        bool isAvailable = true;
                        bool isCompleted = false;
                        String? disabledMessage;

                        if (isAmenaza) {
                          // Amenaza siempre está disponible
                          isAvailable = true;
                          isCompleted = false; // No mostrar como completada hasta que esté al 100% real
                        } else if (isVulnerabilidad) {
                          // Vulnerabilidad siempre está disponible si hay un formulario activo
                          isAvailable = homeState.activeFormId != null;
                          if (!isAvailable) {
                            disabledMessage = 'No hay formulario activo';
                          }
                          isCompleted = false; // No mostrar como completada hasta que esté al 100% real
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
                              homeState.activeFormId,
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
