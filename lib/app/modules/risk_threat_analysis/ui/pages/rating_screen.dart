import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/widgets/navigation_buttons_widget.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/widgets/progress_bar_widget.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';


class RatingScreen extends StatefulWidget {
  final Map<String, dynamic>? navigationData;
  
  const RatingScreen({super.key, this.navigationData});
  
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  
  @override
  void initState() {
    super.initState();
    // Inicializar el Bloc con la clasificación desde los datos de navegación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.navigationData != null) {
        final classificationName = widget.navigationData!['classification'] as String?;
        final eventName = widget.navigationData!['event'] as String?;
        
        // Configurar el evento seleccionado
        if (eventName != null) {
          context.read<RiskThreatAnalysisBloc>().add(
            UpdateSelectedRiskEvent(eventName)
          );
        }
        
        // Configurar la clasificación seleccionada
        if (classificationName != null) {
          context.read<RiskThreatAnalysisBloc>().add(
            SelectClassification(classificationName)
          );
        }
      } else {
        // Fallback: usar valores por defecto
        context.read<RiskThreatAnalysisBloc>().add(
          SelectClassification('amenaza')
        );
      }
    });
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
              // Título dinámico basado en la clasificación seleccionada
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final subtitle = state.selectedClassification == 'amenaza' 
                    ? 'Calificación de la Amenaza'
                    : 'Calificación de la Vulnerabilidad';
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 27,
                    ),
                    title: Text(
                      subtitle,
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
                  );
                },
              ),
              const SizedBox(height: 18),
              // Botón dinámico basado en la clasificación seleccionada
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final buttonText = state.selectedClassification == 'amenaza' 
                    ? 'Factor de Amenaza'
                    : 'Factor de Vulnerabilidad';
                  
                  return CustomElevatedButton(
                    text: buttonText,
                    onPressed: () {}, // Solo informativo, no hace nada
                    backgroundColor: DAGRDColors.azulDAGRD,
                    textColor: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    borderRadius: 8,
                  );
                },
              ),
              const SizedBox(height: 24),
              // Generar dropdowns dinámicamente basados en la clasificación seleccionada
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  final subClassifications = bloc.getCurrentSubClassifications();
                  // RiskCategory
                  return Column(
                    children: subClassifications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subClassification = entry.value;
                      
                      return Column(
                        children: [
                          ExpandableDropdownField(
                            hint: subClassification.name,
                            value: bloc.getValueForSubClassification(subClassification.id),
                            isSelected: bloc.getIsSelectedForSubClassification(subClassification.id),
                            categories: bloc.getCategoriesForCurrentSubClassification(subClassification.id),
                            subClassificationId: subClassification.id,
                            onTap: () {
                              bloc.handleDropdownTap(subClassification.id);
                            },
                            onSelectionChanged: (category, level) {
                              bloc.handleSelectionChanged(subClassification.id, category, level);
                            },
                            calculationDetails: bloc.getSubClassificationCalculationDetails(subClassification.id),
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
                      Expanded(
                        child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                          builder: (context, state) {
                            final displayText = state.selectedClassification == 'amenaza' 
                              ? 'Ver Niveles de Amenaza'
                              : 'Ver Niveles de Vulnerabilidad';
                            
                            return Text(
                              displayText,
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontFamily: 'Work Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 24 / 16, // 150% line-height
                              ),
                            );
                          },
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
              const ProgressBarWidget(),
              const SizedBox(height: 32),
              // Sección Calificación Amenaza dinámica
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  final bloc = context.read<RiskThreatAnalysisBloc>();
                  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título de calificación dinámico
                      Expanded(
                        flex: 2,
                        child: Text(
                          state.selectedClassification == 'amenaza' 
                            ? 'Calificación Amenaza'
                            : 'Calificación Vulnerabilidad',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF232B48),
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Contenedor de calificación con colores dinámicos
                      Container(
                        width: 165,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: bloc.getThreatBackgroundColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(bloc.getFormattedThreatRating(), textAlign: TextAlign.center, 
                            style: TextStyle(color: bloc.getThreatTextColor(), fontFamily: 'Work Sans', fontSize: 16, fontWeight: FontWeight.w600, height: 1.0)),
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
              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
              ),
              const SizedBox(height: 50), // Padding bottom adicional
            ],
          );
        },
      ),
    );
  }
}