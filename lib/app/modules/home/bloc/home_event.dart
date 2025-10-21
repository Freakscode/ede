// Re-exportar todos los eventos específicos
export 'events/navigation_events.dart';
export 'events/form_events.dart';
export 'events/evaluation_events.dart';
export 'events/ui_events.dart';

import 'package:equatable/equatable.dart';

/// Evento base para el módulo Home
/// Agrupa todos los eventos específicos
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}
