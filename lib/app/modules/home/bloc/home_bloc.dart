import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import '../../home/services/tutorial_overlay_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
    : super(
        const HomeState(
          selectedIndex: 0,
          mostrarEventosRiesgo: false,
          mostrarCategoriasRiesgo: false,
          tutorialShown: false,
        ),
      ) {
    on<HomeNavBarTapped>((event, emit) {
      emit(state.copyWith(
        selectedIndex: event.index,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: false,
      ));
    });
    on<HomeShowRiskEventsSection>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: true,
        mostrarCategoriasRiesgo: false,
      ));
    });
    on<HomeShowRiskCategoriesScreen>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
      ));
    });
    on<SelectRiskEvent>((event, emit) {
      emit(state.copyWith(
        selectedRiskEvent: event.eventName,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
      ));
    });
    on<SelectRiskCategory>((event, emit) {
      emit(state.copyWith(
        selectedRiskCategory: '${event.categoryType} ${event.eventName}',
      ));
    });
    on<HomeResetRiskSections>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: false,
      ));
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

    on<HomeToggleNotifications>((event, emit) {
      emit(state.copyWith(notificationsEnabled: event.enabled));
    });

    on<HomeToggleDarkMode>((event, emit) {
      emit(state.copyWith(darkModeEnabled: event.enabled));
    });

    on<HomeChangeLanguage>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.language));
    });

    on<HomeClearData>((event, emit) async {
      // Limpiar datos de la aplicación
      await TutorialOverlayService.clearTutorialBox();
      emit(state.copyWith(showTutorial: true));
    });
  }

  /// Mapea los nombres de eventos a sus iconos correspondientes
  String getIconForEvent(String eventName) {
    switch (eventName) {
      case 'Movimiento en Masa':
        return AppIcons.movimientoMasa;
      case 'Avenida Torrencial':
      case 'Avenidas torrenciales':
        return AppIcons.movimientoMasa; // Usar icono temporal
      case 'Inundación':
        return AppIcons.inundacionCH;
      case 'Estructural':
        return AppIcons.estructuralCH;
      case 'Incendio Forestal':
        return AppIcons.movimientoMasa; // Usar icono temporal
      case 'Otros':
        return AppIcons.inundacionCH; // Usar icono temporal
      default:
        return AppIcons.movimientoMasa; // Icono por defecto
    }
  }
}
