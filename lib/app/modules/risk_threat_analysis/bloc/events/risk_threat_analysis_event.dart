// Re-exportar todos los eventos específicos
export 'navigation_events.dart';
export 'dropdown_events.dart';
export 'selection_events.dart';
export 'form_events.dart';
export 'risk_events.dart';
export 'evidence_events.dart';

import 'package:equatable/equatable.dart';

/// Evento base para el módulo RiskThreatAnalysis
/// Agrupa todos los eventos específicos
abstract class RiskThreatAnalysisEvent extends Equatable {
  const RiskThreatAnalysisEvent();

  @override
  List<Object?> get props => [];
}
