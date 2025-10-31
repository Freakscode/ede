import 'package:caja_herramientas/app/modules/home/presentation/pages/home_forms_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/settings_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/educational_material_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/forms_help_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/general_help_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_main_section.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/risk_events_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/form_completed_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/tutorial_overlay.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_help_content.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/help_dialog.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_state.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? navigationData;

  const HomeScreen({super.key, this.navigationData});

  Future<void> _showTutorialOverlay(BuildContext context) async {
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

  void _handleNavigationData(BuildContext context) {
    if (navigationData == null) return;

    final bloc = context.read<HomeBloc>();

    if (navigationData!['showRiskCategories'] == true) {
      // Navegar a la nueva pantalla de categorías integrada
      context.go('/risk-categories');
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

  @override
  Widget build(BuildContext context) {
    // Manejar datos de navegación después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigationData(context);
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
      builder: (context, homeState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return Scaffold(
              appBar: CustomAppBar(
                showBack: homeState.isShowingSpecialSection,
                onBack: () {
                  final bloc = context.read<HomeBloc>();

                  if (homeState.showRiskEvents) {
                    bloc.add(HomeShowRiskEventsSection());
                  } else if (homeState.showFormCompleted) {
                    // Volver a la pantalla de formularios y resetear estado
                    bloc.add(HomeResetRiskSections());
                    bloc.add(HomeNavBarTapped(2));
                  }
                },
                showInfo: true,
                showProfile: true,
                onProfile: () {
                  if (authState is AuthAuthenticated) {
                    context.go('/profile');
                  } else {
                    context.go('/login');
                  }
                },
                onInfo: () {
                  final state = context.read<HomeBloc>().state;
                  Map<String, dynamic> helpContent;
                  if (state.showRiskEvents) {
                    helpContent = {
                      'categoryTitle': "Ayuda Eventos de Riesgo",
                      'contentTitle': "Eventos de Riesgo",
                      'content': HomeHelpContent.build(),
                    };
                  } else if (state.showFormCompleted) {
                    helpContent = {
                      'categoryTitle': "Ayuda Formulario Completado",
                      'contentTitle': "Formulario Completado",
                      'content': HomeHelpContent.build(),
                    };
                  } else {
                    switch (state.selectedIndex) {
                      case 0:
                        helpContent = {
                          'categoryTitle': "Ayuda Inicio",
                          'contentTitle': "Inicio Caja de Herramientas",
                          'content': HomeHelpContent.build(),
                        };
                        break;
                      case 1:
                        helpContent = {
                          'categoryTitle': "Ayuda Material Educativo",
                          'contentTitle': "Ayuda general",
                          'content': GeneralHelpContent.build(),
                        };
                        break;
                      case 2:
                        helpContent = {
                          'categoryTitle': "Ayuda Mis Formularios",
                          'contentTitle': "Mis Formularios",
                          'content': FormsHelpContent.build(),
                        };
                        break;
                      case 3:
                        helpContent = {
                          'categoryTitle': "Ayuda Configuración",
                          'contentTitle': "Ayuda general",
                          'content': GeneralHelpContent.build(),
                        };
                        break;
                      default:
                        helpContent = {
                          'categoryTitle': "Ayuda",
                          'contentTitle': "Ayuda",
                          'content': HomeHelpContent.build(),
                        };
                    }
                  }
                  HelpDialog.show(
                    context: context,
                    categoryTitle: helpContent['categoryTitle'] as String,
                    contentTitle: helpContent['contentTitle'] as String,
                    content: helpContent['content'] as Widget,
                  );
                },
              ),
              body: () {
                // Priorizar secciones especiales sobre las pestañas principales
                if (homeState.showRiskEvents) {
                  return const RiskEventsScreen();
                }
                if (homeState.showFormCompleted) {
                  return const FormCompletedScreen();
                }
                // Construir contenido de pestañas principales
                Widget? content;
                switch (homeState.selectedIndex) {
                  case 0:
                    content = const HomeMainSection();
                    break;
                  case 1:
                    content = const EducationalMaterialScreen();
                    break;
                  case 2:
                    content = const HomeFormsScreen();
                    break;
                  case 3:
                    content = const SettingsScreen();
                    break;
                  case 4:
                    content = const RiskEventsScreen();
                    break;
                }
                return content ??
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error de navegación',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pestaña no válida: ${homeState.selectedIndex}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Resetear a la pestaña de inicio de forma segura
                                try {
                                  context.read<HomeBloc>().add(
                                    const HomeNavBarTapped(0),
                                  );
                                } catch (e) {
                                  // Si hay error, navegar directamente
                                  context.go('/');
                                }
                              },
                              icon: const Icon(Icons.home),
                              label: const Text('Volver al inicio'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColors.azulDAGRD,
                                foregroundColor: ThemeColors.blancoDAGRD,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
              }(),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: homeState.isShowingSpecialSection
                    ? -1
                    : homeState.selectedIndex,
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
                backgroundColor: ThemeColors.azulDAGRD,
                selectedColor: ThemeColors.blancoDAGRD,
                unselectedColor: Colors.white60,
                selectedIconBgColor: ThemeColors.blancoDAGRD,
              ),
            );
          },
        );
      },
    );
  }
}
