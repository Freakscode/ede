// Re-exportar todos los eventos específicos
export 'navigation_events.dart';
export 'form_events.dart';
export 'evaluation_events.dart';
export 'ui_events.dart';

import 'package:equatable/equatable.dart';

/// Evento base para el módulo Home
/// Agrupa todos los eventos específicos
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}
