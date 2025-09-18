import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(const HomeState(
          selectedIndex: 0,
          mostrarEventosRiesgo: false,
          tutorialShown: false,
        )) {
    on<HomeNavBarTapped>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
    on<HomeShowRiskEventsSection>((event, emit) {
      emit(state.copyWith(mostrarEventosRiesgo: true));
    });
    on<HomeCheckAndShowTutorial>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getBool('tutorial_home_shown') ?? false;
      if (!shown && !state.tutorialShown) {
        emit(state.copyWith(tutorialShown: true));
      }
    });
  }
}