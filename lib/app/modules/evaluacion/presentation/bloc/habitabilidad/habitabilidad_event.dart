import 'package:equatable/equatable.dart';
import '../form/riesgosExternos/riesgos_externos_state.dart';

abstract class HabitabilidadEvent extends Equatable {
  const HabitabilidadEvent();

  @override
  List<Object?> get props => [];
}

class CalcularHabitabilidad extends HabitabilidadEvent {
  final Map<String, RiesgoItem> riesgosExternos;
  final String nivelDano;

  const CalcularHabitabilidad({
    required this.riesgosExternos,
    required this.nivelDano,
  });

  @override
  List<Object?> get props => [riesgosExternos, nivelDano];
}

class UpdateHabitabilidad extends HabitabilidadEvent {
  final String? estadoHabitabilidad;
  final String? clasificacionHabitabilidad;
  final String? observacionesHabitabilidad;
  final String? criterioHabitabilidad;

  const UpdateHabitabilidad({
    this.estadoHabitabilidad,
    this.clasificacionHabitabilidad,
    this.observacionesHabitabilidad,
    this.criterioHabitabilidad,
  });

  @override
  List<Object?> get props => [
    estadoHabitabilidad,
    clasificacionHabitabilidad,
    observacionesHabitabilidad,
    criterioHabitabilidad
  ];
} 