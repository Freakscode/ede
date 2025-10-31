import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/dagrd_colors.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';

class ThreatLevelsDialog extends StatelessWidget {
  const ThreatLevelsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ThreatLevelsDialog(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 360,
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
          bottom: 20,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header fijo
            BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
              builder: (context, state) {
                final title = (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza'
                    ? 'Niveles de Amenaza'
                    : 'Niveles de Vulnerabilidad';
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ThemeColors.negroDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: ThemeColors.negroDAGRD,
                        size: 24,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 14),
            
            // Contenido con scroll
            Flexible(
              child: SingleChildScrollView(
                child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                  builder: (context, state) {
                    final levels = (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza'
                        ? _getThreatLevels()
                        : _getVulnerabilityLevels();
                    
                    return _buildLevelsPanel(
                      title: '',
                      levels: levels,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsPanel({
    required String title,
    required List<LevelInfo> levels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del panel (solo si no está vacío)
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              color: ThemeColors.negroDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Lista de niveles
        Column(
          children: levels.map((level) {
            
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: level.backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: ThemeColors.outlineVariant, 
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Header del nivel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        level.title,
                        style: const TextStyle(
                          color: ThemeColors.negroDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 20 / 14, // 142.857%
                        ),
                      ),
                    ),
                  ),
                  
                  // Contenido del nivel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      level.description,
                      style: const TextStyle(
                        color: ThemeColors.negroDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 20 / 12, // 166.667%
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<LevelInfo> _getThreatLevels() {
    return [
      LevelInfo(
        title: 'BAJO',
        backgroundColor: ThemeColors.nivelBajo,
        description: 'Las características del escenario sugieren que la probabilidad de que se presente el evento es mínima, pero en caso de materializarse, éste no tiene potencial para generar impactos negativos sobre los elementos expuestos.',
      ),
      LevelInfo(
        title: 'MEDIO - BAJO',
        backgroundColor: ThemeColors.nivelMedioBajo,
        description: 'Las características del escenario sugieren que es poco probable que se presente el evento, pero en caso de materializarse, éste tiene poco potencial para generar impactos negativos sobre los elementos expuestos.',
      ),
      LevelInfo(
        title: 'MEDIO - ALTO',
        backgroundColor: ThemeColors.nivelMedioAlto,
        description: 'Las características del escenario sugieren la probabilidad de que se presente el evento, así que, en caso de materializarse, éste tiene potencial para generar impactos negativos sobre los elementos expuestos.',
      ),
      LevelInfo(
        title: 'ALTO',
        backgroundColor: ThemeColors.nivelAlto,
        description: 'Las características del escenario sugieren que la probabilidad de que se presente el evento es muy alta, además éste tiene gran potencial para generar impactos negativos sobre los elementos expuestos.',
      ),
    ];
  }

  List<LevelInfo> _getVulnerabilityLevels() {
    return [
      LevelInfo(
        title: 'BAJO',
        backgroundColor: ThemeColors.nivelBajo,
        description: 'Las características del escenario sugieren que los elementos expuestos tienen una capacidad de resistencia alta y baja susceptibilidad ante el evento.',
      ),
      LevelInfo(
        title: 'MEDIO - BAJO',
        backgroundColor: ThemeColors.nivelMedioBajo,
        description: 'Las características del escenario sugieren que los elementos expuestos tienen una capacidad de resistencia moderada y susceptibilidad media-baja ante el evento.',
      ),
      LevelInfo(
        title: 'MEDIO - ALTO',
        backgroundColor: ThemeColors.nivelMedioAlto,
        description: 'Las características del escenario sugieren que los elementos expuestos tienen una capacidad de resistencia baja y susceptibilidad media-alta ante el evento.',
      ),
      LevelInfo(
        title: 'ALTO',
        backgroundColor: ThemeColors.nivelAlto,
        description: 'Las características del escenario sugieren que los elementos expuestos tienen una capacidad de resistencia muy baja y alta susceptibilidad ante el evento.',
      ),
    ];
  }

}

class LevelInfo {
  final String title;
  final Color backgroundColor;
  final String description;

  LevelInfo({
    required this.title,
    required this.backgroundColor,
    required this.description,
  });
}
