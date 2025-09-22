import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeNavBarTapped extends HomeEvent {
  final int index;
  const HomeNavBarTapped(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeShowRiskEventsSection extends HomeEvent {}

class HomeShowRiskCategoriesScreen extends HomeEvent {}

class HomeResetRiskSections extends HomeEvent {}

class HomeCheckAndShowTutorial extends HomeEvent {}

class HomeSetShowTutorial extends HomeEvent {
  final bool value;
  const HomeSetShowTutorial(this.value);

  @override
  List<Object?> get props => [value];
}

class HomeToggleNotifications extends HomeEvent {
  final bool enabled;
  const HomeToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class HomeToggleDarkMode extends HomeEvent {
  final bool enabled;
  const HomeToggleDarkMode(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class HomeChangeLanguage extends HomeEvent {
  final String language;
  const HomeChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class HomeClearData extends HomeEvent {}