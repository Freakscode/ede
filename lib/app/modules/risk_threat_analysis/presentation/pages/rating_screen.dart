import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/shared/models/dropdown_category.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../widgets/progress_bar_widget.dart';
import '../widgets/navigation_buttons_widget.dart';
import '../widgets/save_progress_button.dart';
import '../widgets/threat_levels_dialog.dart';
import 'risk_threat_analysis_screen.dart';

class RatingScreen extends StatefulWidget {
  final Map<String, dynamic>? navigationData;

  const RatingScreen({super.key, this.navigationData});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  
  // Función para hacer scroll inteligente - solo si es necesario
  void _smartScrollToDropdown(BuildContext context, GlobalKey dropdownKey) {
    final scrollController = PrimaryScrollController.of(context);
    if (scrollController != null && scrollController.hasClients) {
      // Obtener la posición del dropdown
      final RenderBox? dropdownRenderBox = dropdownKey.currentContext?.findRenderObject() as RenderBox?;
      if (dropdownRenderBox != null) {
        final dropdownPosition = dropdownRenderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        final dropdownHeight = dropdownRenderBox.size.height;
        
        // Verificar si el dropdown está parcialmente fuera de la pantalla
        final isPartiallyOffScreen = dropdownPosition.dy + dropdownHeight > screenHeight * 0.8;
        
        if (isPartiallyOffScreen) {
          // Hacer scroll mínimo para hacer visible el dropdown
          final currentScrollPosition = scrollController.offset;
          final targetPosition = currentScrollPosition + (dropdownPosition.dy + dropdownHeight - screenHeight * 0.8);
          
          scrollController.animateTo(
            targetPosition.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Solo procesar navigationData si es la primera vez que se carga la pantalla
      // No resetear cuando se navega entre pestañas
      if (widget.navigationData != null) {
        final data = widget.navigationData!;
        final forceReset = data['forceReset'] as bool? ?? false;
        final isNewForm = data['isNewForm'] as bool? ?? false;
        final isEditMode = data['isEditMode'] as bool? ?? false;
        
        // Solo resetear si es explícitamente un formulario nuevo o reset forzado
        if (forceReset || isNewForm) {
          // Formulario nuevo o reset forzado - Reseteando estado
          // context.read<RiskThreatAnalysisBloc>().add(const ResetState()); // COMENTADO: No resetear estado al navegar
        } else if (isEditMode) {
          // Si es modo edición, cargar datos existentes
          final eventToSet = data['event'] as String?;
          final classificationToSet = data['classification'] as String?;
          
          if (eventToSet != null) {
            context.read<RiskThreatAnalysisBloc>().add(
              UpdateSelectedRiskEvent(eventToSet)
            );
          }
          
          if (classificationToSet != null) {
            context.read<RiskThreatAnalysisBloc>().add(
              SelectClassification(classificationToSet)
            );
          }
        }
        // Si no hay flags específicos, NO resetear - mantener el estado actual
      }
      // Si no hay navigationData, NO resetear - mantener el estado actual
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
                  color: DAGRDColors.azulDAGRD,
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
                  final subtitle = (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza' 
                    ? 'Calificación de la Amenaza'
                    : 'Calificación de la Vulnerabilidad';
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 27,
                    ),
                    title: Text(
                      subtitle,
                      style: const TextStyle(
                        color: DAGRDColors.grisMedio,
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
                  final buttonText = (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza' 
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
                      
                      final dropdownKey = GlobalKey(debugLabel: 'dropdown_${subClassification.id}');
                      
                      return Column(
                        children: [
                          ExpandableDropdownField(
                            key: dropdownKey,
                            hint: subClassification.name,
                            value: bloc.getValueForSubClassification(subClassification.id),
                            isSelected: bloc.getIsSelectedForSubClassification(subClassification.id),
                            categories: bloc.getCategoriesForCurrentSubClassification(subClassification.id).cast<DropdownCategory>(),
                            subClassificationId: subClassification.id,
                            onTap: () {
                              bloc.handleDropdownTap(subClassification.id);
                              // Usar scroll inteligente solo si es necesario
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _smartScrollToDropdown(context, dropdownKey);
                              });
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
                  border: Border.all(color: DAGRDColors.azulSecundario),
                  borderRadius: BorderRadius.circular(6),
                  color: DAGRDColors.surfaceVariant, // background: #EFF6FF
                ),
                child: InkWell(
                  onTap: () {
                    ThreatLevelsDialog.show(context);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.info,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          DAGRDColors.azulSecundario,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
                          builder: (context, state) {
                            final displayText = (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza' 
                              ? 'Ver Niveles de Amenaza'
                              : 'Ver Niveles de Vulnerabilidad';
                            
                            return Text(
                              displayText,
                              style: const TextStyle(
                                color: DAGRDColors.azulSecundario,
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
                          DAGRDColors.azulSecundario,
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
                          (state.selectedClassification ?? '').toLowerCase().trim() == 'amenaza' 
                            ? 'Calificación Amenaza'
                            : 'Calificación Vulnerabilidad',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: DAGRDColors.azulDAGRD,
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