import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/evaluacion_repository.dart';
import 'evaluacion_event.dart';
import 'evaluacion_state.dart';

class EvaluacionBloc extends Bloc<EvaluacionEvent, EvaluacionState> {
  final EvaluacionRepository repository;

  EvaluacionBloc({required this.repository}) : super(EvaluacionState()) {
    on<EvaluacionStarted>(_onStarted);
    on<SetEvaluacionData>(_onSetEvaluacionData);
    on<SignatureUpdated>(_onSignatureUpdated);
  }

  Future<void> _onStarted(EvaluacionStarted event, Emitter<EvaluacionState> emit) async {
    final signature = repository.obtenerFirmaEvaluador();
    if (signature != null) {
      emit(state.copyWith(firmaPath: signature));
    }
  }

  Future<void> _onSetEvaluacionData(SetEvaluacionData event, Emitter<EvaluacionState> emit) async {
    final newState = state.copyWith(
      fechaInspeccion: event.fechaInspeccion,
      horaInspeccion: event.horaInspeccion,
      nombreEvaluador: event.nombreEvaluador,
      idGrupo: event.idGrupo,
      idEvento: event.idEvento,
      eventoSeleccionado: event.eventoSeleccionado,
      descripcionOtro: event.descripcionOtro,
      dependenciaEntidad: event.dependenciaEntidad,
      firmaPath: event.firmaPath,
    );

    if (event.firmaPath != null && event.firmaPath != state.firmaPath) {
      await repository.guardarFirmaEvaluador(event.firmaPath!);
    }

    emit(newState);
  }

  Future<void> _onSignatureUpdated(SignatureUpdated event, Emitter<EvaluacionState> emit) async {
    await repository.guardarFirmaEvaluador(event.firmaPath);
    emit(state.copyWith(firmaPath: event.firmaPath));
  }
} 