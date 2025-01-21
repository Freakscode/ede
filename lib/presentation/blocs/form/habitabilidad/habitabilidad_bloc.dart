import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'habitabilidad_event.dart';
import 'habitabilidad_state.dart';
import '../riesgosExternos/riesgos_externos_state.dart';

class HabitabilidadBloc extends Bloc<HabitabilidadEvent, HabitabilidadState> {
  HabitabilidadBloc() : super(HabitabilidadState()) {
    on<CalcularHabitabilidad>((event, emit) {
      final resultado = _determinarHabitabilidad(
        event.riesgosExternos,
        event.nivelDano,
      );
      emit(state.copyWith(
        criterioHabitabilidad: resultado.criterio,
        clasificacion: resultado.clasificacion,
      ));
    });
  }

  ({String criterio, String clasificacion}) _determinarHabitabilidad(
    Map<String, RiesgoItem> riesgos,
    String nivelDano,
  ) {
    log('Calculando habitabilidad:');
    log('Riesgos externos: $riesgos');
    log('Nivel de daño: $nivelDano');

    // 1. Verificar casos especiales de la matriz de daño
    if (nivelDano == 'I2 - Afectación Funcional') {
      log('Resultado: No Habitable - I2 (Afectación Funcional) - Caso especial de matriz');
      return (criterio: 'No Habitable', clasificacion: 'I2 - Afectación Funcional');
    }

    // 2. Verificar si hay nivel de daño Alto (casos I2 e I3)
    if (nivelDano == 'Alto') {
      if (riesgos.values.any((r) => r.comprometeAccesos)) {
        log('Resultado: No Habitable - I2 (Afectación Funcional)');
        return (criterio: 'No Habitable', clasificacion: 'I2 - Afectación Funcional');
      } else {
        log('Resultado: No Habitable - I3 (Daño severo en la edificación)');
        return (criterio: 'No Habitable', clasificacion: 'I3 - Daño severo en la edificación');
      }
    }

    // 3. Verificar si todos los riesgos están en "No"
    bool todosRiesgosNo = riesgos.values.every((r) => 
      !r.existeRiesgo && !r.comprometeAccesos && !r.comprometeEstabilidad);

    if (todosRiesgosNo) {
      if (nivelDano == 'Sin daño' || nivelDano == 'Bajo') {
        log('Resultado: Habitable - H (Segura)');
        return (criterio: 'Habitable', clasificacion: 'H - Segura');
      }
      if (nivelDano == 'Medio') {
        log('Resultado: Acceso restringido - R1 (Áreas inseguras)');
        return (criterio: 'Acceso restringido', clasificacion: 'R1 - Áreas inseguras');
      }
    }

    // 4. Verificar casos de riesgos específicos
    bool hayRiesgoAyB = riesgos.values.any((r) => 
      r.existeRiesgo && r.comprometeAccesos && !r.comprometeEstabilidad);

    if (hayRiesgoAyB && ['Sin daño', 'Bajo', 'Medio'].contains(nivelDano)) {
      log('Resultado: Acceso restringido - R2 (Entrada limitada)');
      return (criterio: 'Acceso restringido', clasificacion: 'R2 - Entrada limitada');
    }

    bool hayRiesgoAyC = riesgos.values.any((r) => 
      r.existeRiesgo && !r.comprometeAccesos && r.comprometeEstabilidad);

    if (hayRiesgoAyC && ['Sin daño', 'Bajo', 'Medio'].contains(nivelDano)) {
      log('Resultado: No Habitable - I1 (Riesgo por factores externos)');
      return (criterio: 'No Habitable', clasificacion: 'I1 - Riesgo por factores externos');
    }

    // Por defecto, si no cumple ninguna condición específica
    log('Resultado: No Habitable - I1 (Riesgo por factores externos)');
    return (criterio: 'No Habitable', clasificacion: 'I1 - Riesgo por factores externos');
  }
} 