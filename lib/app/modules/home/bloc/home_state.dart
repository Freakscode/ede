import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final bool mostrarEventosRiesgo;
  final bool tutorialShown;

  const HomeState({
    required this.selectedIndex,
    required this.mostrarEventosRiesgo,
    required this.tutorialShown,
  });

  HomeState copyWith({
    int? selectedIndex,
    bool? mostrarEventosRiesgo,
    bool? tutorialShown,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mostrarEventosRiesgo: mostrarEventosRiesgo ?? this.mostrarEventosRiesgo,
      tutorialShown: tutorialShown ?? this.tutorialShown,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, mostrarEventosRiesgo, tutorialShown];
}