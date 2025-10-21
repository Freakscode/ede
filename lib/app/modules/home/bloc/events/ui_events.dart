import 'home_event.dart';

/// Evento para verificar y mostrar tutorial
class HomeCheckAndShowTutorial extends HomeEvent {
  const HomeCheckAndShowTutorial();
}

/// Evento para establecer mostrar tutorial
class HomeSetShowTutorial extends HomeEvent {
  final bool value;
  const HomeSetShowTutorial(this.value);

  @override
  List<Object?> get props => [value];
}

/// Evento para alternar notificaciones
class HomeToggleNotifications extends HomeEvent {
  final bool enabled;
  const HomeToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Evento para alternar modo oscuro
class HomeToggleDarkMode extends HomeEvent {
  final bool enabled;
  const HomeToggleDarkMode(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Evento para cambiar idioma
class HomeChangeLanguage extends HomeEvent {
  final String language;
  const HomeChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

/// Evento para limpiar datos
class HomeClearData extends HomeEvent {
  const HomeClearData();
}