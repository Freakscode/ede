import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'rating_screen.dart';
import 'evidence_screen.dart';
import 'rating_results_screen.dart';
import 'final_risk_results_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../widgets/home_navigation_type.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart' as home_events;
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';

class RiskThreatAnalysisScreen extends StatefulWidget {
  final String? selectedEvent;
  final Map<String, dynamic>? navigationData;
  
  const RiskThreatAnalysisScreen({super.key, this.selectedEvent, this.navigationData});

  @override
  State<RiskThreatAnalysisScreen> createState() => RiskThreatAnalysisScreenState();
}

class RiskThreatAnalysisScreenState extends State<RiskThreatAnalysisScreen> {
  final ScrollController scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _processNavigationData();
  }

  @override
  void didUpdateWidget(covariant RiskThreatAnalysisScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Procesar navigationData si cambió
    if (widget.navigationData != oldWidget.navigationData) {
      _processNavigationData();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _processNavigationData() {
    
    final bloc = context.read<RiskThreatAnalysisBloc>();
    
    // Actualizar el evento seleccionado si es diferente
    if (widget.selectedEvent != null && widget.selectedEvent!.isNotEmpty) {
      bloc.add(UpdateSelectedRiskEvent(widget.selectedEvent!));
    }

    // Si tenemos navigationData, procesarla INMEDIATAMENTE
    if (widget.navigationData != null) {
      final eventFromNavData = widget.navigationData!['event'] as String?;
      final finalResults = widget.navigationData!['finalResults'] as bool? ?? false;
      final targetIndex = widget.navigationData!['targetIndex'] as int?;
      final classificationName = widget.navigationData!['classification'] as String?;
      final directToResults = widget.navigationData!['directToResults'] as bool? ?? false;

      
      // Verificar primero si es un formulario nuevo para evitar cargar datos existentes
      final loadSavedForm = widget.navigationData!['loadSavedForm'] as bool? ?? false;
      final formId = widget.navigationData!['formId'] as String?;
      final forceReset = widget.navigationData!['forceReset'] as bool? ?? false;
      final isNewForm = widget.navigationData!['isNewForm'] as bool? ?? false;
      
      // Procesando datos de navegación
      
      // PRIORIDAD 1: Navegación a FinalRiskResultsScreen
      if (finalResults && targetIndex != null) {
        // Configurar el evento de riesgo si viene de navegación
        if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
        }
        
        // Cargar datos del formulario completo antes de ir a resultados finales
        final homeState = context.read<HomeBloc>().state;
        if (homeState.activeFormId != null) {
          _loadCompleteFormDataForFinalResults(homeState.activeFormId!, bloc);
        }
        
        bloc.add(ChangeBottomNavIndex(targetIndex));
        return; // Salir inmediatamente sin procesar otras opciones
      }
      
      // PRIORIDAD 2: Procesar según el tipo de formulario
      if (loadSavedForm && formId != null) {
        // Cargar formulario desde SQLite (continuar formulario existente)
        // Cargando formulario guardado
        
        // Establecer evento y clasificación ANTES de cargar datos
        if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
        }
        if (classificationName != null) {
          final navIndex = directToResults ? 2 : 0;
          bloc.add(ChangeBottomNavIndex(navIndex));
          bloc.add(SelectClassification(classificationName));
        }
        
        _loadFormFromSQLite(formId, bloc);
        
        } else if (forceReset || isNewForm) {
          // Formulario nuevo - reset completo
          _handleNewFormReset(bloc, eventFromNavData, classificationName, directToResults);
        
      } else {
        // Cargar datos existentes desde HomeBloc (comportamiento anterior)
        // Cargando datos existentes
        
        // Establecer evento y clasificación ANTES de cargar datos
        if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
        }
        if (classificationName != null) {
          final navIndex = directToResults ? 2 : 0;
          bloc.add(ChangeBottomNavIndex(navIndex));
          bloc.add(SelectClassification(classificationName));
        }
        
        // Cargar datos usando eventos
        bloc.add(LoadFormData(
          eventName: eventFromNavData ?? '',
          classificationType: classificationName ?? '',
        ));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
        builder: (context, state) {
          final List<Widget> screens = [
            RatingScreen(navigationData: widget.navigationData),
            const EvidenceScreen(),
            const RatingResultsScreen(),
            FinalRiskResultsScreen(eventName: state.selectedRiskEvent),
          ];
          
          return Scaffold(
            appBar:  CustomAppBar(
              showBack: true,
              onBack: () {
                if (state.currentBottomNavIndex == 3) {
                  // Cuando estamos en FinalRiskResultsScreen (índice 3), volver a categorías
                  final navigationData = {'showRiskCategories': true};
                  context.go('/home', extra: navigationData);
                } else if (state.currentBottomNavIndex > 0) {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ChangeBottomNavIndex(state.currentBottomNavIndex - 1),
                  );
                } else {
                  // Cuando estamos en el primer índice, volver al HomeScreen con categorías
                  final navigationData = HomeNavigationType.riskCategories.toNavigationData();
                  context.go('/home', extra: navigationData);
                }
              },
              showInfo: true,
              showProfile: true,
            ),
            body: Builder(
              builder: (context) {
                return SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: screens[state.currentBottomNavIndex],
                );
              },
            ),
           
            bottomNavigationBar: state.currentBottomNavIndex == 3 ? null : CustomBottomNavBar(
              currentIndex: state.currentBottomNavIndex,
              onTap: (index) {
                context.read<RiskThreatAnalysisBloc>().add(
                  ChangeBottomNavIndex(index),
                );
              },
              items: const [
                CustomBottomNavBarItem(
                  label: 'Calificación',
                  iconAsset: AppIcons.clipboardText,
                ),
                CustomBottomNavBarItem(
                  label: 'Evidencias',
                  iconAsset: AppIcons.images,
                ),
                CustomBottomNavBarItem(
                  label: 'Resultados',
                  iconAsset: AppIcons.hoja,
                ),
              ],
              backgroundColor: DAGRDColors.azulDAGRD,
              selectedColor: Colors.white,
              unselectedColor: Colors.white60,
              selectedIconBgColor: Colors.white,
            ),
          );
        },
      );
  }

  /// Carga un formulario guardado desde SQLite
  Future<void> _loadFormFromSQLite(String formId, RiskThreatAnalysisBloc bloc) async {
    try {
      // Cargando formulario desde SQLite
      
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm != null) {
        // Formulario encontrado, procesando datos
        
        // Obtener la clasificación actual del navigationData
        final classification = widget.navigationData?['classification'] as String? ?? 'amenaza';
        
        // Preparar datos específicos según la clasificación
        Map<String, dynamic> formData = {};
        
        if (classification.toLowerCase() == 'amenaza') {
          formData = {
            'probabilidadSelections': completeForm.amenazaProbabilidadSelections,
            'intensidadSelections': completeForm.amenazaIntensidadSelections,
            'dynamicSelections': completeForm.amenazaSelections,
            'subClassificationScores': completeForm.amenazaScores,
            'subClassificationColors': completeForm.amenazaColors,
            'evidenceImages': completeForm.evidenceImages,
            'evidenceCoordinates': completeForm.evidenceCoordinates,
          };
        } else if (classification.toLowerCase() == 'vulnerabilidad') {
          formData = {
            'probabilidadSelections': completeForm.vulnerabilidadProbabilidadSelections,
            'intensidadSelections': completeForm.vulnerabilidadIntensidadSelections,
            'dynamicSelections': completeForm.vulnerabilidadSelections,
            'subClassificationScores': completeForm.vulnerabilidadScores,
            'subClassificationColors': completeForm.vulnerabilidadColors,
            'evidenceImages': completeForm.evidenceImages,
            'evidenceCoordinates': completeForm.evidenceCoordinates,
          };
        }
        
        // Cargar datos específicos en el bloc
        bloc.add(LoadFormData(
          eventName: completeForm.eventName,
          classificationType: classification,
          evaluationData: formData, // Pasar los datos específicos
        ));
        
        // Formulario cargado exitosamente
      } else {
        // Formulario no encontrado
      }
    } catch (e) {
      print('Error al cargar formulario completo desde SQLite: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Carga datos completos del formulario para mostrar en resultados finales
  void _loadCompleteFormDataForFinalResults(String formId, RiskThreatAnalysisBloc bloc) async {
    try {
      // Cargando formulario para resultados finales
      
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm != null) {
        // Formulario encontrado para resultados finales
        
        // Combinar datos de Amenaza y Vulnerabilidad para mostrar en resultados finales
        // final combinedData = <String, dynamic>{
        //   'dynamicSelections': {
        //     ...completeForm.amenazaSelections,
        //     ...completeForm.vulnerabilidadSelections,
        //   },
        //   'subClassificationScores': {
        //     ...completeForm.amenazaScores,
        //     ...completeForm.vulnerabilidadScores,
        //   },
        //   'subClassificationColors': {
        //     ...completeForm.amenazaColors,
        //     ...completeForm.vulnerabilidadColors,
        //   },
        //   'probabilidadSelections': completeForm.amenazaProbabilidadSelections,
        //   'intensidadSelections': completeForm.amenazaIntensidadSelections,
        //   'selectedProbabilidad': completeForm.amenazaSelectedProbabilidad,
        //   'selectedIntensidad': completeForm.amenazaSelectedIntensidad,
        //   'evidenceImages': completeForm.evidenceImages,
        //   'evidenceCoordinates': completeForm.evidenceCoordinates,
        // };
        
        // Datos combinados cargados para resultados finales
        
        // Cargar datos combinados en el bloc
        bloc.add(LoadFormData(
          eventName: completeForm.eventName,
          classificationType: 'final_results',
        ));
        
        // Datos cargados exitosamente
      } else {
        // Formulario no encontrado para resultados finales
      }
    } catch (e) {
      print('Error al cargar formulario completo para resultados finales: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Maneja el reset completo para formularios nuevos
  void _handleNewFormReset(
    RiskThreatAnalysisBloc bloc,
    String? eventFromNavData,
    String? classificationName,
    bool directToResults,
  ) {
    // Resetear completamente el bloc
    bloc.add(const ResetDropdowns());
    
    // Resetear el activeFormId en HomeBloc
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(home_events.SetActiveFormId(formId: '', isCreatingNew: true));
    
    // Establecer evento y clasificación después del reset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
        bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
      }
      if (classificationName != null) {
        final navIndex = directToResults ? 2 : 0;
        bloc.add(ChangeBottomNavIndex(navIndex));
        bloc.add(SelectClassification(classificationName));
      }
    });
  }

}
