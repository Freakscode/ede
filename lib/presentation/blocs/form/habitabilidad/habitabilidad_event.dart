abstract class HabitabilidadEvent {}

class CalcularHabitabilidad extends HabitabilidadEvent {
  final Map<String, bool> riesgosExternos;
  final String nivelDano;
  final bool esAfectacionFuncional;

  CalcularHabitabilidad({
    required this.riesgosExternos,
    required this.nivelDano,
    required this.esAfectacionFuncional,
  });
} 