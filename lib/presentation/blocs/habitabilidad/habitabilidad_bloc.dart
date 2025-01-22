import 'package:flutter_bloc/flutter_bloc.dart';
import 'habitabilidad_event.dart';
import 'habitabilidad_state.dart';

class HabitabilidadBloc extends Bloc<HabitabilidadEvent, HabitabilidadState> {
  HabitabilidadBloc() : super(HabitabilidadState()) {
    on<UpdateHabitabilidad>((event, emit) {
      emit(state.copyWith(
        estadoHabitabilidad: event.estadoHabitabilidad,
        clasificacionHabitabilidad: event.clasificacionHabitabilidad,
        observacionesHabitabilidad: event.observacionesHabitabilidad,
        criterioHabitabilidad: event.criterioHabitabilidad,
      ));
    });
  }
} 