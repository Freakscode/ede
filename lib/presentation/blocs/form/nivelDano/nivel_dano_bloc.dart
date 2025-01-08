import 'package:flutter_bloc/flutter_bloc.dart';

import 'nivel_dano_event.dart';
import 'nivel_dano_state.dart';

class NivelDanoBloc extends Bloc<NivelDanoEvent, NivelDanoState> {
  NivelDanoBloc() : super(NivelDanoState()) {
    on<SetPorcentajeAfectacion>((event, emit) {
      emit(state.copyWith(porcentajeAfectacion: event.porcentaje));
    });

    on<CalcularSeveridadDanos>((event, emit) {
      String severidad = _calcularSeveridad(
        event.condicionesExistentes,
        event.nivelesElementos,
      );
      String nivelDano = _calcularNivelDano(
        severidad,
        state.porcentajeAfectacion ?? '',
      );
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
    // Verificar condiciones para Alto
    if ((condiciones['5.1'] == true ||
        condiciones['5.2'] == true ||
        condiciones['5.3'] == true ||
        condiciones['5.4'] == true) ||
        niveles['5.7'] == 'Severo') {
      return 'Alto';
    }

    // Verificar condiciones para Medio-Alto
    if ((condiciones['5.5'] == true ||
        condiciones['5.6'] == true) ||
        niveles['5.7'] == 'Moderado' ||
        niveles['5.8'] == 'Severo' ||
        niveles['5.9'] == 'Severo' ||
        niveles['5.10'] == 'Severo' ||
        niveles['5.11'] == 'Severo') {
      return 'Medio Alto';
    }

    // Verificar condiciones para Medio
    if (niveles['5.8'] == 'Moderado' ||
        niveles['5.9'] == 'Moderado' ||
        niveles['5.10'] == 'Moderado' ||
        niveles['5.11'] == 'Moderado') {
      return 'Medio';
    }

    // Verificar condiciones para Bajo
    if (condiciones.values.every((value) => value == false) &&
        niveles.entries.any((entry) =>
            entry.value == 'Leve' &&
            (entry.key == '5.7' ||
                entry.key == '5.8' ||
                entry.key == '5.9' ||
                entry.key == '5.10' ||
                entry.key == '5.11'))) {
      return 'Bajo';
    }

    return 'Sin Daño';
  }

  String _calcularNivelDano(String severidad, String porcentaje) {
    // Lógica especial para casos específicos
    if ((severidad == 'Medio' && porcentaje == '>70%') ||
        (severidad == 'Medio Alto' && porcentaje == '40-70%')) {
      return 'Alto Especial';
    }
    
    // Resto de la lógica según la matriz
    // Se implementará según la combinación de severidad y porcentaje
    return 'Normal';
  }
} 