class HabitabilidadState {
  final String? criterioHabitabilidad;  // Habitable, Acceso restringido, No Habitable
  final String? clasificacion;          // H, R1, R2, I1, I2, I3

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

  Map<String, dynamic> toJson() => {
    'criterioHabitabilidad': criterioHabitabilidad,
    'clasificacion': clasificacion,
  };
} 