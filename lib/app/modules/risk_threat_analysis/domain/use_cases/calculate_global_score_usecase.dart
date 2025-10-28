import 'package:flutter/material.dart';
import 'calculate_score_usecase.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';

/// Caso de uso para calcular scores globales de amenaza y vulnerabilidad
/// Encapsula la lógica de negocio para cálculos de puntuación global
class CalculateGlobalScoreUseCase {
  final CalculateScoreUseCase _calculateScoreUseCase;

  const CalculateGlobalScoreUseCase(
    this._calculateScoreUseCase,
  );

  /// Ejecutar el caso de uso para calcular score global de amenaza
  double calculateAmenazaGlobalScore(Map<String, dynamic> formData) {
    try {
      // Obtener el nombre del evento
      final eventName = formData['selectedRiskEvent']?.toString() ?? '';
      
      // Buscar en amenaza probabilidad
      final probabilidadSelections = Map<String, dynamic>.from(
        formData['amenazaProbabilidadSelections'] ?? {}
      );
      
      // Buscar en amenaza intensidad
      final intensidadSelections = Map<String, dynamic>.from(
        formData['amenazaIntensidadSelections'] ?? {}
      );
      
      double probabilidadScore = 0.0;
      double intensidadScore = 0.0;
      
      // Calcular score de probabilidad si hay datos
      if (probabilidadSelections.isNotEmpty) {
        probabilidadScore = _calculateAverageFromSelections(probabilidadSelections, eventName);
      }
      
      // Calcular score de intensidad si hay datos
      if (intensidadSelections.isNotEmpty) {
        intensidadScore = _calculateAverageFromSelections(intensidadSelections, eventName);
      }
      
      // Si ambos son 0, no hay calificaciones
      if (probabilidadScore == 0.0 && intensidadScore == 0.0) {
        return 0.0;
      }
      
      // Calcular score global (promedio ponderado)
      // Probabilidad tiene peso 0.4, Intensidad tiene peso 0.6
      final globalScore = (probabilidadScore * 0.4) + (intensidadScore * 0.6);
      
      return globalScore;
    } catch (e) {
      print('Error in calculateAmenazaGlobalScore: $e');
      return 0.0;
    }
  }

  /// Ejecutar el caso de uso para calcular score global de vulnerabilidad
  double calculateVulnerabilidadGlobalScore(Map<String, dynamic> formData) {
    try {
      
      final vulnerabilidadSelections = Map<String, dynamic>.from(
        formData['vulnerabilidadSelections'] ?? {}
      );

      if (vulnerabilidadSelections.isEmpty) {
        return 0.0;
      }

      // Pesos según Excel: FRAGILIDAD FÍSICA: 45%, FRAGILIDAD EN PERSONAS: 10%, EXPOSICIÓN: 45%
      final Map<String, double> pesos = {
        'fragilidad_fisica': 0.45,
        'fragilidad_personas': 0.10,
        'exposicion': 0.45,
      };

      double weightedSum = 0.0;

      // Calcular score ponderado para cada subclasificación de vulnerabilidad
      for (final subClassificationId in vulnerabilidadSelections.keys) {
        final score = _calculateScoreUseCase.execute(subClassificationId, formData);
        final peso = pesos[subClassificationId] ?? 0.0;
        
        if (score > 0 && peso > 0) {
          weightedSum += (score * peso);
        }
      }

      // Los pesos ya suman 1.0, así que no necesitamos dividir
      return weightedSum;
    } catch (e) {
      print('Error in calculateVulnerabilidadGlobalScore: $e');
      return 0.0;
    }
  }

