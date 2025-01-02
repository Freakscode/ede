import 'package:flutter_bloc/flutter_bloc.dart';
import 'id_evaluacion_event.dart';
import 'id_evaluacion_state.dart';
import 'dart:developer' as developer;

class EvaluacionBloc extends Bloc<EvaluacionEvent, EvaluacionState> {
  EvaluacionBloc() : super(EvaluacionState()) {
    on<SetFechaInspeccion>((event, emit) {
      emit(state.copyWith(fechaInspeccion: event.fecha));
      developer.log('SetFechaInspeccion: ${event.fecha}', name: 'EvaluacionBloc');
    });
    on<SetHoraInspeccion>((event, emit) {
      emit(state.copyWith(horaInspeccion: event.hora));
      developer.log('SetHoraInspeccion: ${event.hora}', name: 'EvaluacionBloc');
    });
  }
}