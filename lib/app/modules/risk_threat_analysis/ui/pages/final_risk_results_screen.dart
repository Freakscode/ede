import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../../../home/bloc/home_bloc.dart';
import '../../../home/bloc/home_event.dart';
import '../widgets/risk_matrix_widget.dart';

class FinalRiskResultsScreen extends StatelessWidget {
  final String eventName;

  const FinalRiskResultsScreen({
    super.key,
    this.eventName = 'Evento de Prueba', // Valor por defecto para desarrollo
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
              child: Column(
                children: [
                  // Título principal
                  Text(
                    'Metodología de Análisis del Riesgo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF232B48),
                      fontFamily: 'Work Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 28 / 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtítulo
                  Text(
                    'Resultados Finales del Riesgo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 22 / 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Matriz de riesgo
                  RiskMatrixWidget(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
