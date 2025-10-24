import 'package:equatable/equatable.dart';
import 'form_entity.dart';

/// Entidad principal del módulo Home
/// Representa el estado del dominio de la aplicación home
class HomeEntity extends Equatable {
  final int selectedIndex;
  final bool showRiskEvents;
  final bool showRiskCategories;
  final bool showFormCompleted;
  final bool tutorialShown;
  final bool showTutorial;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final String selectedRiskEvent;
  final String? selectedRiskCategory;
  final Map<String, bool> completedEvaluations;
  final List<FormEntity> savedForms;
  final bool isLoadingForms;
  final String? activeFormId;
  final bool isCreatingNew;
  final Map<String, Map<String, dynamic>> savedRiskEventModels;

  const HomeEntity({
    required this.selectedIndex,
    required this.showRiskEvents,
    required this.showRiskCategories,
    required this.showFormCompleted,
    required this.tutorialShown,
    this.showTutorial = true,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.selectedLanguage = 'Español',
    this.selectedRiskEvent = 'Movimiento en Masa',
    this.selectedRiskCategory,
    this.completedEvaluations = const {},
    this.savedForms = const [],
    this.isLoadingForms = false,
    this.activeFormId,
    this.isCreatingNew = true,
    this.savedRiskEventModels = const {},
  });

  /// Factory constructor para crear estado inicial
  factory HomeEntity.initial() {
    return const HomeEntity(
      selectedIndex: 0,
      showRiskEvents: false,
      showRiskCategories: false,
      showFormCompleted: false,
      tutorialShown: false,
    );
  }

  /// Copia con cambios
  HomeEntity copyWith({
    int? selectedIndex,
    bool? showRiskEvents,
    bool? showRiskCategories,
    bool? showFormCompleted,
    bool? tutorialShown,
    bool? showTutorial,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
    String? selectedRiskEvent,
    String? selectedRiskCategory,
    Map<String, bool>? completedEvaluations,
    List<FormEntity>? savedForms,
    bool? isLoadingForms,
    String? activeFormId,
    bool? isCreatingNew,
    Map<String, Map<String, dynamic>>? savedRiskEventModels,
  }) {
    return HomeEntity(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      showRiskEvents: showRiskEvents ?? this.showRiskEvents,
      showRiskCategories: showRiskCategories ?? this.showRiskCategories,
      showFormCompleted: showFormCompleted ?? this.showFormCompleted,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      showTutorial: showTutorial ?? this.showTutorial,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedRiskEvent: selectedRiskEvent ?? this.selectedRiskEvent,
      selectedRiskCategory: selectedRiskCategory ?? this.selectedRiskCategory,
      completedEvaluations: completedEvaluations ?? this.completedEvaluations,
      savedForms: savedForms ?? this.savedForms,
      isLoadingForms: isLoadingForms ?? this.isLoadingForms,
      activeFormId: activeFormId ?? this.activeFormId,
      isCreatingNew: isCreatingNew ?? this.isCreatingNew,
      savedRiskEventModels: savedRiskEventModels ?? this.savedRiskEventModels,
    );
  }

  /// Lógica de negocio: ¿Está mostrando alguna sección especial?
  bool get isShowingSpecialSection => 
      showRiskEvents || showRiskCategories || showFormCompleted;

  /// Lógica de negocio: ¿Está en modo creación de formulario?
  bool get isInFormCreationMode => isCreatingNew && activeFormId == null;

  /// Lógica de negocio: ¿Está en modo edición de formulario?
  bool get isInFormEditMode => !isCreatingNew && activeFormId != null;

  /// Lógica de negocio: Obtener formularios en progreso
  List<FormEntity> get inProgressForms => 
      savedForms.where((form) => form.status == FormStatus.inProgress).toList();

  /// Lógica de negocio: Obtener formularios completados
  List<FormEntity> get completedForms => 
      savedForms.where((form) => form.status == FormStatus.completed).toList();

  /// Lógica de negocio: ¿Está una evaluación completada?
  bool isEvaluationCompleted(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return completedEvaluations[key] ?? false;
  }

  /// Lógica de negocio: ¿Está completada la amenaza?
  bool isAmenazaCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'amenaza');
  }

  /// Lógica de negocio: ¿Está completada la vulnerabilidad?
  bool isVulnerabilidadCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'vulnerabilidad');
  }

  /// Lógica de negocio: ¿Tiene un evento completo (amenaza + vulnerabilidad)?
  bool hasCompleteRiskEventModel(String eventName) {
    return isAmenazaCompleted(eventName) && isVulnerabilidadCompleted(eventName);
  }

  /// Lógica de negocio: Obtener datos guardados de un RiskEventModel
  Map<String, dynamic>? getSavedRiskEventModel(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return savedRiskEventModels[key];
  }

  /// Lógica de negocio: Obtener todos los datos guardados para un evento
  Map<String, Map<String, dynamic>> getSavedModelsForEvent(String eventName) {
    return Map.fromEntries(
      savedRiskEventModels.entries
          .where((entry) => entry.key.startsWith('${eventName}_'))
    );
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        showRiskEvents,
        showRiskCategories,
        showFormCompleted,
        tutorialShown,
        showTutorial,
        notificationsEnabled,
        darkModeEnabled,
        selectedLanguage,
        selectedRiskEvent,
        selectedRiskCategory,
        completedEvaluations,
        savedForms,
        isLoadingForms,
        activeFormId,
        isCreatingNew,
        savedRiskEventModels,
      ];
}
