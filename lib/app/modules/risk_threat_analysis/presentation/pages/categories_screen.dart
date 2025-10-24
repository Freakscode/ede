import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/widgets/risk_categories_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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

    return const CategoryState(progressPercentage: 0);
  }

  // Estado específico para Amenaza
  CategoryState _getAmenazaState(BuildContext context, RiskThreatAnalysisState riskState, Map<String, double>? progressData) {
    int progressPercentage = 0;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['amenaza'] != null) {
      progressPercentage = (progressData['amenaza']! * 100).round();
    }

    return CategoryState(
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
    int progressPercentage = 0;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['vulnerabilidad'] != null) {
      progressPercentage = (progressData['vulnerabilidad']! * 100).round();
    }

    return CategoryState(
      progressPercentage: progressPercentage,
    );
  }

  // Estado de Vulnerabilidad en modo creación
  CategoryState _getVulnerabilidadCreateMode(
    HomeState homeState,
    BuildContext context,
    RiskThreatAnalysisState riskState,
    Map<String, double>? progressData,
  ) {
    int progressPercentage = 0;

    // Usar el progreso pasado como parámetro si está disponible
    if (progressData != null && progressData['vulnerabilidad'] != null) {
      progressPercentage = (progressData['vulnerabilidad']! * 100).round();
    }

    return CategoryState(
      progressPercentage: progressPercentage,
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
    
    // SIEMPRE ir al RatingScreen (índice 0) desde CategoriesScreen
    riskBloc.add(ChangeBottomNavIndex(0));

    final navigationData = <String, dynamic>{
      'event': selectedEvent,
      'classification': classification.toLowerCase(),
      'targetIndex': 0, // SIEMPRE RatingScreen
      'source': 'CategoriesScreen',
    };

    // Configurar datos de navegación según el modo
    if (currentHomeState.isCreatingNew) {
      navigationData['forceReset'] = true;
      navigationData['isNewForm'] = true;
    } else {
      navigationData['loadSavedForm'] = true;
      navigationData['formId'] = currentHomeState.activeFormId;
    }

    context.go('/risk-threat-analysis', extra: navigationData);
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
              // Obtener el progreso desde navigationData o desde el estado guardado
              Map<String, double>? progressData = homeState.navigationData?.progressData;
              if (progressData == null && homeState.activeFormId != null) {
                progressData = homeState.getFormProgress(homeState.activeFormId!);
              }
              
              final state = _getCategoryState(
                classification,
                homeState,
                context,
                riskState,
                progressData,
              );
              categoryStates[classification] = state;
            }

            return RiskCategoriesContent(
              selectedEvent: selectedEvent ?? '',
              onCategoryTap: _navigateToCategory,
              getCategoryState: (classification) {
                // Obtener el progreso desde navigationData o desde el estado guardado
                Map<String, double>? progressData = homeState.navigationData?.progressData;
                if (progressData == null && homeState.activeFormId != null) {
                  progressData = homeState.getFormProgress(homeState.activeFormId!);
                }
                
                return _getCategoryState(
                  classification,
                  homeState,
                  context,
                  riskState,
                  progressData,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Estado de una categoría
class CategoryState {
  final int progressPercentage;

  const CategoryState({required this.progressPercentage});
}
