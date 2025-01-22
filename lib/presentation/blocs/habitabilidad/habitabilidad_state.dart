class HabitabilidadState {
  final String? estadoHabitabilidad;
  final String? clasificacionHabitabilidad;
  final String? observacionesHabitabilidad;
  final String? criterioHabitabilidad;

  HabitabilidadState({
    this.estadoHabitabilidad,
    this.clasificacionHabitabilidad,
    this.observacionesHabitabilidad,
    this.criterioHabitabilidad,
  });

  HabitabilidadState copyWith({
    String? estadoHabitabilidad,
    String? clasificacionHabitabilidad,
    String? observacionesHabitabilidad,
    String? criterioHabitabilidad,
  }) {
    return HabitabilidadState(
      estadoHabitabilidad: estadoHabitabilidad ?? this.estadoHabitabilidad,
      clasificacionHabitabilidad: clasificacionHabitabilidad ?? this.clasificacionHabitabilidad,
      observacionesHabitabilidad: observacionesHabitabilidad ?? this.observacionesHabitabilidad,
      criterioHabitabilidad: criterioHabitabilidad ?? this.criterioHabitabilidad,
    );
  }
} 