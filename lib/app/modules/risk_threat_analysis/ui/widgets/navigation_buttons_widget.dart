import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import 'home_navigation_type.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onBackPressed;
  final VoidCallback? onContinuePressed;
  final HomeNavigationType homeNavigationType;
  final int? homeTabIndex;

  const NavigationButtonsWidget({
    super.key,
    required this.currentIndex,
    this.onBackPressed,
    this.onContinuePressed,
    this.homeNavigationType = HomeNavigationType.riskCategories,
    this.homeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Volver
        InkWell(
          onTap: onBackPressed ?? () {
            if (currentIndex > 0) {
              context.read<RiskThreatAnalysisBloc>().add(
                ChangeBottomNavIndex(currentIndex - 1),
              );
            } else {
              // Cuando estamos en el primer índice, volver al HomeScreen
              final navigationData = homeNavigationType.toNavigationData(tabIndex: homeTabIndex);
              context.go('/home', extra: navigationData);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: DAGRDColors.negroDAGRD,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Volver',
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 18 / 16,
                ),
              ),
            ],
          ),
        ),
        
        // Botón Continuar o Finalizar
        if (currentIndex < 2) // Botón Continuar para las primeras dos pestañas
          InkWell(
            onTap: onContinuePressed ?? () {
              context.read<RiskThreatAnalysisBloc>().add(
                ChangeBottomNavIndex(currentIndex + 1),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Continuar',
                  style: TextStyle(
                    color: DAGRDColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 18 / 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: DAGRDColors.negroDAGRD,
                  size: 18,
                ),
              ],
            ),
          )
        else // Botón Finalizar para la última pestaña
          BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
            builder: (context, state) {
              return InkWell(
                onTap: onContinuePressed ?? () {
                  // Si estamos en amenaza, volver a RiskCategoriesScreen para continuar con vulnerabilidad
                  if (state.selectedClassification.toLowerCase() == 'amenaza') {
                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('¡Amenaza completada! Ahora puede continuar con Vulnerabilidad.'),
                        backgroundColor: DAGRDColors.success,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    
                    // Navegar de vuelta a RiskCategoriesScreen
                    context.go('/risk_categories');
                  } else {
                    // Si estamos en vulnerabilidad, ir al home como antes
                    final navigationData = homeNavigationType.toNavigationData(tabIndex: homeTabIndex);
                    context.go('/home', extra: navigationData);
                  }
                },
                child: Container(
              width: 185,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF232B48),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFFFFFFF),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Finalizar formulario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 24 / 14,
                    ),
                  ),
                ],
              ),
            ),
              );
            },
          ),
      ],
    );
  }
}