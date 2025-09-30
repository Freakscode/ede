enum HomeNavigationType {
  riskCategories,
  riskEvents,
  tabIndex,
  home,
}

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