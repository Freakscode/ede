/// Tipos de navegación disponibles para volver al HomeScreen
enum HomeNavigationType {
  /// Mostrar categorías de riesgo
  riskCategories,
  /// Mostrar eventos de riesgo
  riskEvents,
  /// Ir a pestaña específica del bottom navigation
  tabIndex,
  /// Ir al home principal (por defecto)
  home,
}

/// Extensión para convertir enum a Map para navegación
extension HomeNavigationTypeExtension on HomeNavigationType {
  Map<String, dynamic> toNavigationData({int? tabIndex}) {
    switch (this) {
      case HomeNavigationType.riskCategories:
        return {'showRiskCategories': true};
      case HomeNavigationType.riskEvents:
        return {'showRiskEvents': true};
      case HomeNavigationType.tabIndex:
        return {'selectedIndex': tabIndex ?? 0};
      case HomeNavigationType.home:
        return {};
    }
  }
}