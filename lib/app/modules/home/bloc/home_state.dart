import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final bool mostrarEventosRiesgo;
  final bool tutorialShown;
  final bool showTutorial;

  const HomeState({
    required this.selectedIndex,
    required this.mostrarEventosRiesgo,
    required this.tutorialShown,
    this.showTutorial = true,
  });

  HomeState copyWith({
    int? selectedIndex,
    bool? mostrarEventosRiesgo,
    bool? tutorialShown,
    bool? showTutorial,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mostrarEventosRiesgo: mostrarEventosRiesgo ?? this.mostrarEventosRiesgo,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      showTutorial: showTutorial ?? this.showTutorial,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, mostrarEventosRiesgo, tutorialShown, showTutorial];
}