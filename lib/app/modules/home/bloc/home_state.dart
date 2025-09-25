import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final bool mostrarEventosRiesgo;
  final bool mostrarCategoriasRiesgo;
  final bool tutorialShown;
  final bool showTutorial;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final String selectedRiskEvent;
  final String? selectedRiskCategory;

  const HomeState({
    required this.selectedIndex,
    required this.mostrarEventosRiesgo,
    required this.mostrarCategoriasRiesgo,
    required this.tutorialShown,
    this.showTutorial = true,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.selectedLanguage = 'Español',
    this.selectedRiskEvent = 'Movimiento en Masa',
    this.selectedRiskCategory,
  });

  HomeState copyWith({
    int? selectedIndex,
    bool? mostrarEventosRiesgo,
    bool? mostrarCategoriasRiesgo,
    bool? tutorialShown,
    bool? showTutorial,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
    String? selectedRiskEvent,
    String? selectedRiskCategory,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mostrarEventosRiesgo: mostrarEventosRiesgo ?? this.mostrarEventosRiesgo,
      mostrarCategoriasRiesgo: mostrarCategoriasRiesgo ?? this.mostrarCategoriasRiesgo,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      showTutorial: showTutorial ?? this.showTutorial,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedRiskEvent: selectedRiskEvent ?? this.selectedRiskEvent,
      selectedRiskCategory: selectedRiskCategory ?? this.selectedRiskCategory,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, mostrarEventosRiesgo, mostrarCategoriasRiesgo, tutorialShown, showTutorial, notificationsEnabled, darkModeEnabled, selectedLanguage, selectedRiskEvent, selectedRiskCategory];
}