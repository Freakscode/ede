import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RiskCategoriesScreen extends StatefulWidget {
  const RiskCategoriesScreen({super.key});

  @override
  State<RiskCategoriesScreen> createState() => _RiskCategoriesScreenState();
}

class _RiskCategoriesScreenState extends State<RiskCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, riskState) {
        final selectedEvent = riskState.selectedRiskEvent ?? '';

        // Clasificaciones fijas para el análisis de riesgo
        final classifications = ['Amenaza', 'Vulnerabilidad'];

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
                // Generar CategoryCards dinámicamente basadas en las clasificaciones del modelo
                ...classifications.asMap().entries.map((entry) {
                  final index = entry.key;
                  final classification = entry.value;

                  // Todas las categorías están disponibles
                  bool isAvailable = true;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Opacity(
                          opacity: isAvailable ? 1.0 : 0.6,
                          child: CategoryCard(
                            title: '$classification $selectedEvent',
                            onTap: () {
                              // Navegar a RatingScreen (índice 1)
                              final riskBloc = context
                                  .read<RiskThreatAnalysisBloc>();
                              riskBloc.add(ChangeBottomNavIndex(1));
                            },
                          ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
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
                ),

                const SizedBox(height: 24),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
