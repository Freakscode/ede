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
    on<SetIdGrupo>((event, emit) {
      emit(state.copyWith(idGrupo: event.idGrupo));
      developer.log('SetIdGrupo: ${event.idGrupo}', name: 'EvaluacionBloc');
    });
    on<SetFirma>((event, emit) {
      emit(state.copyWith(firma: event.rutaFirma));
      developer.log('SetFirma: ${event.rutaFirma}', name: 'EvaluacionBloc');
    });
    on<SetEvento>((event, emit) {
      emit(state.copyWith(
        eventoSeleccionado: event.evento,
        descripcionOtro: event.descripcionOtro,
      ));
      developer.log(
        'SetEvento: ${event.evento.name}${event.descripcionOtro != null ? ' - ${event.descripcionOtro}' : ''}',
        name: 'EvaluacionBloc'
      );
    });
    on<LoadTemporaryEvaluacionData>((event, emit) {
      if (state != EvaluacionState()) {
        emit(state);
      }
    });
    on<SetIdEvento>((event, emit) {
      emit(state.copyWith(idEvento: event.idEvento));
      developer.log('SetIdEvento: ${event.idEvento}', name: 'EvaluacionBloc');
    });
    on<SetDependencia>((event, emit) {
      emit(state.copyWith(dependenciaEntidad: event.dependencia));
      developer.log('SetDependencia: ${event.dependencia}', name: 'EvaluacionBloc');
    });
    on<LoadEvaluacionData>((event, emit) {
      emit(state);
      developer.log('LoadEvaluacionData', name: 'EvaluacionBloc');
    });
  }
}