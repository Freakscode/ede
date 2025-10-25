import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/results_risk_section_widget.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  /// Calcula el progreso de una categoría basado en las selecciones
  double _calculateCategoryProgress(String classification, RiskThreatAnalysisState state) {
    if (classification.toLowerCase() == 'amenaza') {
      // Para amenaza: contar probabilidad + intensidad
      final probabilidadCount = state.probabilidadSelections.length;
      final intensidadCount = state.intensidadSelections.length;
      final totalExpected = 6; // 3 probabilidad + 3 intensidad
      return (probabilidadCount + intensidadCount) / totalExpected;
    } else if (classification.toLowerCase() == 'vulnerabilidad') {
      // Para vulnerabilidad: contar todas las subclasificaciones
      int totalSelections = 0;
      for (final subClassSelections in state.dynamicSelections.values) {
        totalSelections += subClassSelections.length;
      }
      final totalExpected = 8; // Ajustar según el número real de subclasificaciones
      return totalSelections / totalExpected;
    }
    
    return 0.0;
  }

  /// Determina si una categoría está disponible para ser seleccionada
  bool _isCategoryAvailable(String classification, RiskThreatAnalysisState state) {
    if (classification.toLowerCase() == 'amenaza') {
      // Amenaza siempre está disponible
      return true;
    } else if (classification.toLowerCase() == 'vulnerabilidad') {
      // Vulnerabilidad solo está disponible si amenaza está completa
      final amenazaProgress = _calculateCategoryProgress('amenaza', state);
      return amenazaProgress >= 1.0;
    }
    return false;
  }

  /// Construye el icono de estado para una categoría
  Widget? _buildStatusIcon(String classification, RiskThreatAnalysisState state) {
    final progress = _calculateCategoryProgress(classification, state);
    
    if (progress >= 1.0) {
      // Completada: mostrar check ✅
      return SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          AppIcons.checkCircle,
          width: 24,
          height: 24,
        ),
      );
    } else if (progress > 0.0) {
      // En proceso: mostrar borrador 📝
      return SizedBox(
        width: 18,
        height: 17,
        child: SvgPicture.asset(
          AppIcons.borrar,
          width: 18,
          height: 17,
          colorFilter: const ColorFilter.mode(
            DAGRDColors.azulSecundario, // Azul informativo
            BlendMode.srcIn,
          ),
        ),
      );
    }
    
    // Sin progreso: no mostrar icono
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, riskState) {
        final selectedEvent = riskState.selectedRiskEvent ?? '';

        // Clasificaciones fijas para el análisis de riesgo
        final classifications = ['Amenaza', 'Vulnerabilidad'];

        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Center(
                      child: Text(
                        'Metodología de Análisis del Riesgo',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: DAGRDColors.azulDAGRD, // AzulDAGRD
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
                          color: DAGRDColors.onSurfaceVariant, // GrisDAGRD
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          height: 28 / 18, // 155.556% line-height
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Generar CategoryCards dinámicamente basadas en las clasificaciones del modelo
                    ...classifications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final classification = entry.value;
                      
                      // Calcular estado de la categoría
                      final isAvailable = _isCategoryAvailable(classification, riskState);
                      final statusIcon = _buildStatusIcon(classification, riskState);

                      return Column(
                        children: [
                          Opacity(
                            opacity: isAvailable ? 1.0 : 0.6,
                            child: CategoryCard(
                              title: '$classification $selectedEvent',
                              trailingIcon: statusIcon,
                              onTap: isAvailable ? () {
                                // Configurar la clasificación seleccionada
                                final riskBloc = context.read<RiskThreatAnalysisBloc>();
                                riskBloc.add(SelectClassification(classification.toLowerCase()));
                                
                                // Navegar a RatingScreen (índice 1)
                                riskBloc.add(ChangeBottomNavIndex(1));
                              } : () {
                                // Mostrar mensaje si no está disponible
                                if (classification.toLowerCase() == 'vulnerabilidad') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Complete primero la evaluación de Amenaza'),
                                      backgroundColor: DAGRDColors.warning,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          // Agregar espaciado entre cards, excepto después del último
                          if (index < classifications.length - 1)
                            const SizedBox(height: 18),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    // Información con progreso
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: DAGRDColors.azulClaro,
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

                    // Resultados Riesgo - Widget original con HomeState
                    ResultsRiskSectionWidget(
                      homeState: homeState,
                      selectedEvent: selectedEvent,
                    ),

                    const SizedBox(height: 24),
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
