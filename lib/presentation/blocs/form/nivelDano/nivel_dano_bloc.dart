import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'nivel_dano_event.dart';
import 'nivel_dano_state.dart';

class NivelDanoBloc extends Bloc<NivelDanoEvent, NivelDanoState> {
  NivelDanoBloc() : super(NivelDanoState()) {
    on<SetPorcentajeAfectacion>((event, emit) {
      log('SetPorcentajeAfectacion: ${event.porcentaje}');
      
      // Si no hay severidad calculada, solo actualizar el porcentaje
      if (state.severidadDanos == null) {
        emit(state.copyWith(porcentajeAfectacion: event.porcentaje));
        return;
      }

      // Si hay severidad, recalcular el nivel de daño
      final nivelDano = _calcularNivelDano(
        state.severidadDanos!,
        event.porcentaje,
      );

      emit(state.copyWith(
        porcentajeAfectacion: event.porcentaje,
        nivelDano: nivelDano,
      ));
    });

    on<CalcularSeveridadDanos>((event, emit) {
      log('CalcularSeveridadDanos - Inicio');
      log('Condiciones existentes: ${event.condicionesExistentes}');
      log('Niveles de elementos: ${event.nivelesElementos}');

      // Validar que tenemos todos los datos necesarios
      if (event.condicionesExistentes.isEmpty || event.nivelesElementos.isEmpty) {
        log('Error: Datos incompletos para el cálculo');
        return;
      }

      final severidad = _calcularSeveridad(
        event.condicionesExistentes,
        event.nivelesElementos,
      );

      log('Severidad calculada: $severidad');

      String? nivelDano;
      if (state.porcentajeAfectacion != null) {
        nivelDano = _calcularNivelDano(
          severidad,
          state.porcentajeAfectacion!,
        );
        log('Nivel de daño calculado: $nivelDano');
      }

      emit(state.copyWith(
        severidadDanos: severidad,
        nivelDano: nivelDano,
      ));
    });
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

  String _calcularNivelDano(String severidad, String porcentaje) {
    log('=== Calculando nivel de daño ===');
    log('Severidad: $severidad');
    log('Porcentaje: $porcentaje');
    
    // Convertir porcentaje a rango numérico para comparación
    int porcentajeMin = 0;
    int porcentajeMax = 0;
    
    switch (porcentaje) {
      case 'Ninguno':
        porcentajeMin = 0;
        porcentajeMax = 0;
        break;
      case '< 10%':
        porcentajeMin = 0;
        porcentajeMax = 10;
        break;
      case '10-40%':
        porcentajeMin = 10;
        porcentajeMax = 40;
        break;
      case '40-70%':
        porcentajeMin = 40;
        porcentajeMax = 70;
        break;
      case '>70%':
        porcentajeMin = 70;
        porcentajeMax = 100;
        break;
      default:
        log('Porcentaje no reconocido - Retornando Sin Daño');
        return 'Sin Daño';
    }

    log('Porcentaje convertido - Min: $porcentajeMin, Max: $porcentajeMax');

    String resultado = 'Sin Daño';

    // Matriz de nivel de daño según la imagen
    if (severidad == 'Alto') {
      resultado = 'Alto';
    } else if (severidad == 'Medio Alto') {
      if (porcentajeMax > 70 || porcentajeMin >= 40) {
        resultado = 'Alto';
      } else if (porcentajeMin >= 10) {
        resultado = 'Medio Alto';
      } else {
        resultado = 'Medio';
      }
    } else if (severidad == 'Medio') {
      if (porcentajeMax > 70) {
        resultado = 'Alto';
      } else if (porcentajeMin >= 40) {
        resultado = 'Medio Alto';
      } else if (porcentajeMin >= 10) {
        resultado = 'Medio';
      } else {
        resultado = 'Bajo';
      }
    } else if (severidad == 'Bajo') {
      if (porcentajeMax > 70) {
        resultado = 'Medio Alto';
      } else if (porcentajeMin >= 40) {
        resultado = 'Medio';
      } else {
        resultado = 'Bajo';
      }
    }

    log('Nivel de daño calculado: $resultado');
    return resultado;
  }
} 