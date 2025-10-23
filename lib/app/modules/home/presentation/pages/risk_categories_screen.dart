import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_container.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';

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
  ) {
    final isAmenaza = classification.toLowerCase() == 'amenaza';
    final isVulnerabilidad = classification.toLowerCase() == 'vulnerabilidad';
    final isEditMode =
        homeState.activeFormId != null && !homeState.isCreatingNew;

    if (isAmenaza) {
      return _getAmenazaState(context);
    } else if (isVulnerabilidad) {
      return _getVulnerabilidadState(homeState, context, isEditMode);
    }

    return const CategoryState(isAvailable: false, isCompleted: false);
  }

  // Estado específico para Amenaza
  CategoryState _getAmenazaState(BuildContext context) {
    bool isCompleted = false;
    bool isInProgress = false;

    try {
      final riskBloc = context.read<RiskThreatAnalysisBloc>();
      final state = riskBloc.state;

      // Verificar si hay datos básicos
      final hasProbabilidadSelections = state.probabilidadSelections.isNotEmpty;
      final hasIntensidadSelections = state.intensidadSelections.isNotEmpty;
      final hasEvidence = state.evidenceImages.isNotEmpty;

      // Lógica simplificada: está completa si tiene datos y evidencia
      isCompleted =
          (hasProbabilidadSelections || hasIntensidadSelections) && hasEvidence;

      // Está en progreso si tiene algunos datos pero no está completa
      isInProgress =
          (hasProbabilidadSelections ||
              hasIntensidadSelections ||
              hasEvidence) &&
          !isCompleted;
    } catch (e) {
      isCompleted = false;
      isInProgress = false;
    }

    return CategoryState(
      isAvailable: true,
      isCompleted: isCompleted,
      isInProgress: isInProgress,
    );
  }

  // Estado específico para Vulnerabilidad
  CategoryState _getVulnerabilidadState(
    HomeState homeState,
    BuildContext context,
    bool isEditMode,
  ) {
    if (isEditMode) {
      return _getVulnerabilidadEditMode(homeState, context);
    } else {
      return _getVulnerabilidadCreateMode(homeState, context);
    }
  }

  // Estado de Vulnerabilidad en modo edición
  CategoryState _getVulnerabilidadEditMode(
    HomeState homeState,
    BuildContext context,
  ) {
    final isAvailable = homeState.activeFormId != null;
    bool isCompleted = false;
    bool isInProgress = false;

    if (isAvailable) {
      try {
        final riskBloc = context.read<RiskThreatAnalysisBloc>();
        final state = riskBloc.state;

        // Verificar si hay selecciones de vulnerabilidad
        final hasVulnerabilidadSelections = state.dynamicSelections.isNotEmpty;
        final hasEvidence = state.evidenceImages.isNotEmpty;

        // Lógica simplificada: está completa si tiene datos de vulnerabilidad y evidencia
        isCompleted = hasVulnerabilidadSelections && hasEvidence;

        // Verificar si está en progreso (tiene algunas selecciones pero no está completa)
        isInProgress =
            (hasVulnerabilidadSelections || hasEvidence) && !isCompleted;
      } catch (e) {
        isCompleted = false;
        isInProgress = false;
      }
    }

    return CategoryState(
      isAvailable: isAvailable,
      isCompleted: isCompleted,
      isInProgress: isInProgress,
      disabledMessage: isAvailable ? null : 'No hay formulario activo',
    );
  }

  // Estado de Vulnerabilidad en modo creación
  CategoryState _getVulnerabilidadCreateMode(
    HomeState homeState,
    BuildContext context,
  ) {
    bool amenazaCompleted = false;

    try {
      final riskBloc = context.read<RiskThreatAnalysisBloc>();
      final hasUnqualifiedAmenaza = riskBloc.hasUnqualifiedVariables();
      final hasEvidence = riskBloc.state.evidenceImages.isNotEmpty;
      amenazaCompleted = !hasUnqualifiedAmenaza && hasEvidence;
    } catch (e) {
      amenazaCompleted = false;
    }

    final isAvailable = amenazaCompleted && homeState.activeFormId != null;
    bool isCompleted = false;
    bool isInProgress = false;
    String? disabledMessage;

    if (!isAvailable) {
      disabledMessage = amenazaCompleted
          ? 'No hay formulario activo'
          : 'Complete primero la calificación de Amenaza';
    } else {
      try {
        final riskBloc = context.read<RiskThreatAnalysisBloc>();
        final state = riskBloc.state;

        // Verificar si hay selecciones de vulnerabilidad
        final hasVulnerabilidadSelections = state.dynamicSelections.isNotEmpty;
        final hasEvidence = state.evidenceImages.isNotEmpty;

        // Lógica simplificada: está completa si tiene datos de vulnerabilidad y evidencia
        isCompleted = hasVulnerabilidadSelections && hasEvidence;

        // Verificar si está en progreso (tiene algunas selecciones pero no está completa)
        isInProgress =
            (hasVulnerabilidadSelections || hasEvidence) && !isCompleted;
      } catch (e) {
        isCompleted = false;
        isInProgress = false;
      }
    }

    return CategoryState(
      isAvailable: isAvailable,
      isCompleted: isCompleted,
      isInProgress: isInProgress,
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
        final selectedEvent = homeState.selectedRiskEvent;
        final homeBloc = context.read<HomeBloc>();
        final classifications = homeBloc.getEventClassifications(
          selectedEvent ?? '',
        );

        // Crear mapas de estados para cada categoría
        final categoryStates = <String, CategoryState>{};
        for (final classification in classifications) {
          categoryStates[classification] = _getCategoryState(
            classification,
            homeState,
            context,
          );
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
  }
}
