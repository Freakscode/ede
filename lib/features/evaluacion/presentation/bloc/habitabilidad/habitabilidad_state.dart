import 'package:equatable/equatable.dart';

class HabitabilidadState extends Equatable {
  final String criterioHabitabilidad;
  final String clasificacion;
  final String observaciones;
  final String estadoHabitabilidad;
  final String clasificacionHabitabilidad;
  final String observacionesHabitabilidad;

  const HabitabilidadState({
    this.criterioHabitabilidad = '',
    this.clasificacion = '',
    this.observaciones = '',
    this.estadoHabitabilidad = '',
    this.clasificacionHabitabilidad = '',
    this.observacionesHabitabilidad = '',
  });

  static const initial = HabitabilidadState();

  HabitabilidadState copyWith({
    String? criterioHabitabilidad,
    String? clasificacion,
    String? observaciones,
    String? estadoHabitabilidad,
    String? clasificacionHabitabilidad,
    String? observacionesHabitabilidad,
  }) {
    return HabitabilidadState(
      criterioHabitabilidad: criterioHabitabilidad ?? this.criterioHabitabilidad,
      clasificacion: clasificacion ?? this.clasificacion,
      observaciones: observaciones ?? this.observaciones,
      estadoHabitabilidad: estadoHabitabilidad ?? criterioHabitabilidad ?? this.estadoHabitabilidad,
      clasificacionHabitabilidad: clasificacionHabitabilidad ?? clasificacion ?? this.clasificacionHabitabilidad,
      observacionesHabitabilidad: observacionesHabitabilidad ?? observaciones ?? this.observacionesHabitabilidad,
    );
  }

  @override
  List<Object> get props => [
    criterioHabitabilidad,
    clasificacion,
    observaciones,
    estadoHabitabilidad,
    clasificacionHabitabilidad,
    observacionesHabitabilidad,
  ];
}