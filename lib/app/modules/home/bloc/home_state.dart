import 'package:equatable/equatable.dart';
import '../../../shared/models/form_data_model.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final bool mostrarEventosRiesgo;
  final bool mostrarCategoriasRiesgo;
  final bool mostrarFormularioCompletado;
  final bool tutorialShown;
  final bool showTutorial;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final String selectedRiskEvent;
  final String? selectedRiskCategory;
  final Map<String, bool> completedEvaluations; // Track de evaluaciones completadas por evento
  
  // ======= NUEVOS CAMPOS PARA GESTIÓN DE FORMULARIOS =======
  final List<FormDataModel> savedForms;
  final bool isLoadingForms;
  final String? activeFormId;
  final bool isCreatingNew; // true = crear nuevo, false = editar existente
  
  // ======= CAMPOS PARA GUARDAR RISKEVENTMODEL =======
  final Map<String, Map<String, dynamic>> savedRiskEventModels; // Guardar RiskEventModel por evento y clasificación

  const HomeState({
    required this.selectedIndex,
    required this.mostrarEventosRiesgo,
    required this.mostrarCategoriasRiesgo,
    required this.mostrarFormularioCompletado,
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
    this.isCreatingNew = true, // Por defecto, crear nuevo
    this.savedRiskEventModels = const {},
  });

  HomeState copyWith({
    int? selectedIndex,
    bool? mostrarEventosRiesgo,
    bool? mostrarCategoriasRiesgo,
    bool? mostrarFormularioCompletado,
    bool? tutorialShown,
    bool? showTutorial,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
    String? selectedRiskEvent,
    String? selectedRiskCategory,
    Map<String, bool>? completedEvaluations,
    List<FormDataModel>? savedForms,
    bool? isLoadingForms,
    String? activeFormId,
    bool? isCreatingNew,
    Map<String, Map<String, dynamic>>? savedRiskEventModels,
  }) {
    print('=== HomeState copyWith DEBUG ===');
    print('Estado actual:');
    print('  - activeFormId: $activeFormId');
    print('  - isCreatingNew: $isCreatingNew');
    print('Parámetros recibidos:');
    print('  - activeFormId: $activeFormId');
    print('  - isCreatingNew: $isCreatingNew');
    
    final newState = HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mostrarEventosRiesgo: mostrarEventosRiesgo ?? this.mostrarEventosRiesgo,
      mostrarCategoriasRiesgo: mostrarCategoriasRiesgo ?? this.mostrarCategoriasRiesgo,
      mostrarFormularioCompletado: mostrarFormularioCompletado ?? this.mostrarFormularioCompletado,
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
    
    print('Nuevo estado:');
    print('  - activeFormId: ${newState.activeFormId}');
    print('  - isCreatingNew: ${newState.isCreatingNew}');
    print('=== FIN HomeState copyWith DEBUG ===');
    
    return newState;
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        mostrarEventosRiesgo,
        mostrarCategoriasRiesgo,
        mostrarFormularioCompletado,
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

  // Métodos de conveniencia para filtrar formularios
  List<FormDataModel> get inProgressForms => 
      savedForms.where((form) => form.status == FormStatus.inProgress).toList();

  List<FormDataModel> get completedForms => 
      savedForms.where((form) => form.status == FormStatus.completed).toList();

  List<FormDataModel> get riskAnalysisForms => 
      savedForms; // Temporal: retornar todos los formularios
}