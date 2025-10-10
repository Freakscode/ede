import 'package:caja_herramientas/app/modules/home/models/domain/form_navigation_data.dart';
import 'home_event.dart';

/// Evento para navegación en la barra inferior
class HomeNavBarTapped extends HomeEvent {
  final int index;
  const HomeNavBarTapped(this.index);

  @override
  List<Object?> get props => [index];
}

/// Evento para mostrar sección de eventos de riesgo
class HomeShowRiskEventsSection extends HomeEvent {
  const HomeShowRiskEventsSection();
}

/// Evento para mostrar pantalla de categorías de riesgo
class HomeShowRiskCategoriesScreen extends HomeEvent {
  final FormNavigationData navigationData;
  
  const HomeShowRiskCategoriesScreen(this.navigationData);

  @override
  List<Object?> get props => [navigationData];
}

/// Evento para seleccionar evento de riesgo
class SelectRiskEvent extends HomeEvent {
  final String eventName;
  const SelectRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

/// Evento para seleccionar categoría de riesgo
class SelectRiskCategory extends HomeEvent {
  final String categoryType; // 'Amenaza' o 'Vulnerabilidad'
  final String eventName; // El evento asociado
  const SelectRiskCategory(this.categoryType, this.eventName);

  @override
  List<Object?> get props => [categoryType, eventName];
}

/// Evento para resetear secciones de riesgo
class HomeResetRiskSections extends HomeEvent {
  const HomeResetRiskSections();
}

/// Evento para mostrar pantalla de formulario completado
class HomeShowFormCompletedScreen extends HomeEvent {
  const HomeShowFormCompletedScreen();
}
