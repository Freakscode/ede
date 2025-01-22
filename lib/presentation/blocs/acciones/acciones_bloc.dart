import 'package:flutter_bloc/flutter_bloc.dart';
import 'acciones_event.dart';
import 'acciones_state.dart';

class AccionesBloc extends Bloc<AccionesEvent, AccionesState> {
  AccionesBloc() : super(AccionesState()) {
    on<UpdateAcciones>((event, emit) {
      emit(state.copyWith(
        evaluacionesAdicionales: event.evaluacionesAdicionales,
        medidasSeguridad: event.medidasSeguridad,
        entidadesRecomendadas: event.entidadesRecomendadas,
        observacionesAcciones: event.observacionesAcciones,
        medidasSeguridadSeleccionadas: event.medidasSeguridadSeleccionadas,
        evaluacionesAdicionalesSeleccionadas: event.evaluacionesAdicionalesSeleccionadas,
      ));
    });
  }
} 