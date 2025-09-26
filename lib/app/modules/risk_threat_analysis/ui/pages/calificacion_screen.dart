import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class CalificacionScreen extends StatelessWidget {
  const CalificacionScreen({super.key});

  /// Obtiene el valor seleccionado para una subclasificación específica
  String? _getValueForSubClassification(RiskThreatAnalysisState state, String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.selectedProbabilidad;
      case 'intensidad':
        return state.selectedIntensidad;
      default:
        return null;
    }
  }

  /// Verifica si el dropdown está abierto para una subclasificación específica
  bool _getIsSelectedForSubClassification(RiskThreatAnalysisState state, String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.isProbabilidadDropdownOpen;
      case 'intensidad':
        return state.isIntensidadDropdownOpen;
      default:
        return false;
    }
  }

  /// Maneja el tap en un dropdown específico
  void _handleDropdownTap(BuildContext context, String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        context.read<RiskThreatAnalysisBloc>().add(ToggleProbabilidadDropdown());
        break;
      case 'intensidad':
        context.read<RiskThreatAnalysisBloc>().add(ToggleIntensidadDropdown());
        break;
    }
  }

  /// Maneja la selección de una categoría en un dropdown específico
  void _handleSelectionChanged(BuildContext context, String subClassificationId, String category, String level) {
    switch (subClassificationId) {
      case 'probabilidad':
        context.read<RiskThreatAnalysisBloc>().add(UpdateProbabilidadSelection(category, level));
        break;
      case 'intensidad':
        context.read<RiskThreatAnalysisBloc>().add(UpdateIntensidadSelection(category, level));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
      child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
        builder: (context, state) {
          return Column(
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
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 27,
                ),
                title: Text(
                  'Calificación de la Amenaza',
                  style: const TextStyle(
                    color: Color(0xFF706F6F),
                    fontFamily: 'Work Sans',
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 28 / 18,
                  ),
                ),
                trailing: SvgPicture.asset(
                  AppIcons.info,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    DAGRDColors.amarDAGRD,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CustomElevatedButton(
                text: 'Factor de Amenaza',
                onPressed: () {},
                backgroundColor: DAGRDColors.azulDAGRD,
                textColor: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                borderRadius: 8,
              ),
              const SizedBox(height: 24),
              // Generar dropdowns dinámicamente basados en las RiskSubClassification
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  final subClassifications = bloc.getAmenazaSubClassifications();
                  
                  return Column(
                    children: subClassifications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subClassification = entry.value;
                      
                      return Column(
                        children: [
                          ExpandableDropdownField(
                            hint: subClassification.name,
                            value: _getValueForSubClassification(state, subClassification.id),
                            isSelected: _getIsSelectedForSubClassification(state, subClassification.id),
                            categories: bloc.getCategoriesForSubClassification(subClassification.id),
                            onTap: () {
                              _handleDropdownTap(context, subClassification.id);
                            },
                            onSelectionChanged: (category, level) {
                              _handleSelectionChanged(context, subClassification.id, category, level);
                            },
                          ),
                          // Agregar espaciado entre dropdowns, excepto después del último
                          if (index < subClassifications.length - 1) 
                            const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Ver Niveles de Amenaza
              Container(
                width: double.infinity,
                height: 44,
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2563EB)),
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFEFF6FF), // background: #EFF6FF
                ),
                child: InkWell(
                  onTap: () {
                    // Acción para ver niveles de amenaza
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.info,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2563EB),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ver Niveles de Amenaza',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16, // 150% line-height
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(
                        AppIcons.preview,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2563EB),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Barra de progreso dinámica
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  final progress = bloc.calculateCompletionPercentage();
                  final progressText = '${(progress * 100).toInt()}% completado';
                  
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
              const SizedBox(height: 32),
              // Sección Calificación Amenaza dinámica
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Calificación Amenaza',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF232B48),
                          fontFamily: 'Work Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 16 / 16,
                        ),
                      ),
                      Container(
                        width: 165,
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: bloc.getThreatBackgroundColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            bloc.getFormattedThreatRating(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: bloc.getThreatTextColor(),
                              fontFamily: 'Work Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 16 / 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Botón Guardar avance
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para guardar avance
                  },
                  icon: SvgPicture.asset(
                    AppIcons.save,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.blancoDAGRD,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Guardar avance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // #FFF
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 24 / 14, // line-height: 171.429%
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
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
              const SizedBox(height: 20), // Padding bottom adicional
            ],
          );
        },
      ),
    );
  }
}