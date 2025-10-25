import 'package:equatable/equatable.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/form_entity.dart';

/// Modelo de datos para Home
/// Mapea entre la entidad de dominio y los datos persistentes
class HomeModel extends Equatable {
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

  const HomeModel({
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
  });

  /// Factory constructor desde entidad de dominio
  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(
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

  /// Factory constructor desde JSON
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      selectedIndex: json['selectedIndex'] ?? 0,
      showRiskEvents: json['showRiskEvents'] ?? false,
      showFormCompleted: json['showFormCompleted'] ?? false,
      tutorialShown: json['tutorialShown'] ?? false,
      showTutorial: json['showTutorial'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      selectedLanguage: json['selectedLanguage'] ?? 'Español',
      selectedRiskEvent: json['selectedRiskEvent'],
      completedEvaluations: Map<String, bool>.from(json['completedEvaluations'] ?? {}),
      savedForms: (json['savedForms'] as List?)
          ?.map((form) => FormEntity.fromJson(form))
          .toList() ?? [],
      isLoadingForms: json['isLoadingForms'] ?? false,
      activeFormId: json['activeFormId'],
      isCreatingNew: json['isCreatingNew'] ?? true,
      savedRiskEventModels: Map<String, Map<String, dynamic>>.from(
        json['savedRiskEventModels'] ?? {}
      ),
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedIndex': selectedIndex,
      'showRiskEvents': showRiskEvents,
      'showFormCompleted': showFormCompleted,
      'tutorialShown': tutorialShown,
      'showTutorial': showTutorial,
      'notificationsEnabled': notificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'selectedLanguage': selectedLanguage,
      'selectedRiskEvent': selectedRiskEvent,
      'completedEvaluations': completedEvaluations,
      'savedForms': savedForms.map((form) => form.toJson()).toList(),
      'isLoadingForms': isLoadingForms,
      'activeFormId': activeFormId,
      'isCreatingNew': isCreatingNew,
      'savedRiskEventModels': savedRiskEventModels,
    };
  }

  /// Copia con cambios
  HomeModel copyWith({
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
  }) {
    return HomeModel(
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
    );
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
      ];
}
