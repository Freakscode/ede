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
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        onBack: () => context.pop(),
        showInfo: true,
        showProfile: true,
      ),
      body: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
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
                
                // Dropdown de escala de afectación
                _buildScaleDropdown(),
                
                const SizedBox(height: 24),
                
                // Sección de Calificación Vulnerabilidad
                _buildVulnerabilitySection(state),
                
                const SizedBox(height: 16),
                
                // Botón "Ir a Análisis de la Vulnerabilidad"
                _buildVulnerabilityButton(context),
                
                const SizedBox(height: 24),
                
                // Sección de Nivel de Riesgo
                _buildRiskLevelSection(state),
                
                const SizedBox(height: 24),
                
                // Escala de colores
                _buildColorScale(),
                
                const SizedBox(height: 24),
                
                // Matriz de riesgo
                RiskMatrixWidget(state: state),
                
                const SizedBox(height: 40),
                
                // Botones inferiores
                _buildBottomButtons(context),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScaleDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF97316),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Escala de afectación',
              style: TextStyle(
                color: Color(0xFF374151),
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildVulnerabilitySection(RiskThreatAnalysisState state) {
    // Obtener el score de vulnerabilidad desde el state
    double vulnerabilityScore = _getVulnerabilityScore(state);
    String vulnerabilityLevel = _getRiskLevel(vulnerabilityScore);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4A5F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              'Calificación Vulnerabilidad',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Text(
                  vulnerabilityScore.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  vulnerabilityLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVulnerabilityButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navegar de vuelta a la vulnerabilidad
        final navigationData = {
          'event': eventName,
          'classification': 'vulnerabilidad',
          'directToResults': false,
        };
        context.go('/risk_threat_analysis', extra: navigationData);
      },
      child: Row(
        children: [
          const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2563EB),
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Ir a Análisis de la Vulnerabilidad',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontFamily: 'Work Sans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevelSection(RiskThreatAnalysisState state) {
    // Calcular el nivel de riesgo final
    double amenazaScore = _getAmenazaScore(state);
    double vulnerabilityScore = _getVulnerabilityScore(state);
    double finalRiskScore = amenazaScore * vulnerabilityScore;
    String riskLevel = _getRiskLevel(finalRiskScore);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF3F4A5F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              'Nivel de Riesgo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Text(
                  finalRiskScore.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  riskLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorScale() {
    return Row(
      children: [
        _buildColorBlock('BAJO', const Color(0xFF10B981)),
        const SizedBox(width: 8),
        _buildColorBlock('MEDIO\nBAJO', const Color(0xFFF59E0B)),
        const SizedBox(width: 8),
        _buildColorBlock('MEDIO\nALTO', const Color(0xFFF97316)),
        const SizedBox(width: 8),
        _buildColorBlock('ALTO', const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _buildColorBlock(String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }



  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        // Botón Atrás
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            label: const Text('Atrás'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Botón Finalizar análisis
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _finalizarAnalisis(context),
            icon: const Icon(Icons.check_circle, size: 20),
            label: const Text('Finalizar análisis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _finalizarAnalisis(BuildContext context) {
    // Marcar como completado en HomeBloc
    context.read<HomeBloc>().add(
      MarkEvaluationCompleted(eventName, 'complete')
    );
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Análisis de riesgo completado exitosamente!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    
    // Navegar de vuelta al home
    context.go('/home');
  }

  // Métodos auxiliares para obtener los scores
  double _getAmenazaScore(RiskThreatAnalysisState state) {
    // Buscar scores de amenaza en subClassificationScores
    double totalScore = 0.0;
    int count = 0;
    
    // Buscar subclasificaciones de amenaza
    final amenazaKeys = state.subClassificationScores.keys
        .where((key) => key.contains('amenaza') || key.contains('probabilidad') || key.contains('intensidad'));
    
    for (final key in amenazaKeys) {
      final score = state.subClassificationScores[key];
      if (score != null && score > 0) {
        totalScore += score;
        count++;
      }
    }
    
    // Si no hay scores guardados, usar valores por defecto basados en las selections
    if (count == 0) {
      // Intentar obtener de las selecciones de probabilidad e intensidad
      if (state.selectedProbabilidad != null && state.selectedIntensidad != null) {
        final probValue = _convertSelectionToValue(state.selectedProbabilidad!);
        final intValue = _convertSelectionToValue(state.selectedIntensidad!);
        return (probValue + intValue) / 2.0;
      }
      return 2.75; // Fallback
    }
    
    return totalScore / count;
  }

  double _getVulnerabilityScore(RiskThreatAnalysisState state) {
    // Buscar scores de vulnerabilidad en subClassificationScores
    double totalScore = 0.0;
    int count = 0;
    
    // Buscar subclasificaciones de vulnerabilidad
    final vulnerabilityKeys = state.subClassificationScores.keys
        .where((key) => key.contains('vulnerabilidad') || key.contains('fragilidad') || key.contains('exposicion'));
    
    for (final key in vulnerabilityKeys) {
      final score = state.subClassificationScores[key];
      if (score != null && score > 0) {
        totalScore += score;
        count++;
      }
    }
    
    // Si no hay scores guardados, calcular desde dynamicSelections
    if (count == 0) {
      final vulnerabilitySelections = state.dynamicSelections['vulnerabilidad'];
      if (vulnerabilitySelections != null && vulnerabilitySelections.isNotEmpty) {
        double sum = 0.0;
        int selectionCount = 0;
        
        for (final selection in vulnerabilitySelections.values) {
          final value = _convertSelectionToValue(selection);
          if (value > 0) {
            sum += value;
            selectionCount++;
          }
        }
        
        if (selectionCount > 0) {
          return sum / selectionCount;
        }
      }
      return 2.33; // Fallback
    }
    
    return totalScore / count;
  }

  double _convertSelectionToValue(String selection) {
    // Convertir selecciones de texto a valores numéricos
    switch (selection.toLowerCase()) {
      case 'bajo':
        return 1.0;
      case 'medio bajo':
      case 'medio-bajo':
        return 2.0;
      case 'medio alto':
      case 'medio-alto':
        return 3.0;
      case 'alto':
        return 4.0;
      default:
        // Si es un número, intentar parsearlo
        final parsed = double.tryParse(selection);
        return parsed ?? 0.0;
    }
  }

  String _getRiskLevel(double score) {
    if (score < 1.5) return 'BAJO';
    if (score < 2.5) return 'MEDIO - BAJO';
    if (score < 3.5) return 'MEDIO - ALTO';
    return 'ALTO';
  }
}