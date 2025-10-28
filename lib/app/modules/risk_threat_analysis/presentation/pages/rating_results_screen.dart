import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../widgets/widgets.dart';

class RatingResultsScreen extends StatelessWidget {
  const RatingResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 24),
              _buildAllSections(context, state),
              const SizedBox(height: 24),

              // Componente de Calificación dinámico
              _buildThreatRatingCard(context, state),

              const SizedBox(height: 14),

              // Barra de progreso dinámica
              const ProgressBarWidget(),

              const SizedBox(height: 40),

              // Botones de navegación
              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Usar la misma lógica que el RatingScreen - obtener subclasificaciones desde el BLoC
    final subClassifications = bloc.getCurrentSubClassifications();

    return Column(
      children: subClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassification = entry.value;
        
        // Construir items para esta subclasificación
        final items = _buildItemsForSubClassification(bloc, state, subClassification.id);
        final score = bloc.calculateSectionScore(subClassification.id);
        
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(
              title: subClassification.name,
              score: score,
              items: items,
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _buildItemsForSubClassification(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassificationId,
  ) {
    // Usar el método centralizado del BLoC para obtener items
    return bloc.getItemsForSubClassification(subClassificationId);
  }




  // Métodos eliminados - ahora se usan los métodos centralizados del BLoC
  // _getRatingFromSelection -> bloc.getRatingFromSelection
  // _getColorFromRating -> bloc.getColorFromRating  
  // _calculateSectionScore -> bloc.calculateSectionScore

  Widget _buildThreatRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final classificationType = (state.selectedClassification ?? '').toLowerCase();
    return ClassificationRatingCardWidget(classificationType: classificationType);
  }





}
