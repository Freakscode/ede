import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/category_card.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RiskCategoriesScreen extends StatelessWidget {
  const RiskCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final selectedEvent = state.selectedRiskEvent;
        
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
                  // Amenaza - dinámico basado en selección
                  CategoryCard(
                    title: 'Amenaza $selectedEvent',
                    onTap: () {
                      // Guardar la categoría seleccionada
                      context.read<HomeBloc>().add(
                        SelectRiskCategory('Amenaza', selectedEvent),
                      );
                      // Navegar a siguiente pantalla
                      context.go('/risk_threat_analysis');
                    },
                  ),
                  const SizedBox(height: 18),

                  // Vulnerabilidad - dinámico basado en selección
                  CategoryCard(
                    title: 'Vulnerabilidad $selectedEvent',
                    onTap: () {
                      // Guardar la categoría seleccionada
                      context.read<HomeBloc>().add(
                        SelectRiskCategory('Vulnerabilidad', selectedEvent),
                      );
                      // Navegar a siguiente pantalla
                      context.go('/risk_threat_analysis');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Información
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 8),
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
            if (state.selectedRiskCategory != null)
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
                        state.selectedRiskCategory!,
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
  }
}
