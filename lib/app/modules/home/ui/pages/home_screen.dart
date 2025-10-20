import 'package:caja_herramientas/app/modules/home/ui/pages/home_forms_screen.dart';
import 'package:caja_herramientas/app/modules/home/ui/pages/risk_categories_screen.dart';
import 'package:caja_herramientas/app/modules/home/ui/pages/settings_screen.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/home_main_section.dart';
import 'package:caja_herramientas/app/modules/home/ui/pages/risk_events_screen.dart';
import 'package:caja_herramientas/app/modules/home/ui/pages/form_completed_screen.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/tutorial_overlay.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/home_help_content.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/help_dialog.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/home/models/domain/form_navigation_data.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? navigationData;
  
  const HomeScreen({super.key, this.navigationData});

  void _showTutorialOverlay(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: TutorialPosterOverlay(),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    final state = context.read<HomeBloc>().state;
    
    String categoryTitle;
    String contentTitle;
    Widget content;
    
    // Determinar el contenido según la pantalla actual
    if (state.mostrarEventosRiesgo) {
      categoryTitle = "Ayuda Eventos de Riesgo";
      contentTitle = "Eventos de Riesgo";
      content = HomeHelpContent.build(); // Puedes cambiar por RiskEventsHelpContent.build()
    } else if (state.mostrarCategoriasRiesgo) {
      categoryTitle = "Ayuda Categorías de Riesgo";
      contentTitle = "Categorías de Riesgo";
      content = HomeHelpContent.build(); // Puedes cambiar por RiskCategoriesHelpContent.build()
    } else if (state.mostrarFormularioCompletado) {
      categoryTitle = "Ayuda Formulario Completado";
      contentTitle = "Formulario Completado";
      content = HomeHelpContent.build(); // Puedes cambiar por FormCompletedHelpContent.build()
    } else {
      // Según el tab seleccionado
      switch (state.selectedIndex) {
        case 0:
          categoryTitle = "Ayuda Inicio";
          contentTitle = "Inicio Caja de Herramientas";
          content = HomeHelpContent.build();
          break;
        case 1:
          categoryTitle = "Ayuda Material Educativo";
          contentTitle = "Material Educativo";
          content = HomeHelpContent.build(); // Puedes cambiar por EducationalMaterialHelpContent.build()
          break;
        case 2:
          categoryTitle = "Ayuda Mis Formularios";
          contentTitle = "Mis Formularios";
          content = HomeHelpContent.build(); // Puedes cambiar por FormsHelpContent.build()
          break;
        case 3:
          categoryTitle = "Ayuda Configuración";
          contentTitle = "Configuración";
          content = HomeHelpContent.build(); // Puedes cambiar por SettingsHelpContent.build()
          break;
        default:
          categoryTitle = "Ayuda";
          contentTitle = "Ayuda";
          content = HomeHelpContent.build();
      }
    }
    
    HelpDialog.show(
      context: context,
      categoryTitle: categoryTitle,
      contentTitle: contentTitle,
      content: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar el HomeBloc global y manejar navigationData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<HomeBloc>();
      
      // Manejar diferentes tipos de navegación
      if (navigationData != null) {
        if (navigationData!['showRiskCategories'] == true) {
          bloc.add(HomeShowRiskCategoriesScreen(
            FormNavigationData.forNewForm(''),
          ));
        } else if (navigationData!['showRiskEvents'] == true) {
          // Si viene de data registration, resetear formularios y mostrar RiskEventsScreen
          if (navigationData!['resetForNewForm'] == true) {
            bloc.add(ResetAllForNewForm());
            bloc.add(HomeShowRiskEventsSection());
          } else {
            bloc.add(HomeShowRiskEventsSection());
          }
        } else if (navigationData!['selectedIndex'] != null) {
          bloc.add(HomeNavBarTapped(navigationData!['selectedIndex'] as int));
        }
      }
    });
    
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          !previous.tutorialShown && current.tutorialShown,
      listener: (context, state) {
        if (state.tutorialShown && state.showTutorial) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showTutorialOverlay(context);
          });
        }
      },
        builder: (context, state) {
          Widget bodyContent;
          // Widget bodyContent = const RiskCategoriesScreen();
          if (state.mostrarEventosRiesgo) {
            bodyContent = const RiskEventsScreen();
          } else if (state.mostrarCategoriasRiesgo) {
            bodyContent = const RiskCategoriesScreen();
          } else if (state.mostrarFormularioCompletado) {
            bodyContent = const FormCompletedScreen();
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
                bodyContent = const HomeFormsScreen();
                break;
              case 3:
                bodyContent = SettingsScreen();
                break;
              case 4:
                bodyContent = const RiskEventsScreen();
                break;
              default:
                bodyContent = const SizedBox.shrink();
            }
          }
          return Scaffold(
            appBar:  CustomAppBar(
              showBack: (state.mostrarEventosRiesgo || state.mostrarCategoriasRiesgo || state.mostrarFormularioCompletado),
              onBack: () {
                if (state.mostrarCategoriasRiesgo) {
                  context.read<HomeBloc>().add(HomeShowRiskEventsSection());
                } else if (state.mostrarEventosRiesgo) {
                  context.read<HomeBloc>().add(HomeResetRiskSections());
                } else if (state.mostrarFormularioCompletado) {
                  // Volver a la pantalla de formularios
                  context.read<HomeBloc>().add(HomeNavBarTapped(2));
                }
              },
              showInfo: true,
              showProfile: true,
              onProfile: () {
                context.go('/login');
              },
              onInfo: () {
                _showHelpDialog(context);
              },
            ),
            body: bodyContent,
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: (state.mostrarEventosRiesgo || state.mostrarCategoriasRiesgo || state.mostrarFormularioCompletado) 
                  ? -1  // No seleccionar ningún tab
                  : state.selectedIndex,
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
      );
  }
}
