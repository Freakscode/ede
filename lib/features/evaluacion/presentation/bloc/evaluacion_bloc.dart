import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/evaluacion_repository.dart';
import '../../../../shared/data/models/evaluacion_model.dart';

// Events
abstract class EvaluacionEvent {}

class GuardarEvaluacion extends EvaluacionEvent {
  final EvaluacionModel evaluacion;
  GuardarEvaluacion(this.evaluacion);
}

class SincronizarEvaluacion extends EvaluacionEvent {
  final String id;
  SincronizarEvaluacion(this.id);
}

class SincronizarTodo extends EvaluacionEvent {}

// States
abstract class EvaluacionState {}

class EvaluacionInitial extends EvaluacionState {}
class EvaluacionGuardando extends EvaluacionState {}
class EvaluacionGuardada extends EvaluacionState {}
class EvaluacionSincronizando extends EvaluacionState {}
class EvaluacionSincronizada extends EvaluacionState {}
class EvaluacionError extends EvaluacionState {
  final String mensaje;
  EvaluacionError(this.mensaje);
}

// Bloc
class EvaluacionBloc extends Bloc<EvaluacionEvent, EvaluacionState> {
  final EvaluacionRepository repository;

  EvaluacionBloc({required this.repository}) : super(EvaluacionInitial()) {
    on<GuardarEvaluacion>((event, emit) async {
      emit(EvaluacionGuardando());
      try {
        await repository.guardarEvaluacion(event.evaluacion);
        emit(EvaluacionGuardada());
      } catch (e) {
        emit(EvaluacionError('Error al guardar: $e'));
      }
    });

    on<SincronizarEvaluacion>((event, emit) async {
      emit(EvaluacionSincronizando());
      try {
        final evaluacion = await repository.obtenerEvaluacion(event.id);
        if (evaluacion != null) {
          final sincronizado = await repository.sincronizarEvaluacion(evaluacion);
          if (sincronizado) {
            emit(EvaluacionSincronizada());
          } else {
            emit(EvaluacionError('Error al sincronizar con el servidor'));
          }
        }
      } catch (e) {
        emit(EvaluacionError('Error al sincronizar: $e'));
      }
    });

    on<SincronizarTodo>((event, emit) async {
      emit(EvaluacionSincronizando());
      try {
        await repository.sincronizarPendientes();
        emit(EvaluacionSincronizada());
      } catch (e) {
        emit(EvaluacionError('Error al sincronizar: $e'));
      }
    });
  }
} 