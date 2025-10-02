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

class SelectRiskEvent extends HomeEvent {
  final String eventName;
  const SelectRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

class SelectRiskCategory extends HomeEvent {
  final String categoryType; // 'Amenaza' o 'Vulnerabilidad'
  final String eventName; // El evento asociado
  const SelectRiskCategory(this.categoryType, this.eventName);

  @override
  List<Object?> get props => [categoryType, eventName];
}

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

class MarkEvaluationCompleted extends HomeEvent {
  final String eventName;
  final String classificationType; // 'amenaza' o 'vulnerabilidad'
  
  const MarkEvaluationCompleted(this.eventName, this.classificationType);

  @override
  List<Object?> get props => [eventName, classificationType];
}