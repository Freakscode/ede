import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';

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
              _buildThreatRatingCard(),

              const SizedBox(height: 14),

              // Barra de progreso dinámica
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  final progress = bloc.calculateCompletionPercentage();
                  final progressText =
                      '${(progress * 100).toInt()}% completado';

                  return Column(
                    children: [
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFCC00),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        progressText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: DAGRDColors.grisMedio,
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Volver
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
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
                            color: DAGRDColors.negroDAGRD, // #000
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 18 / 16, // line-height: 112.5%
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón Continuar
                  InkWell(
                    onTap: () {
                      // Acción para continuar
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Continuar',
                          style: TextStyle(
                            color: DAGRDColors.negroDAGRD, // #000
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 18 / 16, // line-height: 112.5%
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
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThreatRatingCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF232B48),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: Text(
                'Calificación Amenaza',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 16 / 16,
                ),
              ),
            ),
          ),
          // Contenido amarillo
          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.fromLTRB(50, 10, 40, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFDE047),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border(
                left: BorderSide(color: Color(0xFFD1D5DB), width: 1),
                right: BorderSide(color: Color(0xFFD1D5DB), width: 1),
                bottom: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '2,3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 16 / 16,
                  ),
                ),
                const SizedBox(width: 33),
                const Text(
                  'MEDIO - BAJO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 16 / 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllSections() {
    final sections = [
      {
        'title': 'Probabilidad',
        'score': '2,75',
        'items': [
          {
            'rating': 2,
            'title': 'Características geotécnicas',
            'color': Colors.yellow,
          },
          {
            'rating': 2,
            'title': 'Intervención Antrópica',
            'color': Colors.yellow,
          },
          {
            'rating': 3,
            'title': 'Manejo de aguas lluvias',
            'color': Colors.orange,
          },
          {
            'rating': 4,
            'title': 'Manejo de redes hidrosanitarias',
            'color': Colors.red,
          },
          {
            'rating': 0,
            'title': 'Antecedentes - Sin calificar',
            'color': const Color(0xFF9CA3AF),
          },
        ],
      },
      // Puedes agregar más secciones aquí como Intensidad, etc.
      {
        'title': 'Intensidad',
        'score': '3,25',
        'items': [
          {
            'rating': 3,
            'title': 'Ejemplo intensidad 1',
            'color': Colors.orange,
          },
          {'rating': 4, 'title': 'Ejemplo intensidad 2', 'color': Colors.red},
        ],
      },
    ];

    return Column(
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        return Column(
          children: [
            if (index > 0)
              const SizedBox(height: 24), // Espaciado entre secciones
            _buildSection(
              section['title'] as String,
              section['score'] as String,
              section['items'] as List<Map<String, dynamic>>,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSection(
    String title,
    String score,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFF232B48),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 16 / 16,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      score,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border(
              left: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              right: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              bottom: BorderSide(color: Color(0xFFD1D5DB), width: 1),
            ),
          ),
          child: Column(
            children: items
                .map(
                  (item) => _buildRatingItem(
                    item['rating'] as int,
                    item['title'] as String,
                    item['color'] as Color,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingItem(int rating, String title, Color color) {
    final isUnrated = rating == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUnrated ? const Color(0xFFF3F4F6) : Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                rating.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnrated
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF000000),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 16 / 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (!isUnrated) ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontFamily: 'Work Sans',
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 20 / 15,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ] else ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
