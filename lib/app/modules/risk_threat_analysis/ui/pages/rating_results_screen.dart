import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
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
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 24),
              _buildAllSections(),
              const SizedBox(height: 24),

              // Componente de Calificación de Amenaza
              const ThreatRatingCardWidget(
                score: '2,3',
                ratingText: 'MEDIO - BAJO',
              ),

              const SizedBox(height: 14),

              // Barra de progreso dinámica
              const ProgressBarWidget(),

              const SizedBox(height: 40),

              // Botones de navegación
              NavigationButtonsWidget(
                onContinuePressed: () {
                  // Acción para continuar
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }



  Widget _buildAllSections() {
    final sections = [
      {
        'title': 'Probabilidad',
        'score': '2,75',
        'items': [
          {'rating': 2, 'title': 'Características geotécnicas', 'color': Colors.yellow},
          {'rating': 2, 'title': 'Intervención Antrópica', 'color': Colors.yellow},
          {'rating': 3, 'title': 'Manejo de aguas lluvias', 'color': Colors.orange},
          {'rating': 4, 'title': 'Manejo de redes hidrosanitarias', 'color': Colors.red},
          {'rating': 0, 'title': 'Antecedentes - Sin calificar', 'color': const Color(0xFF9CA3AF)},
        ]
      },
      {
        'title': 'Intensidad',
        'score': '3,25',
        'items': [
          {'rating': 3, 'title': 'Ejemplo intensidad 1', 'color': Colors.orange},
          {'rating': 4, 'title': 'Ejemplo intensidad 2', 'color': Colors.red},
        ]
      },
    ];

    return Column(
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(
              title: section['title'] as String,
              score: section['score'] as String,
              items: section['items'] as List<Map<String, dynamic>>,
            ),
          ],
        );
      }).toList(),
    );
  }


}
