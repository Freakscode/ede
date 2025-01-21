import '../riesgosExternos/riesgos_externos_state.dart';

abstract class HabitabilidadEvent {}

class CalcularHabitabilidad extends HabitabilidadEvent {
  final Map<String, RiesgoItem> riesgosExternos;
  final String nivelDano;

  CalcularHabitabilidad({
    required this.riesgosExternos,
    required this.nivelDano,
  });
} 