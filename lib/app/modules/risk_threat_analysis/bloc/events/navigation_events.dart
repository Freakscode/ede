import 'risk_threat_analysis_event.dart';

/// Eventos de navegación
/// Sigue el principio de responsabilidad única (SRP)
abstract class NavigationEvent extends RiskThreatAnalysisEvent {
  const NavigationEvent();
}

/// Evento para cambiar índice de navegación inferior
class ChangeBottomNavIndex extends NavigationEvent {
  final int index;
  
  const ChangeBottomNavIndex(this.index);

  @override
  List<Object?> get props => [index];
}

/// Evento para mostrar resultados finales
class ShowFinalResults extends NavigationEvent {
  final bool show;
  
  const ShowFinalResults(this.show);

  @override
  List<Object?> get props => [show];
}
