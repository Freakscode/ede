import 'package:equatable/equatable.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../../domain/entities/form_navigation_data.dart';

/// Estado de presentación para el módulo Home
/// Representa el estado de la UI, separado de la lógica de negocio
class HomeState extends Equatable {
  final int selectedIndex;
  final bool showRiskEvents;
  final bool showFormCompleted;
  final bool tutorialShown;
  final bool showTutorial;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final String? selectedRiskEvent;
  final Map<String, bool> completedEvaluations;
  final List<FormEntity> savedForms;
  final bool isLoadingForms;
  final String? activeFormId;
  final bool isCreatingNew;
  final Map<String, Map<String, dynamic>> savedRiskEventModels;
  final FormNavigationData? navigationData;
  final Map<String, Map<String, double>> formProgressData;
  
  // Estados de UI específicos
  final bool isLoading;
  final String? error;
  final bool hasError;

  const HomeState({
    required this.selectedIndex,
    required this.showRiskEvents,
    required this.showFormCompleted,
    required this.tutorialShown,
    this.showTutorial = true,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.selectedLanguage = 'Español',
    this.selectedRiskEvent,
    this.completedEvaluations = const {},
    this.savedForms = const [],
    this.isLoadingForms = false,
    this.activeFormId,
    this.isCreatingNew = true,
    this.savedRiskEventModels = const {},
    this.navigationData,
    this.formProgressData = const {},
    this.isLoading = false,
    this.error,
    this.hasError = false,
  });

  /// Factory constructor para estado inicial
  factory HomeState.initial() {
    return HomeState(
      selectedIndex: 0,
      showRiskEvents: false,
      showFormCompleted: false,
      tutorialShown: false,
    );
  }

  /// Factory constructor desde entidad de dominio
  factory HomeState.fromEntity(HomeEntity entity) {
    return HomeState(
      selectedIndex: entity.selectedIndex,
      showRiskEvents: entity.showRiskEvents,
      showFormCompleted: entity.showFormCompleted,
      tutorialShown: entity.tutorialShown,
      showTutorial: entity.showTutorial,
      notificationsEnabled: entity.notificationsEnabled,
      darkModeEnabled: entity.darkModeEnabled,
      selectedLanguage: entity.selectedLanguage,
      selectedRiskEvent: entity.selectedRiskEvent,
      completedEvaluations: entity.completedEvaluations,
      savedForms: entity.savedForms,
      isLoadingForms: entity.isLoadingForms,
      activeFormId: entity.activeFormId,
      isCreatingNew: entity.isCreatingNew,
      savedRiskEventModels: entity.savedRiskEventModels,
    );
  }

  /// Convertir a entidad de dominio
  HomeEntity toEntity() {
    return HomeEntity(
      selectedIndex: selectedIndex,
      showRiskEvents: showRiskEvents,
      showFormCompleted: showFormCompleted,
      tutorialShown: tutorialShown,
      showTutorial: showTutorial,
      notificationsEnabled: notificationsEnabled,
      darkModeEnabled: darkModeEnabled,
      selectedLanguage: selectedLanguage,
      selectedRiskEvent: selectedRiskEvent,
      completedEvaluations: completedEvaluations,
      savedForms: savedForms,
      isLoadingForms: isLoadingForms,
      activeFormId: activeFormId,
      isCreatingNew: isCreatingNew,
      savedRiskEventModels: savedRiskEventModels,
    );
  }

