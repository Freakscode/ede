import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';

class ResultsRiskSectionWidget extends StatelessWidget {
  final HomeState homeState;
  final String selectedEvent;

  const ResultsRiskSectionWidget({
    super.key,
    required this.homeState,
    required this.selectedEvent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        return GestureDetector(
          onTap: () {
            // Navegar a la pantalla de análisis de riesgo con navigationData
            final navigationData = {
              'event': selectedEvent,
              'finalResults': true,
              'targetIndex': 3,
            };
            context.go('/risk_threat_analysis', extra: navigationData);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCC00), // Amarillo claro cuando está habilitado
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFCC00), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(9.882),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232B48), // AzulDAGRD cuando está habilitado
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.warning,
                    width: 24.707,
                    height: 22.059,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFFCC00), // Amarillo cuando está habilitado
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Resultados Riesgo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E), // Negro cuando está habilitado
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          height: 24 / 18,
                        ),
                      ),
                      Text(
                        selectedEvent,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1E1E1E), // Negro cuando está habilitado
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          height: 24 / 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}