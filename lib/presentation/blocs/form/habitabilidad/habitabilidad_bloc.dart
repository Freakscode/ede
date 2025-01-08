import 'package:flutter_bloc/flutter_bloc.dart';

import 'habitabilidad_event.dart';
import 'habitabilidad_state.dart';

class HabitabilidadBloc extends Bloc<HabitabilidadEvent, HabitabilidadState> {
  HabitabilidadBloc() : super(HabitabilidadState()) {
    on<CalcularHabitabilidad>((event, emit) {
      final resultado = _determinarHabitabilidad(
        event.riesgosExternos,
        event.nivelDano,
        event.esAfectacionFuncional,
      );
      emit(state.copyWith(
        criterioHabitabilidad: resultado.criterio,
        clasificacion: resultado.clasificacion,
      ));
    });
  }

  ({String criterio, String clasificacion}) _determinarHabitabilidad(
    Map<String, bool> riesgosExternos,
    String nivelDano,
    bool esAfectacionFuncional,
  ) {
    // Verificar si hay riesgos externos
    bool hayRiesgosA = riesgosExternos.entries
        .where((e) => e.key == '4.1' || e.key == '4.2')
        .any((e) => e.value);
    bool hayRiesgosB = riesgosExternos.entries
        .where((e) => e.key == '4.3' || e.key == '4.4')
        .any((e) => e.value);
    bool hayRiesgosC = riesgosExternos['4.5'] ?? false;

    // Caso especial para afectación funcional
    if (esAfectacionFuncional) {
      return (criterio: 'No Habitable', clasificacion: 'I2 - Afectación Funcional');
    }

    // Verificar nivel de daño Alto
    if (nivelDano == 'Alto') {
      return (criterio: 'No Habitable', clasificacion: 'I3 - Daño severo en la edificación');
    }

    // Sin riesgos externos y daño bajo o sin daño
    if (!hayRiesgosA && !hayRiesgosB && !hayRiesgosC) {
      if (nivelDano == 'Sin daño' || nivelDano == 'Bajo') {
        return (criterio: 'Habitable', clasificacion: 'H - Segura');
      }
      if (nivelDano == 'Medio') {
        return (criterio: 'Acceso restringido', clasificacion: 'R1 - Áreas inseguras');
      }
    }

    // Con riesgos externos en a) y b)
    if (hayRiesgosA && hayRiesgosB) {
      if (['Sin daño', 'Bajo', 'Medio'].contains(nivelDano)) {
        return (criterio: 'Acceso restringido', clasificacion: 'R2 - Entrada limitada');
      }
    }

    // Con riesgos externos en a) y c)
    if (hayRiesgosA && hayRiesgosC) {
      if (['Sin daño', 'Bajo', 'Medio'].contains(nivelDano)) {
        return (criterio: 'No Habitable', clasificacion: 'I1 - Riesgo por factores externos');
      }
    }

    // Por defecto
    return (criterio: 'No Habitable', clasificacion: 'I1 - Riesgo por factores externos');
  }
} 