  /// Copia con cambios
  HomeState copyWith({
    int? selectedIndex,
    bool? showRiskEvents,
    bool? showFormCompleted,
    bool? tutorialShown,
    bool? showTutorial,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
    String? selectedRiskEvent,
    Map<String, bool>? completedEvaluations,
    List<FormEntity>? savedForms,
    bool? isLoadingForms,
    String? activeFormId,
    bool? isCreatingNew,
    Map<String, Map<String, dynamic>>? savedRiskEventModels,
    FormNavigationData? navigationData,
    Map<String, Map<String, double>>? formProgressData,
    bool? isLoading,
    String? error,
    bool? hasError,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      showRiskEvents: showRiskEvents ?? this.showRiskEvents,
      showFormCompleted: showFormCompleted ?? this.showFormCompleted,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      showTutorial: showTutorial ?? this.showTutorial,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedRiskEvent: selectedRiskEvent ?? this.selectedRiskEvent,
      completedEvaluations: completedEvaluations ?? this.completedEvaluations,
      savedForms: savedForms ?? this.savedForms,
      isLoadingForms: isLoadingForms ?? this.isLoadingForms,
      activeFormId: activeFormId ?? this.activeFormId,
      isCreatingNew: isCreatingNew ?? this.isCreatingNew,
      savedRiskEventModels: savedRiskEventModels ?? this.savedRiskEventModels,
      navigationData: navigationData ?? this.navigationData,
      formProgressData: formProgressData ?? this.formProgressData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasError: hasError ?? this.hasError,
    );
  }

  /// Limpiar error
  HomeState clearError() {
    return copyWith(
      error: null,
      hasError: false,
    );
  }

  /// Establecer error
  HomeState setError(String error) {
    return copyWith(
      error: error,
      hasError: true,
    );
  }

  /// Establecer estado de carga
  HomeState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  // ========== COMPUTED PROPERTIES ==========

  /// ¿Está mostrando alguna sección especial?
  bool get isShowingSpecialSection => 
      showRiskEvents || showFormCompleted;

  /// ¿Está en modo creación de formulario?
  bool get isInFormCreationMode => isCreatingNew && activeFormId == null;

  /// ¿Está en modo edición de formulario?
  bool get isInFormEditMode => !isCreatingNew && activeFormId != null;

  /// Obtener formularios en progreso
  List<FormEntity> get inProgressForms => 
      savedForms.where((form) => form.status == FormStatus.inProgress).toList();

  /// Obtener formularios completados
  List<FormEntity> get completedForms => 
      savedForms.where((form) => form.status == FormStatus.completed).toList();

  /// ¿Está una evaluación completada?
  bool isEvaluationCompleted(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return completedEvaluations[key] ?? false;
  }

  /// ¿Está completada la amenaza?
  bool isAmenazaCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'amenaza');
  }

  /// ¿Está completada la vulnerabilidad?
  bool isVulnerabilidadCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'vulnerabilidad');
  }

  /// ¿Tiene un evento completo (amenaza + vulnerabilidad)?
  bool hasCompleteRiskEventModel(String eventName) {
    return isAmenazaCompleted(eventName) && isVulnerabilidadCompleted(eventName);
  }

  /// Obtener datos guardados de un RiskEventModel
  Map<String, dynamic>? getSavedRiskEventModel(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return savedRiskEventModels[key];
  }

  /// Obtener todos los datos guardados para un evento
  Map<String, Map<String, dynamic>> getSavedModelsForEvent(String eventName) {
    return Map.fromEntries(
      savedRiskEventModels.entries
          .where((entry) => entry.key.startsWith('${eventName}_'))
    );
  }

  /// Obtener el progreso de un formulario
  Map<String, double>? getFormProgress(String formId) {
    return formProgressData[formId];
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        showRiskEvents,
        showFormCompleted,
        tutorialShown,
        showTutorial,
        notificationsEnabled,
        darkModeEnabled,
        selectedLanguage,
        selectedRiskEvent,
        completedEvaluations,
        savedForms,
        isLoadingForms,
        activeFormId,
        isCreatingNew,
        savedRiskEventModels,
        navigationData,
        formProgressData,
        isLoading,
        error,
        hasError,
      ];

  @override
  String toString() {
    return 'HomeState(selectedIndex: $selectedIndex, showRiskEvents: $showRiskEvents, '
           'showFormCompleted: $showFormCompleted, tutorialShown: $tutorialShown, '
           'isLoading: $isLoading, hasError: $hasError)';
  }
}
