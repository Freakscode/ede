import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'rating_screen.dart';
import 'evidence_screen.dart';
import 'rating_results_screen.dart';
import 'final_risk_results_screen.dart';
import 'categories_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../models/form_mode.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart' as home_events;
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';

class RiskThreatAnalysisScreen extends StatefulWidget {
  final String? selectedEvent;
  final Map<String, dynamic>? navigationData;
  
  const RiskThreatAnalysisScreen({super.key, this.selectedEvent, this.navigationData});

  @override
  State<RiskThreatAnalysisScreen> createState() => _RiskThreatAnalysisScreenState();
}

class _RiskThreatAnalysisScreenState extends State<RiskThreatAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void didUpdateWidget(covariant RiskThreatAnalysisScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationData != oldWidget.navigationData) {
      _initializeScreen();
    }
  }

  /// Inicializa la pantalla basándose en los datos de navegación
  void _initializeScreen() {
    if (widget.navigationData == null) return;

    final bloc = context.read<RiskThreatAnalysisBloc>();
    final homeBloc = context.read<HomeBloc>();

    // Extraer datos de navegación
    final event = widget.navigationData!['event'] as String?;
    final targetIndex = widget.navigationData!['targetIndex'] as int? ?? 0;
    final isNewForm = widget.navigationData!['isNewForm'] as bool? ?? false;
    final loadSavedForm = widget.navigationData!['loadSavedForm'] as bool? ?? false;
    final formId = widget.navigationData!['formId'] as String?;
    final forceReset = widget.navigationData!['forceReset'] as bool? ?? false;

    print('=== RiskThreatAnalysisScreen Initialization ===');
    print('Event: $event');
    print('Target Index: $targetIndex');
    print('Is New Form: $isNewForm');
    print('Load Saved Form: $loadSavedForm');
    print('Form ID: $formId');
    print('Force Reset: $forceReset');

    // Determinar modo del formulario
    final formMode = _determineFormMode(isNewForm, loadSavedForm, forceReset);
    bloc.add(SetFormMode(formMode));
    print('Form Mode: ${formMode.value}');

    // Configurar evento si está disponible
    if (event != null && event.isNotEmpty) {
      bloc.add(UpdateSelectedRiskEvent(event));
    }

    // Establecer índice de navegación
    bloc.add(ChangeBottomNavIndex(targetIndex));

    // Manejar datos del formulario según el modo
    if (formMode.isCreate) {
      _handleCreateMode(homeBloc);
    } else {
      _handleEditMode(formId, bloc);
    }

    print('=== End Initialization ===');
  }

  /// Determina el modo del formulario basándose en los parámetros
  FormMode _determineFormMode(bool isNewForm, bool loadSavedForm, bool forceReset) {
    if (isNewForm || forceReset) {
      return FormMode.create;
    }
    
    if (loadSavedForm) {
      return FormMode.edit;
    }
    
    // Verificar si hay un formulario activo
    final homeState = context.read<HomeBloc>().state;
    if (homeState.activeFormId != null && homeState.activeFormId!.isNotEmpty) {
      return FormMode.edit;
    }
    
    return FormMode.create;
  }

  /// Maneja el modo de creación de formulario
  void _handleCreateMode(HomeBloc homeBloc) {
    print('Handling CREATE mode');
    
    // Resetear estado del bloc
    final bloc = context.read<RiskThreatAnalysisBloc>();
    bloc.add(const ResetDropdowns());
    
    // Configurar como nuevo formulario en HomeBloc
    homeBloc.add(home_events.SetActiveFormId(formId: '', isCreatingNew: true));
  }

  /// Maneja el modo de edición de formulario
  void _handleEditMode(String? formId, RiskThreatAnalysisBloc bloc) {
    print('Handling EDIT mode');
    
    if (formId != null && formId.isNotEmpty) {
      // Cargar datos del formulario desde SQLite
      _loadFormData(formId, bloc);
    }
  }

  /// Carga los datos del formulario desde SQLite
  Future<void> _loadFormData(String formId, RiskThreatAnalysisBloc bloc) async {
    try {
      print('Loading form data for ID: $formId');
      
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm != null) {
        // Cargar datos en el bloc
        final evaluationData = completeForm.toJson();
        bloc.add(LoadFormData(
          eventName: completeForm.eventName,
          classificationType: 'amenaza', // Por defecto, se puede ajustar
          evaluationData: evaluationData,
        ));
        
        print('Form data loaded successfully');
      } else {
        print('Form not found in database');
      }
    } catch (e) {
      print('Error loading form data: $e');
    }
  }

  /// Maneja la navegación de regreso
  void _handleBackNavigation(RiskThreatAnalysisState state) {
    if (state.currentBottomNavIndex == 4) {
      // Desde Resultados Finales, volver a Categorías
      context.read<RiskThreatAnalysisBloc>().add(ChangeBottomNavIndex(0));
    } else if (state.currentBottomNavIndex > 0) {
      // Navegar al índice anterior
      context.read<RiskThreatAnalysisBloc>().add(
        ChangeBottomNavIndex(state.currentBottomNavIndex - 1),
      );
    } else {
      // Desde Categorías, salir de la pantalla
      _exitScreen();
    }
  }

  /// Sale de la pantalla y limpia el estado
  void _exitScreen() {
    // Resetear estado del RiskThreatAnalysisBloc
    context.read<RiskThreatAnalysisBloc>().add(ResetState());
    
    // Actualizar estado del HomeBloc
    final homeBloc = context.read<HomeBloc>();
    final currentHomeState = homeBloc.state;
    if (currentHomeState.activeFormId != null) {
      homeBloc.add(home_events.SetActiveFormId(
        formId: currentHomeState.activeFormId!, 
        isCreatingNew: false
      ));
    }
    
    // Salir de la pantalla - navegar de vuelta al home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        // Definir las pantallas disponibles
        final screens = [
          const RiskCategoriesScreen(), // Índice 0 - Categorías
          RatingScreen(navigationData: widget.navigationData), // Índice 1 - Calificación
          const EvidenceScreen(), // Índice 2 - Evidencias
          const RatingResultsScreen(), // Índice 3 - Resultados
          FinalRiskResultsScreen(eventName: state.selectedRiskEvent ?? ''), // Índice 4 - Resultados Finales
        ];

        return Scaffold(
          appBar: CustomAppBar(
            showBack: true,
            onBack: () => _handleBackNavigation(state),
            showInfo: true,
            showProfile: true,
          ),
          
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: screens[state.currentBottomNavIndex],
          ),
          
          // Mostrar barra de navegación solo en pantallas intermedias
          bottomNavigationBar: (state.currentBottomNavIndex == 0 || state.currentBottomNavIndex == 4) 
              ? null 
              : CustomBottomNavBar(
                  currentIndex: state.currentBottomNavIndex,
                  onTap: (index) {
                    context.read<RiskThreatAnalysisBloc>().add(
                      ChangeBottomNavIndex(index),
                    );
                  },
                  items: const [
                    CustomBottomNavBarItem(
                      label: 'Categorías',
                      iconAsset: AppIcons.clipboardText,
                    ),
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
}