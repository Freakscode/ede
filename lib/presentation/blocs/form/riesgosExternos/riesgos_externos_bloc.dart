import 'package:flutter_bloc/flutter_bloc.dart';
import './riesgos_externos_event.dart';
import './riesgos_externos_state.dart';

class RiesgosExternosBloc extends Bloc<RiesgosExternosEvent, RiesgosExternosState> {
  RiesgosExternosBloc() : super(RiesgosExternosState()) {
    on<SetRiesgoExterno>(_onSetRiesgoExterno);
    on<SetOtroRiesgo>(_onSetOtroRiesgo);
  }

  void _onSetRiesgoExterno(
    SetRiesgoExterno event,
    Emitter<RiesgosExternosState> emit,
  ) {
    final updatedRiesgos = Map<String, RiesgoItem>.from(state.riesgos);
    updatedRiesgos[event.riesgoId] = RiesgoItem(
      existeRiesgo: event.existeRiesgo,
      comprometeFuncionalidad: event.comprometeFuncionalidad ?? false,
      comprometeEstabilidad: event.comprometeEstabilidad ?? false,
    );
    emit(state.copyWith(riesgos: updatedRiesgos));
  }

  void _onSetOtroRiesgo(
    SetOtroRiesgo event,
    Emitter<RiesgosExternosState> emit,
  ) {
    emit(state.copyWith(otroRiesgo: event.descripcion));
  }
} 