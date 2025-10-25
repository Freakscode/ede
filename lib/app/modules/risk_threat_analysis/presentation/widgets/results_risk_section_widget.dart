import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
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
        // Estado deshabilitado (gris) - botón no clickeable
        return GestureDetector(
          onTap: null, // Deshabilitado
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: DAGRDColors.outline, // Gris cuando está deshabilitado
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(9.882),
                  decoration: BoxDecoration(
                    color: DAGRDColors.outlineVariant, // Gris cuando está deshabilitado
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.warning,
                    width: 24.707,
                    height: 22.059,
                    colorFilter: ColorFilter.mode(
                      DAGRDColors.onSurfaceVariant, // Gris oscuro cuando está deshabilitado
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
                        style: TextStyle(
                          color: DAGRDColors.onSurfaceVariant, // Gris cuando está deshabilitado
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
                        style: TextStyle(
                          color: DAGRDColors.onSurfaceVariant, // Gris cuando está deshabilitado
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