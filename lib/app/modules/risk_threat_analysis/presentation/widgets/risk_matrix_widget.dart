import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import '../bloc/risk_threat_analysis_state.dart';

class RiskMatrixWidget extends StatelessWidget {
  final RiskThreatAnalysisState state;

  const RiskMatrixWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener las coordenadas del punto en la matriz
    double amenazaScore = _getAmenazaScore(state);
    double vulnerabilityScore = _getVulnerabilityScore(state);
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Leyenda de colores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('BAJO', ThemeColors.nivelBajo),
              _buildLegendItem('MEDIO\nBAJO', ThemeColors.nivelMedioBajo),
              _buildLegendItem('MEDIO\nALTO', ThemeColors.nivelMedioAlto),
              _buildLegendItem('ALTO', ThemeColors.nivelAlto),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de colores superior
          Container(
            height: 4,
            decoration: const BoxDecoration(
             
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          
          // Contenedor principal del heatmap
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Fila con label "Amenaza" y el heatmap
                Row(
                  children: [
                    // Label "Amenaza" en el eje Y
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Amenaza',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ThemeColors.negroDAGRD,
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 16/14, // 114.286% line height
                          ),
                        ),
                      ),
                    ),
                    
                    // Área del heatmap con gradiente
                    Expanded(
                      child: Container(
                        height: 200,
                        
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Gradiente de fondo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomPaint(
                                    size: Size.infinite,
                                    painter: HeatmapPainter(),
                                  ),
                                ),
                                
                                // Punto de datos
                                Positioned(
                                  left: (vulnerabilityScore / 4.0) * (constraints.maxWidth - 20) + 10,
                                  top: 200 - (amenazaScore / 4.0) * 180 - 10,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Label "Vulnerabilidad"
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Vulnerabilidad',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ThemeColors.negroDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 16/14, // 114.286% line height
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildLegendItem(String text, Color color) {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeColors.negroDAGRD, // Textos
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16/12, // 133.333% line height
          ),
        ),
      ),
    );
  }
}

class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    
    // Verde - esquina inferior izquierda
    final pathVerde = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.286) // 80/280
      ..cubicTo(
        w * 0.133, h * 0.571, // 80, 160
        w * 0.3, h * 0.857, // 180, 240
        w * 0.6, h, // 360, 280
      )
      ..close();
    
    canvas.drawPath(pathVerde, Paint()..color = ThemeColors.nivelBajo);
    
    // Amarillo - banda central amplia
    final pathAmarillo = Path()
      ..moveTo(0, h * 0.286) // 0, 80
      ..cubicTo(
        w * 0.133, h * 0.571, // 80, 160
        w * 0.3, h * 0.857, // 180, 240
        w * 0.6, h, // 360, 280
      )
      ..lineTo(w, h) // 600, 280 - ir a esquina inferior derecha
      ..lineTo(w, 150) // 600, 150 - subir hasta línea naranja
      ..cubicTo(
        w * 0.45, h * 0.6, // 270, 170 - movido más a la izquierda
        w * 0.25, h * 0.3, // 150, 85 - movido más a la izquierda
        w * 0.2, 0, // 120, 0 - movido más a la izquierda
      )
      ..lineTo(0, 0)
      ..close();
    
    canvas.drawPath(pathAmarillo, Paint()..color = ThemeColors.nivelMedioBajo);
    
    // Naranja - banda superior
    final pathNaranja = Path()
      ..moveTo(w * 0.2, 0) // 120, 0 - ajustado al nuevo límite amarillo
      ..cubicTo(
        w * 0.25, h * 0.3, // 150, 85 - ajustado al nuevo límite amarillo
        w * 0.45, h * 0.6, // 270, 170 - ajustado al nuevo límite amarillo
        w, 150, // 600, 280
      )
      ..lineTo(w, h * 0.4) // 600, 113 - bajado para expandir área naranja
      ..cubicTo(
        w * 0.75, h * 0.35, // 450, 98 - curva convexa hacia afuera
        w * 0.65, h * 0.15, // 390, 42 - curva convexa hacia afuera
        w * 0.55, 0, // 330, 0 - expandido hacia la izquierda
      )
      ..close();
    
    canvas.drawPath(pathNaranja, Paint()..color = ThemeColors.nivelMedioAlto);
    
    // Rojo - esquina superior derecha
    final pathRojo = Path()
      ..moveTo(w * 0.55, 0) // 330, 0 - ajustado al nuevo límite naranja
      ..cubicTo(
        w * 0.65, h * 0.15, // 390, 42 - curva convexa hacia afuera (coincide con naranja)
        w * 0.75, h * 0.35, // 450, 98 - curva convexa hacia afuera (coincide con naranja)
        w, h * 0.4, // 600, 113 - ajustado al nuevo límite naranja
      )
      ..lineTo(w, 0)
      ..close();
    
    canvas.drawPath(pathRojo, Paint()..color = ThemeColors.nivelAlto);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}