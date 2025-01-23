import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'nivel_dano_event.dart';
import 'nivel_dano_state.dart';

class NivelDanoBloc extends Bloc<NivelDanoEvent, NivelDanoState> {
  NivelDanoBloc() : super(NivelDanoState.initial) {
    on<UpdateNivelDano>(_onUpdateNivelDano);
    on<UpdateNivelDanoEstructural>(_onUpdateNivelDanoEstructural);
    on<UpdateNivelDanoNoEstructural>(_onUpdateNivelDanoNoEstructural);
    on<UpdateNivelDanoGeotecnico>(_onUpdateNivelDanoGeotecnico);
    on<UpdateSeveridadGlobal>(_onUpdateSeveridadGlobal);
    on<CalcularSeveridadDanos>(_onCalcularSeveridadDanos);
    on<SetPorcentajeAfectacion>(_onSetPorcentajeAfectacion);
    on<CalcularNivelDano>(_onCalcularNivelDano);
  }

  void _onUpdateNivelDano(UpdateNivelDano event, Emitter<NivelDanoState> emit) {
    emit(state.copyWith(nivelDano: event.nivelDano));
  }

  void _onUpdateNivelDanoEstructural(UpdateNivelDanoEstructural event, Emitter<NivelDanoState> emit) {
    final newState = state.copyWith(nivelDanoEstructural: event.nivelDanoEstructural);
    emit(newState);
    _updateSeveridadGlobal(emit);
  }

  void _onUpdateNivelDanoNoEstructural(UpdateNivelDanoNoEstructural event, Emitter<NivelDanoState> emit) {
    final newState = state.copyWith(nivelDanoNoEstructural: event.nivelDanoNoEstructural);
    emit(newState);
    _updateSeveridadGlobal(emit);
  }

  void _onUpdateNivelDanoGeotecnico(UpdateNivelDanoGeotecnico event, Emitter<NivelDanoState> emit) {
    final newState = state.copyWith(nivelDanoGeotecnico: event.nivelDanoGeotecnico);
    emit(newState);
    _updateSeveridadGlobal(emit);
  }

  void _onUpdateSeveridadGlobal(UpdateSeveridadGlobal event, Emitter<NivelDanoState> emit) {
    emit(state.copyWith(severidadGlobal: event.severidadGlobal));
  }

  void _updateSeveridadGlobal(Emitter<NivelDanoState> emit) {
    final niveles = [
      state.nivelDanoEstructural,
      state.nivelDanoNoEstructural,
      state.nivelDanoGeotecnico,
    ].where((nivel) => nivel != null).toList();

    if (niveles.isEmpty) {
      emit(state.copyWith(severidadGlobal: null));
      return;
    }

    final severidades = {
      'NINGUNO': 0,
      'LEVE': 1,
      'MODERADO': 2,
      'FUERTE': 3,
      'SEVERO': 4,
    };

    int maxSeveridad = 0;
    for (final nivel in niveles) {
      final currentSeveridad = severidades[nivel] ?? 0;
      if (currentSeveridad > maxSeveridad) {
        maxSeveridad = currentSeveridad;
      }
    }

    final severidadGlobal = severidades.entries
        .firstWhere((entry) => entry.value == maxSeveridad)
        .key;

    emit(state.copyWith(severidadGlobal: severidadGlobal));
  }

  String _calcularSeveridad(
    Map<String, bool> condiciones,
    Map<String, String> niveles,
  ) {
    log('=== Iniciando cálculo de severidad ===');
    log('Condiciones recibidas: $condiciones');
    log('Niveles recibidos: $niveles');

    // Verificar condiciones para Alto (5.1-5.4 SI o 5.7 Severo)
    bool tieneCondicionCritica = condiciones.entries
        .where((e) => ['5.1', '5.2', '5.3', '5.4'].contains(e.key))
        .any((e) => e.value == true);
    
    bool tieneDanoSeveroEstructural = niveles['5.7'] == 'Severo';

    log('Verificación de condiciones críticas:');
    condiciones.entries
        .where((e) => ['5.1', '5.2', '5.3', '5.4'].contains(e.key))
        .forEach((e) => log('${e.key}: ${e.value}'));
    log('Tiene condición crítica (5.1-5.4): $tieneCondicionCritica');
    log('Tiene daño severo estructural (5.7): $tieneDanoSeveroEstructural');

    if (tieneCondicionCritica || tieneDanoSeveroEstructural) {
      log('Severidad ALTA detectada - Retornando Alto');
      return 'Alto';
    }

    // Verificar condiciones para Medio Alto
    bool tieneCondicionMedioAlto = condiciones.entries
        .where((e) => ['5.5', '5.6'].contains(e.key))
        .any((e) => e.value == true);
    
    bool tieneDanoModEstructural = niveles['5.7'] == 'Moderado';
    
    bool tieneDanosSeveros = ['5.8', '5.9', '5.10', '5.11']
        .any((key) => niveles[key] == 'Severo');

    log('Verificación de condiciones medio alto:');
    condiciones.entries
        .where((e) => ['5.5', '5.6'].contains(e.key))
        .forEach((e) => log('${e.key}: ${e.value}'));
    log('Tiene condición medio alto (5.5-5.6): $tieneCondicionMedioAlto');
    log('Tiene daño moderado estructural (5.7): $tieneDanoModEstructural');
    log('Tiene daños severos (5.8-5.11): $tieneDanosSeveros');

    if (tieneCondicionMedioAlto || tieneDanoModEstructural || tieneDanosSeveros) {
      log('Severidad MEDIO ALTA detectada - Retornando Medio Alto');
      return 'Medio Alto';
    }

    // Verificar condiciones para Medio
    bool tieneDanosModElem = ['5.8', '5.9', '5.10', '5.11']
        .any((key) => niveles[key] == 'Moderado');

    log('Verificación de daños moderados:');
    for (var key in ['5.8', '5.9', '5.10', '5.11']) {
      log('$key: ${niveles[key]}');
    }
    log('Tiene daños moderados (5.8-5.11): $tieneDanosModElem');

    if (tieneDanosModElem) {
      log('Severidad MEDIA detectada - Retornando Medio');
      return 'Medio';
    }

    // Verificar condiciones para Bajo
    bool sinCondicionesCriticas = ['5.1', '5.2', '5.3', '5.4', '5.5', '5.6']
        .every((key) => condiciones[key] == false);

    bool tieneDanosLeves = ['5.7', '5.8', '5.9', '5.10', '5.11']
        .any((key) => niveles[key] == 'Leve');

    log('Verificación de condiciones bajas:');
    for (var key in ['5.1', '5.2', '5.3', '5.4', '5.5', '5.6']) {
      log('$key: ${condiciones[key]}');
    }
    log('Sin condiciones críticas (5.1-5.6 en NO): $sinCondicionesCriticas');
    log('Tiene daños leves (5.7-5.11): $tieneDanosLeves');

    if (sinCondicionesCriticas && tieneDanosLeves) {
      log('Severidad BAJA detectada - Retornando Bajo');
      return 'Bajo';
    }

    log('No se cumple ninguna condición - Retornando Sin Daño');
    return 'Sin Daño';
  }

