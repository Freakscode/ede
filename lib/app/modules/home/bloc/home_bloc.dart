import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/services/tutorial_overlay_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
    : super(
        const HomeState(
          selectedIndex: 0,
          mostrarEventosRiesgo: false,
          tutorialShown: false,
        ),
      ) {
    on<HomeNavBarTapped>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
    on<HomeShowRiskEventsSection>((event, emit) {
      emit(state.copyWith(mostrarEventosRiesgo: true));
    });
    on<HomeCheckAndShowTutorial>((event, emit) async {
      final showTutorial = await TutorialOverlayService.getShowTutorial();
      if (showTutorial && !state.tutorialShown) {
        emit(state.copyWith(tutorialShown: true, showTutorial: showTutorial));
      } else {
        emit(state.copyWith(showTutorial: showTutorial));
      }
    });

    on<HomeSetShowTutorial>((event, emit) async {
      await TutorialOverlayService.setShowTutorial(event.value);
      emit(state.copyWith(showTutorial: event.value));
    });
    // Método para guardar la preferencia desde el bloc si es necesario
    Future<void> setShowTutorial(bool value) async {
      await TutorialOverlayService.setShowTutorial(value);
    }
  }
}
