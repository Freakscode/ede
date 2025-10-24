import 'package:caja_herramientas/app/modules/home/presentation/pages/home_forms_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/settings_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/forms_help_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/general_help_content.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_main_section.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/risk_events_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/pages/form_completed_screen.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/tutorial_overlay.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_help_content.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/help_dialog.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// Pantalla principal de la aplicación que maneja la navegación
/// entre diferentes secciones y herramientas de la caja de herramientas.
class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? navigationData;
  
  const HomeScreen({super.key, this.navigationData});

  /// Muestra el overlay de tutorial cuando es necesario
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

  /// Determina el contenido de ayuda basado en el estado actual
  Map<String, dynamic> _getHelpContent(HomeState state) {
    if (state.showRiskEvents) {
      return {
        'categoryTitle': "Ayuda Eventos de Riesgo",
        'contentTitle': "Eventos de Riesgo",
        'content': HomeHelpContent.build(),
      };
    } else if (state.showFormCompleted) {
      return {
        'categoryTitle': "Ayuda Formulario Completado",
        'contentTitle': "Formulario Completado",
        'content': HomeHelpContent.build(),
      };
    }

    // Contenido de ayuda para las pestañas principales
    switch (state.selectedIndex) {
      case 0:
        return {
          'categoryTitle': "Ayuda Inicio",
          'contentTitle': "Inicio Caja de Herramientas",
          'content': HomeHelpContent.build(),
        };
      case 1:
        return {
          'categoryTitle': "Ayuda Material Educativo",
          'contentTitle': "Ayuda general",
          'content': GeneralHelpContent.build(),
        };
      case 2:
        return {
          'categoryTitle': "Ayuda Mis Formularios",
          'contentTitle': "Mis Formularios",
          'content': FormsHelpContent.build(),
        };
      case 3:
        return {
          'categoryTitle': "Ayuda Configuración",
          'contentTitle': "Ayuda general",
          'content': GeneralHelpContent.build(),
        };
      default:
        return {
          'categoryTitle': "Ayuda",
          'contentTitle': "Ayuda",
          'content': HomeHelpContent.build(),
        };
    }
  }

  /// Muestra el diálogo de ayuda con el contenido apropiado
  void _showHelpDialog(BuildContext context) {
    final state = context.read<HomeBloc>().state;
    final helpContent = _getHelpContent(state);
    
    HelpDialog.show(
      context: context,
      categoryTitle: helpContent['categoryTitle'] as String,
      contentTitle: helpContent['contentTitle'] as String,
      content: helpContent['content'] as Widget,
    );
  }

  /// Maneja la lógica de navegación basada en los datos de navegación
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

  /// Determina el contenido del cuerpo basado en el estado actual
  Widget _buildBodyContent(BuildContext context, HomeState state) {
    // Priorizar secciones especiales sobre las pestañas principales
    final specialSectionContent = _buildSpecialSectionContent(state);
    if (specialSectionContent != null) {
      return specialSectionContent;
    }

    // Construir contenido de pestañas principales
    return _buildMainTabContent(context, state.selectedIndex);
  }

  /// Construye el contenido para secciones especiales (eventos de riesgo, formulario completado)
  Widget? _buildSpecialSectionContent(HomeState state) {
    if (state.showRiskEvents) {
      return const RiskEventsScreen();
    }
    
    if (state.showFormCompleted) {
      return const FormCompletedScreen();
    }
    
    return null; // No hay sección especial activa
  }

  /// Construye el contenido para las pestañas principales
  Widget _buildMainTabContent(BuildContext context, int selectedIndex) {
    final tabContent = _getTabContent(selectedIndex);
    return tabContent ?? _buildErrorFallback(context, selectedIndex);
  }

  /// Obtiene el contenido específico para cada pestaña
  Widget? _getTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0: // Inicio
        return const HomeMainSection();
      case 1: // Material educativo
        return _buildEducationalMaterialContent();
      case 2: // Mis formularios
        return const HomeFormsScreen();
      case 3: // Configuración
        return const SettingsScreen();
      case 4: // Eventos de riesgo (legacy)
        return const RiskEventsScreen();
      default:
        return null; // Pestaña no reconocida
    }
  }

  /// Construye el contenido del material educativo
  Widget _buildEducationalMaterialContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DAGRDColors.azulDAGRD.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.school_outlined,
                size: 80,
                color: DAGRDColors.azulDAGRD,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Material Educativo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: DAGRDColors.azulDAGRD,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Recursos de aprendizaje y capacitación',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Próximamente disponible',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un fallback de error para pestañas no reconocidas
  Widget _buildErrorFallback(BuildContext context, int invalidIndex) {
    return Center(
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
              'Pestaña no válida: $invalidIndex',
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
                  context.read<HomeBloc>().add(const HomeNavBarTapped(0));
                } catch (e) {
                  // Si hay error, navegar directamente
                  context.go('/');
                }
              },
              icon: const Icon(Icons.home),
              label: const Text('Volver al inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azulDAGRD,
                foregroundColor: Colors.white,
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
  }

  /// Maneja la acción de retroceso basada en el estado actual
  void _handleBackAction(BuildContext context, HomeState state) {
    final bloc = context.read<HomeBloc>();
    
    if (state.showRiskEvents) {
      bloc.add(HomeShowRiskEventsSection());
    } else if (state.showFormCompleted) {
      // Volver a la pantalla de formularios y resetear estado
      bloc.add(HomeResetRiskSections());
      bloc.add(HomeNavBarTapped(2));
    }
  }

  /// Construye la barra de navegación inferior
  Widget _buildBottomNavigationBar(BuildContext context, HomeState state) {
    return CustomBottomNavBar(
      currentIndex: state.isShowingSpecialSection ? -1 : state.selectedIndex,
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
    );
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
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            showBack: state.isShowingSpecialSection,
            onBack: () => _handleBackAction(context, state),
            showInfo: true,
            showProfile: true,
            onProfile: () => context.go('/login'),
            onInfo: () => _showHelpDialog(context),
          ),
          body: _buildBodyContent(context, state),
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
        );
      },
    );
  }
}
