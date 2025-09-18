import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_forms_section.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_main_section.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/risk_events_section.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/tutorial/home_tutorial_overlay.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showTutorialOverlay(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return TutorialPosterOverlayScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(HomeCheckAndShowTutorial()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => !previous.tutorialShown && current.tutorialShown,
        listener: (context, state) {
          if (state.tutorialShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showTutorialOverlay(context);
            });
          }
        },
        builder: (context, state) {
          Widget bodyContent;
          if (state.mostrarEventosRiesgo) {
            bodyContent = const RiskEventsSection();
          } else {
            switch (state.selectedIndex) {
              case 0:
                bodyContent = HomeMainSection();
                break;
              case 1:
                bodyContent = const Center(
                  child: Text(
                    'Material educativo (contenido aquí)',
                    style: TextStyle(fontSize: 18),
                  ),
                );
                break;
              case 2:
                bodyContent = const HomeFormsSection();
                break;
              case 3:
                bodyContent = const Center(
                  child: Text(
                    'Configuración (contenido aquí)',
                    style: TextStyle(fontSize: 18),
                  ),
                );
                break;
              case 4:
                bodyContent = const RiskEventsSection();
                break;
              default:
                bodyContent = const SizedBox.shrink();
            }
          }
          return Scaffold(
            appBar: const CustomAppBar(
              showBack: false,
              showInfo: true,
              showProfile: true,
            ),
            body: bodyContent,
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(HomeNavBarTapped(index));
              },
              items: const [
                CustomBottomNavBarItem(
                  label: 'Inicio',
                  iconAsset: AppIcons.home,
                ),
                CustomBottomNavBarItem(
                  label: 'Material\neducativo',
                  iconAsset: AppIcons.book,
                ),
                CustomBottomNavBarItem(
                  label: 'Mis formularios',
                  iconAsset: AppIcons.files,
                ),
                CustomBottomNavBarItem(
                  label: 'Configuración',
                  iconAsset: AppIcons.gear,
                ),
              ],
              backgroundColor: DAGRDColors.azulDAGRD,
              selectedColor: Colors.white,
              unselectedColor: Colors.white60,
              selectedIconBgColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}