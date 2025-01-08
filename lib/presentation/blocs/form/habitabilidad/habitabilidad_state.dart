class HabitabilidadState {
  final String? criterioHabitabilidad;
  final String? clasificacion;

  HabitabilidadState({
    this.criterioHabitabilidad,
    this.clasificacion,
  });

  HabitabilidadState copyWith({
    String? criterioHabitabilidad,
    String? clasificacion,
  }) {
    return HabitabilidadState(
      criterioHabitabilidad: criterioHabitabilidad ?? this.criterioHabitabilidad,
      clasificacion: clasificacion ?? this.clasificacion,
    );
  }
} 