  /// Calcular score final de riesgo
  double calculateFinalRiskScore(Map<String, dynamic> formData) {
    try {
      final amenazaScore = calculateAmenazaGlobalScore(formData);
      final vulnerabilidadScore = calculateVulnerabilidadGlobalScore(formData);
      
      // Score final es el producto de amenaza y vulnerabilidad
      final finalScore = amenazaScore * vulnerabilidadScore;
      
      return finalScore;
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtener color basado en score global
  Color getGlobalScoreColor(double score) {
    if (score <= 1.5) return Colors.green;
    if (score <= 2.5) return Colors.yellow;
    if (score <= 3.5) return Colors.orange;
    if (score <= 4.5) return Colors.red;
    return Colors.deepPurple;
  }

  /// Obtener nivel de riesgo basado en score global (usando las reglas originales)
  String getGlobalRiskLevel(double score) {
    if (score >= 1.0 && score <= 1.75) {
      return 'BAJO';
    } else if (score > 1.75 && score <= 2.5) {
      return 'MEDIO - BAJO';
    } else if (score > 2.5 && score <= 3.25) {
      return 'MEDIO - ALTO';
    } else if (score > 3.25 && score <= 4.0) {
      return 'ALTO';
    } else {
      return 'SIN CALIFICAR';
    }
  }

  /// Calcular promedio ponderado de selecciones usando pesos (wi)
  double _calculateAverageFromSelections(Map<String, dynamic> selections, String eventName) {
    if (selections.isEmpty) return 0.0;
    
    // Obtener los pesos y un mapeo de títulos a IDs
    final riskEvent = RiskEventFactory.getEventByName(eventName);
    final weights = _getAllCategoryWeights(eventName);
    final titleToIdMap = _createTitleToIdMap(riskEvent);
    
    double totalPonderado = 0.0;
    double totalPeso = 0.0;
    
    // Iterar sobre cada categoría seleccionada
    for (final entry in selections.entries) {
      final categoryTitle = entry.key;
      final value = entry.value;
      
      if (value is String && value != 'No Aplica' && value != 'NA' && value.isNotEmpty) {
        // Convertir título a ID para buscar el peso
        // Normalizar el título para eliminar diferencias de formato
        final normalizedTitle = categoryTitle.replaceAll('\n', ' ').trim();
        final categoryId = titleToIdMap[normalizedTitle] ?? titleToIdMap[categoryTitle] ?? categoryTitle;
        final score = _levelToScore(value);
        
        // Obtener el peso (wi) de la categoría usando el ID
        final weight = weights[categoryId] ?? 1.0;
        
        if (score > 0 && weight > 0) {
          totalPonderado += (score * weight);
          totalPeso += weight;
        }
      }
    }
    
    return totalPeso > 0 ? totalPonderado / totalPeso : 0.0;
  }
  
  /// Crear mapeo de títulos a IDs de categorías
  Map<String, String> _createTitleToIdMap(RiskEventModel? riskEvent) {
    final titleToId = <String, String>{};
    
    if (riskEvent == null) return titleToId;
    
    for (final classification in riskEvent.classifications) {
      for (final subClassification in classification.subClassifications) {
        for (final category in subClassification.categories) {
          // Normalizar el título (sin saltos de línea) como clave
          final normalizedTitle = category.title.replaceAll('\n', ' ').trim();
          titleToId[normalizedTitle] = category.id;
          
          // También agregar el título original con saltos de línea por si acaso
          titleToId[category.title] = category.id;
        }
      }
    }
    
    return titleToId;
  }
  
  /// Obtener TODOS los pesos (wi) de las categorías para un evento específico
  Map<String, double> _getAllCategoryWeights(String eventName) {
    // Obtener el evento desde RiskEventFactory
    final riskEvent = RiskEventFactory.getEventByName(eventName);
    
    if (riskEvent == null) {
      return <String, double>{};
    }
    
    final weights = <String, double>{};
    
    // Iterar sobre todas las clasificaciones del evento
    for (final classification in riskEvent.classifications) {
      // Iterar sobre todas las subclasificaciones
      for (final subClassification in classification.subClassifications) {
        // Iterar sobre todas las categorías
        for (final category in subClassification.categories) {
          weights[category.id] = category.wi.toDouble();
        }
      }
    }
    
    return weights;
  }
  
  /// Convertir nivel de texto a score numérico
  /// Valores según Excel: BAJO=1, MEDIO-BAJO=2, MEDIO-ALTO=3, ALTO=4
  double _levelToScore(String level) {
    // Normalizar el nivel: quitar saltos de línea, espacios extra, guiones
    final normalized = level.replaceAll('\n', ' ').trim().toLowerCase().replaceAll('-', ' ');
    
    if (normalized.contains('muy bajo')) {
      return 1.0;
    } else if (normalized.contains('medio alto') || normalized.contains('medio-alto')) {
      return 3.0;
    } else if (normalized.contains('medio bajo') || normalized.contains('medio-bajo') || 
               (normalized.contains('medio') && normalized.contains('bajo'))) {
      return 2.0;
    } else if (normalized.contains('medio') && !normalized.contains('alto') && !normalized.contains('bajo')) {
      return 2.0;
    } else if (normalized.contains('bajo') && !normalized.contains('alto')) {
      return 1.0;
    } else if (normalized.contains('alto') && !normalized.contains('muy')) {
      return 4.0;
    } else if (normalized.contains('muy alto') || normalized.contains('muy-alto')) {
      return 5.0;
    }
    
    return 0.0;
  }

  /// Obtener información completa del score global
  Map<String, dynamic> getGlobalScoreInfo(Map<String, dynamic> formData) {
    try {
      
      final amenazaScore = calculateAmenazaGlobalScore(formData);
      final vulnerabilidadScore = calculateVulnerabilidadGlobalScore(formData);
      final finalScore = calculateFinalRiskScore(formData);


      final result = {
        'amenazaScore': amenazaScore,
        'vulnerabilidadScore': vulnerabilidadScore,
        'finalScore': finalScore,
        'amenazaColor': getGlobalScoreColor(amenazaScore),
        'vulnerabilidadColor': getGlobalScoreColor(vulnerabilidadScore),
        'finalColor': getGlobalScoreColor(finalScore),
        'amenazaLevel': getGlobalRiskLevel(amenazaScore),
        'vulnerabilidadLevel': getGlobalRiskLevel(vulnerabilidadScore),
        'finalLevel': getGlobalRiskLevel(finalScore),
      };
      
      
      return result;
    } catch (e) {
      print('Error in getGlobalScoreInfo: $e');
      return {
        'amenazaScore': 0.0,
        'vulnerabilidadScore': 0.0,
        'finalScore': 0.0,
        'amenazaColor': Colors.grey,
        'vulnerabilidadColor': Colors.grey,
        'finalColor': Colors.grey,
        'amenazaLevel': 'N/A',
        'vulnerabilidadLevel': 'N/A',
        'finalLevel': 'N/A',
      };
    }
  }
}

