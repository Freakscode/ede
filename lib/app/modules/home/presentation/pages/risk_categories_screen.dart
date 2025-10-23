import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_categories_container.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';


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
    final isEditMode = homeState.activeFormId != null && !homeState.isCreatingNew;

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
    
    try {
      final riskBloc = context.read<RiskThreatAnalysisBloc>();
      final hasUnqualified = riskBloc.hasUnqualifiedVariables();
      final hasEvidence = riskBloc.state.evidenceImages.isNotEmpty;
      isCompleted = !hasUnqualified && hasEvidence;
    } catch (e) {
      isCompleted = false;
    }

    return CategoryState(
      isAvailable: true,
      isCompleted: isCompleted,
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

    if (isAvailable) {
      try {
        final riskBloc = context.read<RiskThreatAnalysisBloc>();
        final currentClassification = riskBloc.state.selectedClassification;
        
        if (currentClassification != 'vulnerabilidad') {
          riskBloc.add(const SelectClassification('vulnerabilidad'));
        }
        
        final hasUnqualified = riskBloc.hasUnqualifiedVariables();
        final hasEvidence = riskBloc.state.evidenceImages.isNotEmpty;
        isCompleted = !hasUnqualified && hasEvidence;
        
        if (currentClassification != 'vulnerabilidad') {
          riskBloc.add(SelectClassification(currentClassification));
        }
      } catch (e) {
        isCompleted = false;
      }
    }

    return CategoryState(
      isAvailable: isAvailable,
      isCompleted: isCompleted,
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
    String? disabledMessage;

    if (!isAvailable) {
      disabledMessage = amenazaCompleted 
          ? 'No hay formulario activo'
          : 'Complete primero la calificación de Amenaza';
    } else {
      try {
        final riskBloc = context.read<RiskThreatAnalysisBloc>();
        final currentClassification = riskBloc.state.selectedClassification;
        
        if (currentClassification != 'vulnerabilidad') {
          riskBloc.add(const SelectClassification('vulnerabilidad'));
        }
        
        final hasUnqualified = riskBloc.hasUnqualifiedVariables();
        final hasEvidence = riskBloc.state.evidenceImages.isNotEmpty;
        isCompleted = !hasUnqualified && hasEvidence;
        
        if (currentClassification != 'vulnerabilidad') {
          riskBloc.add(SelectClassification(currentClassification));
        }
      } catch (e) {
        isCompleted = false;
      }
    }

    return CategoryState(
      isAvailable: isAvailable,
      isCompleted: isCompleted,
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

    final navigationData = <String, dynamic>{
      'event': selectedEvent,
      'classification': classification.toLowerCase(),
      'directToResults': isCompleted,
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
        final classifications = homeBloc.getEventClassifications(selectedEvent);

        // Crear mapas de estados para cada categoría
        final categoryStates = <String, CategoryState>{};
        for (final classification in classifications) {
          categoryStates[classification] = _getCategoryState(classification, homeState, context);
        }

        return RiskCategoriesContent(
          classifications: classifications,
          selectedEvent: selectedEvent,
          categoryStates: categoryStates,
          onCategoryTap: _navigateToCategory,
          homeState: homeState,
        );
      },
    );
  }
}
