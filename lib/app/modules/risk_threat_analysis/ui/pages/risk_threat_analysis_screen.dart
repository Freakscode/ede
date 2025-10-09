import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/rating_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/evidence_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/rating_results_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/final_risk_results_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/home_navigation_type.dart';
import '../../../home/bloc/home_bloc.dart';
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
      
      print('=== RiskThreatAnalysisScreen Navigation Decision ===');
      print('navigationData completo: ${widget.navigationData}');
      print('loadSavedForm: $loadSavedForm');
      print('formId: $formId');
      print('forceReset: $forceReset');
      print('isNewForm: $isNewForm');
      print('classificationName: $classificationName');
      print('eventFromNavData: $eventFromNavData');
      
      // PRIORIDAD 1: Navegación a FinalRiskResultsScreen
      if (finalResults && targetIndex != null) {
        // Configurar el evento de riesgo si viene de navegación
        if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
        }
        bloc.add(ChangeBottomNavIndex(targetIndex));
        return; // Salir inmediatamente sin procesar otras opciones
      }
      
      // PRIORIDAD 2: Procesar según el tipo de formulario
      if (loadSavedForm && formId != null) {
        // Cargar formulario desde SQLite (continuar formulario existente)
        print('DECISIÓN: Cargar formulario guardado desde SQLite');
        
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
          // Formulario nuevo - resetear completamente el RiskThreatAnalysisBloc
          print('DECISIÓN: Formulario nuevo - reset completo del bloc');
          print('RiskThreatAnalysisScreen: Estado ANTES del reset - ${bloc.state.toString()}');
          
          // FORZAR reset completo del bloc
          bloc.add(ResetDropdowns());
          
          // Esperar un poco más para asegurar que el reset se complete
          Future.delayed(const Duration(milliseconds: 100), () {
            print('RiskThreatAnalysisScreen: Estado DESPUÉS del reset - ${bloc.state.toString()}');
            
            // Después del reset, establecer el evento y clasificación para el nuevo formulario
            if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
              bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
              print('RiskThreatAnalysisScreen: Evento establecido después del reset: $eventFromNavData');
            }
            if (classificationName != null) {
              final navIndex = directToResults ? 2 : 0;
              bloc.add(ChangeBottomNavIndex(navIndex));
              bloc.add(SelectClassification(classificationName));
              print('RiskThreatAnalysisScreen: Clasificación establecida después del reset: $classificationName');
            }
          });
          
          print('RiskThreatAnalysisScreen: ResetDropdowns ejecutado');
        
      } else {
        // Cargar datos existentes desde HomeBloc (comportamiento anterior)
        print('DECISIÓN: Cargar datos desde HomeBloc (comportamiento anterior)');
        
        // Establecer evento y clasificación ANTES de cargar datos
        if (eventFromNavData != null && eventFromNavData.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(eventFromNavData));
        }
        if (classificationName != null) {
          final navIndex = directToResults ? 2 : 0;
          bloc.add(ChangeBottomNavIndex(navIndex));
          bloc.add(SelectClassification(classificationName));
        }
        
        final homeBloc = context.read<HomeBloc>();
        final savedData = homeBloc.getSavedRiskEventModel(eventFromNavData ?? '', classificationName ?? '');
        bloc.loadExistingFormData(eventFromNavData ?? '', classificationName ?? '', savedData);
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
                if (state.currentBottomNavIndex > 0) {
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
      print('=== _loadFormFromSQLite DEBUG ===');
      print('FormId: $formId');
      
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm != null) {
        print('CompleteForm encontrado:');
        print('  - EventName: ${completeForm.eventName}');
        print('  - Amenaza Probabilidad: ${completeForm.amenazaProbabilidadSelections}');
        print('  - Amenaza Intensidad: ${completeForm.amenazaIntensidadSelections}');
        print('  - Amenaza Selected Prob: ${completeForm.amenazaSelectedProbabilidad}');
        print('  - Amenaza Selected Int: ${completeForm.amenazaSelectedIntensidad}');
        print('  - Vulnerabilidad: ${completeForm.vulnerabilidadSelections}');
        
        // Obtener la clasificación actual del navigationData
        final classification = widget.navigationData?['classification'] as String? ?? 'amenaza';
        print('Classification a cargar: $classification');
        
        Map<String, dynamic> formData;
        
        // Cargar datos según la clasificación actual
        if (classification.toLowerCase() == 'amenaza') {
          formData = {
            'dynamicSelections': completeForm.amenazaSelections,
            'subClassificationScores': completeForm.amenazaScores,
            'subClassificationColors': completeForm.amenazaColors,
            'probabilidadSelections': completeForm.amenazaProbabilidadSelections,
            'intensidadSelections': completeForm.amenazaIntensidadSelections,
            'selectedProbabilidad': completeForm.amenazaSelectedProbabilidad,
            'selectedIntensidad': completeForm.amenazaSelectedIntensidad,
          };
          print('Cargando datos de AMENAZA');
        } else if (classification.toLowerCase() == 'vulnerabilidad') {
          formData = {
            'dynamicSelections': completeForm.vulnerabilidadSelections,
            'subClassificationScores': completeForm.vulnerabilidadScores,
            'subClassificationColors': completeForm.vulnerabilidadColors,
            'probabilidadSelections': completeForm.vulnerabilidadProbabilidadSelections,
            'intensidadSelections': completeForm.vulnerabilidadIntensidadSelections,
            'selectedProbabilidad': completeForm.vulnerabilidadSelectedProbabilidad,
            'selectedIntensidad': completeForm.vulnerabilidadSelectedIntensidad,
          };
          print('Cargando datos de VULNERABILIDAD');
        } else {
          // Fallback a amenaza
          formData = {
            'dynamicSelections': completeForm.amenazaSelections,
            'subClassificationScores': completeForm.amenazaScores,
            'subClassificationColors': completeForm.amenazaColors,
            'probabilidadSelections': completeForm.amenazaProbabilidadSelections,
            'intensidadSelections': completeForm.amenazaIntensidadSelections,
            'selectedProbabilidad': completeForm.amenazaSelectedProbabilidad,
            'selectedIntensidad': completeForm.amenazaSelectedIntensidad,
          };
          print('Cargando datos de AMENAZA (fallback)');
        }
        
        print('FormData preparado: $formData');
        
        // Cargar datos en el bloc - pasar los datos en el formato esperado
        final dataWithEvaluationWrapper = {
          'evaluationData': formData,
        };
        print('Enviando a loadExistingFormData...');
        bloc.loadExistingFormData(completeForm.eventName, classification, dataWithEvaluationWrapper);
        
        print('Formulario completo cargado desde SQLite: $formId');
        print('Evento: ${completeForm.eventName}');
        print('Clasificación: $classification');
      } else {
        print('No se encontró el formulario completo con ID: $formId');
      }
      print('=== FIN _loadFormFromSQLite DEBUG ===');
    } catch (e) {
      print('Error al cargar formulario completo desde SQLite: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }
}