  String _calcularNivelDanoMatriz(String severidad, String porcentaje) {
    // Normalizar el porcentaje para comparación
    String porcentajeNormalizado = porcentaje;
    switch (porcentaje) {
      case 'Ninguno':
        porcentajeNormalizado = '< 10%';
        break;
      case '< 10%':
        porcentajeNormalizado = '< 10%';
        break;
      case '10-40%':
        porcentajeNormalizado = '10-40%';
        break;
      case '40-70%':
        porcentajeNormalizado = '40-70%';
        break;
      case '>70%':
        porcentajeNormalizado = '>70%';
        break;
    }

    // Casos especiales (X en la matriz)
    if ((severidad == 'Medio' && porcentajeNormalizado == '>70%') ||
        (severidad == 'Medio Alto' && porcentajeNormalizado == '40-70%')) {
      return 'Caso Especial';
    }

    // Matriz de nivel de daño según la imagen
    if (severidad == 'Alto') {
      return 'Alto';
    } else if (severidad == 'Medio Alto') {
      if (porcentajeNormalizado == '>70%' || porcentajeNormalizado == '40-70%') {
        return 'Alto';
      } else if (porcentajeNormalizado == '10-40%') {
        return 'Medio Alto';
      } else {
        return 'Medio';
      }
    } else if (severidad == 'Medio') {
      if (porcentajeNormalizado == '>70%') {
        return 'Alto';
      } else if (porcentajeNormalizado == '40-70%') {
        return 'Medio Alto';
      } else if (porcentajeNormalizado == '10-40%') {
        return 'Medio';
      } else {
        return 'Bajo';
      }
    } else if (severidad == 'Bajo') {
      if (porcentajeNormalizado == '>70%') {
        return 'Medio Alto';
      } else if (porcentajeNormalizado == '40-70%') {
        return 'Medio';
      } else {
        return 'Bajo';
      }
    }

    return 'Sin Daño';
  }

  void _onCalcularNivelDano(CalcularNivelDano event, Emitter<NivelDanoState> emit) {
    if (state.severidadDanos == null || state.porcentajeAfectacion == null) {
      developer.log('No se puede calcular el nivel de daño: falta severidad o porcentaje', name: 'NivelDanoBloc');
      return;
    }

    final nivelDano = _calcularNivelDanoMatriz(state.severidadDanos!, state.porcentajeAfectacion!);
    emit(state.copyWith(nivelDano: nivelDano));
    developer.log('Nivel de daño calculado: $nivelDano', name: 'NivelDanoBloc');
  }

  void _onCalcularSeveridadDanos(CalcularSeveridadDanos event, Emitter<NivelDanoState> emit) {
    final severidad = _calcularSeveridad(event.condicionesExistentes, event.nivelesElementos);
    emit(state.copyWith(severidadDanos: severidad));
    developer.log('Severidad calculada: $severidad', name: 'NivelDanoBloc');
    
    // Recalcular el nivel de daño cuando cambie la severidad
    if (state.porcentajeAfectacion != null) {
      add(CalcularNivelDano());
    }
  }

  void _onSetPorcentajeAfectacion(SetPorcentajeAfectacion event, Emitter<NivelDanoState> emit) {
    emit(state.copyWith(porcentajeAfectacion: event.porcentaje));
    developer.log('Porcentaje de afectación actualizado: ${event.porcentaje}', name: 'NivelDanoBloc');
    
    // Recalcular el nivel de daño cuando cambie el porcentaje
    if (state.severidadDanos != null) {
      add(CalcularNivelDano());
    }
  }
} 
