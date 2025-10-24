import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_container.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RiskCategoriesScreen extends StatefulWidget {
  const RiskCategoriesScreen({super.key});

  @override
  State<RiskCategoriesScreen> createState() => _RiskCategoriesScreenState();
}

class _RiskCategoriesScreenState extends State<RiskCategoriesScreen> {
  // Método para determinar el estado de una categoría
  CategoryState _getCategoryState(
    String classification,
    HomeState homeState,
    BuildContext context,
    RiskThreatAnalysisState riskState,
    Map<String, double>? progressData,
  ) {
    final isAmenaza = classification.toLowerCase() == 'amenaza';
    final isVulnerabilidad = classification.toLowerCase() == 'vulnerabilidad';
    final isEditMode =
        homeState.activeFormId != null && !homeState.isCreatingNew;

    if (isAmenaza) {
      return _getAmenazaState(context, riskState, progressData);
    } else if (isVulnerabilidad) {
      return _getVulnerabilidadState(homeState, context, isEditMode, riskState, progressData);
    }

    return const CategoryState(isAvailable: false, progressPercentage: 0);
  }

  // Estado específico para Amenaza
  CategoryState _getAmenazaState(BuildContext context, RiskThreatAnalysisState riskState, Map<String, double>? progressData) {
    int progressPercentage = 0;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['amenaza'] != null) {
      progressPercentage = (progressData['amenaza']! * 100).round();
    }

    return CategoryState(
      isAvailable: true,
      progressPercentage: progressPercentage,
    );
  }

  // Estado específico para Vulnerabilidad
  CategoryState _getVulnerabilidadState(
    HomeState homeState,
    BuildContext context,
    bool isEditMode,
    RiskThreatAnalysisState riskState,
    Map<String, double>? progressData,
  ) {
    if (isEditMode) {
      return _getVulnerabilidadEditMode(homeState, context, riskState, progressData);
    } else {
      return _getVulnerabilidadCreateMode(homeState, context, riskState, progressData);
    }
  }

  // Estado de Vulnerabilidad en modo edición
  CategoryState _getVulnerabilidadEditMode(
    HomeState homeState,
    BuildContext context,
    RiskThreatAnalysisState riskState,
    Map<String, double>? progressData,
  ) {
    final isAvailable = homeState.activeFormId != null;
    int progressPercentage = 0;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['vulnerabilidad'] != null) {
      progressPercentage = (progressData['vulnerabilidad']! * 100).round();
    }

    return CategoryState(
      isAvailable: isAvailable,
      progressPercentage: progressPercentage,
      disabledMessage: isAvailable ? null : 'No hay formulario activo',
    );
  }

  // Estado de Vulnerabilidad en modo creación
  CategoryState _getVulnerabilidadCreateMode(
    HomeState homeState,
    BuildContext context,
    RiskThreatAnalysisState riskState,
    Map<String, double>? progressData,
  ) {
    bool amenazaCompleted = false;

    // Verificar si amenaza está completa usando solo el estado actual
    if (riskState.selectedRiskEvent != null && riskState.selectedRiskEvent!.isNotEmpty) {
      // Usar solo el estado actual sin llamar al BLoC para evitar bucles
      final hasAmenazaData = riskState.probabilidadSelections.isNotEmpty || 
                            riskState.intensidadSelections.isNotEmpty;
      final hasEvidence = riskState.evidenceImages.isNotEmpty;
      
      // Simplificar la lógica: si hay datos de amenaza y evidencias, considerar completa
      amenazaCompleted = hasAmenazaData && hasEvidence;
    }

    final isAvailable = amenazaCompleted && homeState.activeFormId != null;
    int progressPercentage = 0;
    String? disabledMessage;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['vulnerabilidad'] != null) {
      progressPercentage = (progressData['vulnerabilidad']! * 100).round();
    }

    if (!isAvailable) {
      disabledMessage = amenazaCompleted
          ? 'No hay formulario activo'
          : 'Complete primero la calificación de Amenaza';
    }

    return CategoryState(
      isAvailable: isAvailable,
      progressPercentage: progressPercentage,
      disabledMessage: disabledMessage,
    );
  }

  // Navegar a la categoría seleccionada
  void _navigateToCategory(
    String classification,
    String selectedEvent,
    bool isCompleted,
  ) {
    final homeBloc = context.read<HomeBloc>();
    final currentHomeState = homeBloc.state;

    // Guardar la categoría seleccionada
    homeBloc.add(
      SelectRiskCategory(
        categoryType: classification,
        eventName: selectedEvent,
      ),
    );

    // Configurar el RiskThreatAnalysisBloc ANTES de navegar
    final riskBloc = context.read<RiskThreatAnalysisBloc>();
    
    // Configurar evento y clasificación inmediatamente
    riskBloc.add(UpdateSelectedRiskEvent(selectedEvent));
    riskBloc.add(SelectClassification(classification.toLowerCase()));
    
    // SIEMPRE ir al RatingScreen (índice 0) desde RiskCategoriesScreen
    riskBloc.add(ChangeBottomNavIndex(0));

    final navigationData = <String, dynamic>{
      'event': selectedEvent,
      'classification': classification.toLowerCase(),
      'targetIndex': 0, // SIEMPRE RatingScreen
      'source': 'RiskCategoriesScreen',
    };

    // Configurar datos de navegación según el modo
    if (currentHomeState.isCreatingNew) {
      navigationData['forceReset'] = true;
      navigationData['isNewForm'] = true;
    } else {
      navigationData['loadSavedForm'] = true;
      navigationData['formId'] = currentHomeState.activeFormId;
    }

    context.go('/risk_threat_analysis', extra: navigationData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
          builder: (context, riskState) {
            final selectedEvent = homeState.selectedRiskEvent;
            final homeBloc = context.read<HomeBloc>();
            final classifications = homeBloc.getEventClassifications(
              selectedEvent ?? '',
            );

            // Crear mapas de estados para cada categoría
            final categoryStates = <String, CategoryState>{};
            for (final classification in classifications) {
              final state = _getCategoryState(
                classification,
                homeState,
                context,
                riskState,
                homeState.navigationData?.progressData, // Pasar el progreso desde navigationData
              );
              categoryStates[classification] = state;
            }

            return RiskCategoriesContent(
              classifications: classifications,
              selectedEvent: selectedEvent ?? '',
              categoryStates: categoryStates,
              onCategoryTap: _navigateToCategory,
              homeState: homeState,
            );
          },
        );
      },
    );
  }
}
