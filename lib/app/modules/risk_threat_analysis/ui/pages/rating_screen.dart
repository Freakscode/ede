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
import '../widgets/progress_bar_widget.dart';
import '../widgets/navigation_buttons_widget.dart';
import '../widgets/save_progress_button.dart';

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
    // Manejar la inicialización según el origen de navegación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String eventToSet = 'Movimiento en Masa'; // Evento por defecto
      String classificationToSet = 'amenaza'; // Clasificación por defecto
      bool shouldReset = true; // Por defecto, siempre resetear
      
      // Analizar datos de navegación
      if (widget.navigationData != null) {
        final data = widget.navigationData!;
        final eventName = data['event'] as String?;
        final classificationName = data['classification'] as String?;
        final forceReset = data['forceReset'] as bool? ?? true;
        final isNewForm = data['isNewForm'] as bool? ?? true;
        final loadExisting = data['loadExisting'] as bool? ?? false;
        final source = data['source'] as String? ?? 'unknown';
        
        print('📱 RATING SCREEN - Datos de navegación:');
        print('   Evento: $eventName');
        print('   Clasificación: $classificationName');
        print('   Forzar Reset: $forceReset');
        print('   Nuevo Formulario: $isNewForm');
        print('   Cargar Existente: $loadExisting');
        print('   Origen: $source');
        
        if (eventName != null) {
          eventToSet = eventName;
        }
        if (classificationName != null) {
          classificationToSet = classificationName;
        }
        
        // Determinar si necesita reset basado en los flags
        shouldReset = forceReset || isNewForm;
        
        // Casos especiales donde NO se debe resetear
        if (loadExisting || (!isNewForm && !forceReset)) {
          shouldReset = false;
          print('   ⚠️ NO RESET: Cargando formulario existente o continuando actual');
        }
      }
      
      if (shouldReset) {
        print('🔄 EJECUTANDO RESET COMPLETO');
        // Configurar evento y clasificación para nuevo formulario
        context.read<RiskThreatAnalysisBloc>().add(
          UpdateSelectedRiskEvent(eventToSet)
        );
        
        // Después del reset, establecer la clasificación correcta si es necesario
        if (classificationToSet != 'amenaza') {
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              print('🎯 Cambiando a clasificación: $classificationToSet');
              context.read<RiskThreatAnalysisBloc>().add(
                SelectClassification(classificationToSet)
              );
            }
          });
        }
      } else {
        print('⏭️ MANTENIENDO ESTADO ACTUAL - No hay reset');
        // Solo actualizar evento y clasificación sin reset
        final currentState = context.read<RiskThreatAnalysisBloc>().state;
        
        if (currentState.selectedRiskEvent != eventToSet) {
          context.read<RiskThreatAnalysisBloc>().add(
            UpdateSelectedRiskEvent(eventToSet)
          );
        }
        
        if (currentState.selectedClassification != classificationToSet) {
          context.read<RiskThreatAnalysisBloc>().add(
            SelectClassification(classificationToSet)
          );
        }
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
                          child: Text(
                            bloc.getFormattedThreatRating(), 
                            textAlign: TextAlign.center, 
                            style: TextStyle(
                              color: bloc.getThreatTextColor(), 
                              fontFamily: 'Work Sans', 
                              fontSize: 16, 
                              fontWeight: FontWeight.w600, 
                              height: 1.0
                            )
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Botón Guardar avance
              const SaveProgressButton(),
              const SizedBox(height: 40),
              // Botones de navegación
              BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                builder: (context, state) {
                  return NavigationButtonsWidget(
                    currentIndex: state.currentBottomNavIndex,
                  );
                },
              ),
              const SizedBox(height: 50), // Padding bottom adicional
            ],
          );
        },
      ),
    );
  }
}