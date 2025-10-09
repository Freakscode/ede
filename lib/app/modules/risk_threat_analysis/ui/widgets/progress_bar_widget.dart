import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        // Calcular progreso basado en las selecciones realizadas
        final progress = _calculateProgress(context, state);
        
        // Texto dinámico según la clasificación
        final classificationName = state.selectedClassification == 'amenaza' 
          ? 'Amenaza' 
          : 'Vulnerabilidad';
        final progressText = '${(progress * 100).toInt()}% $classificationName completada';
        
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    // Color dinámico según la clasificación
                    DAGRDColors.amarDAGRD
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
    );
  }
  
  double _calculateProgress(BuildContext context, RiskThreatAnalysisState state) {
    print('DEBUG: _calculateProgress called with selectedClassification = ${state.selectedClassification}');
    
    // Para ambas clasificaciones (amenaza y vulnerabilidad): calcular basado en subclasificaciones
    if (state.selectedClassification == 'amenaza') {
      print('DEBUG: calculating amenaza progress');
      return _calculateAmenazaProgress(context, state);
    } else if (state.selectedClassification == 'vulnerabilidad') {
      print('DEBUG: calculating vulnerabilidad progress');
      return _calculateVulnerabilidadProgress(context, state);
    }
    
    print('DEBUG: no matching classification, returning 0.0');
    return 0.0;
  }
  
  double _calculateAmenazaProgress(BuildContext context, RiskThreatAnalysisState state) {
    print('=== AMENAZA PROGRESS CALCULATION ===');
    
    // Obtener todas las subclasificaciones de amenaza (probabilidad + intensidad)
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final amenazaSubClassifications = bloc.getAmenazaSubClassifications();
    
    print('DEBUG: amenazaSubClassifications.length = ${amenazaSubClassifications.length}');
    
    // Buscar las subclasificaciones de probabilidad e intensidad
    final probabilidadSubClassification = amenazaSubClassifications
        .where((sub) => sub.id == 'probabilidad')
        .firstOrNull;
    final intensidadSubClassification = amenazaSubClassifications
        .where((sub) => sub.id == 'intensidad')
        .firstOrNull;
    
    print('DEBUG: probabilidadSubClassification = $probabilidadSubClassification');
    print('DEBUG: intensidadSubClassification = $intensidadSubClassification');
    
    if (probabilidadSubClassification == null || intensidadSubClassification == null) {
      print('DEBUG: Missing subClassification');
      return 0.0;
    }
    
    // Obtener todas las categorías de probabilidad e intensidad
    final probabilidadCategories = probabilidadSubClassification.categories;
    final intensidadCategories = intensidadSubClassification.categories;
    final totalCategories = probabilidadCategories.length + intensidadCategories.length;
    final total = totalCategories.toDouble();
    
    print('DEBUG: probabilidadCategories.length = ${probabilidadCategories.length}');
    print('DEBUG: intensidadCategories.length = ${intensidadCategories.length}');
    print('DEBUG: total = $total');
    
    if (total == 0) {
      print('DEBUG: total is 0');
      return 0.0;
    }
    
    // Contar cuántas categorías tienen selecciones
    double completed = 0.0;
    print('DEBUG: About to check selections...');
    print('DEBUG: probabilidadSelections = ${state.probabilidadSelections}');
    print('DEBUG: intensidadSelections = ${state.intensidadSelections}');
    
    // Verificar categorías de probabilidad
    print('DEBUG: Checking PROBABILIDAD categories:');
    for (final category in probabilidadCategories) {
      print('DEBUG: - ${category.title}');
      final hasSelection = state.probabilidadSelections.containsKey(category.title);
      print('DEBUG: category ${category.title} hasSelection = $hasSelection');
      if (hasSelection) {
        completed += 1;
      }
    }
    
    // Verificar categorías de intensidad
    print('DEBUG: Checking INTENSIDAD categories:');
    for (final category in intensidadCategories) {
      print('DEBUG: - ${category.title}');
      final hasSelection = state.intensidadSelections.containsKey(category.title);
      print('DEBUG: category ${category.title} hasSelection = $hasSelection');
      if (hasSelection) {
        completed += 1;
      }
    }
    
    final progress = completed / total;
    print('DEBUG: completed = $completed, total = $total, progress = $progress');
    print('=== END AMENAZA PROGRESS CALCULATION ===');
    return progress;
  }
  
  double _calculateVulnerabilidadProgress(BuildContext context, RiskThreatAnalysisState state) {
    print('=== VULNERABILIDAD PROGRESS CALCULATION ===');
    
    // Obtener todas las subclasificaciones de vulnerabilidad dinámicamente
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final vulnerabilidadSubClassifications = bloc.getVulnerabilidadSubClassifications();
    
    print('DEBUG: vulnerabilidadSubClassifications.length = ${vulnerabilidadSubClassifications.length}');
    
    // Obtener todas las categorías de vulnerabilidad de todas las subclasificaciones
    final expectedCategories = <RiskCategory>[];
    for (final subClassification in vulnerabilidadSubClassifications) {
      print('DEBUG: SubClassification ${subClassification.id}: ${subClassification.categories.length} categories');
      expectedCategories.addAll(subClassification.categories);
    }
    
    final total = expectedCategories.length.toDouble();
    print('DEBUG: total categories = $total');
    
    if (total == 0) {
      print('DEBUG: total is 0');
      return 0.0;
    }
    
    // Contar cuántas categorías tienen selecciones en dynamicSelections
    double completed = 0.0;
    print('DEBUG: Checking dynamicSelections:');
    print('DEBUG: dynamicSelections = ${state.dynamicSelections}');
    
    for (final category in expectedCategories) {
      print('DEBUG: checking category ${category.id} (title: ${category.title})');
      
      // Verificar si esta categoría tiene una selección en dynamicSelections
      // Buscar en todas las subclasificaciones dinámicas
      bool hasSelection = false;
      for (final subClassId in state.dynamicSelections.keys) {
        final subClassSelections = state.dynamicSelections[subClassId];
        if (subClassSelections != null && subClassSelections.containsKey(category.title)) {
          hasSelection = true;
          break;
        }
      }
      
      print('DEBUG: category ${category.title} hasSelection = $hasSelection');
      if (hasSelection) {
        completed += 1;
      }
    }
    
    final progress = completed / total;
    print('DEBUG: completed = $completed, total = $total, progress = $progress');
    print('=== END VULNERABILIDAD PROGRESS CALCULATION ===');
    return progress;
  }
}