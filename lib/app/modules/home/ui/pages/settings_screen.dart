import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/events/auth_events.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Título principal
            const Center(
              child: Text(
                'Configuración',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferencias',
                    style: TextStyle(
                      color: DAGRDColors.negroDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Notificaciones
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.bell,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Notificaciones',
                    subtitle: 'Recibir alertas y notificaciones',
                    trailing: CustomSvgSwitch(
                      value: state.notificationsEnabled,
                      onChanged: (value) {
                        context.read<HomeBloc>().add(
                          HomeToggleNotifications(value),
                        );
                      },
                    ),
                  ),

                  // Modo oscuro
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.moon,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Modo oscuro',
                    subtitle: 'Cambiar color de la aplicación',
                    trailing: CustomSvgSwitch(
                      value: state.darkModeEnabled,
                      onChanged: (value) {
                        context.read<HomeBloc>().add(HomeToggleDarkMode(value));
                      },
                    ),
                  ),

                  // Idioma
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.globe,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Idioma',
                    subtitle: 'Seleccionar idioma de la app',
                    trailing: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                          width: 1,
                        ),
                        color: const Color(0xFFF9FAFB),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: DropdownButton<String>(
                        value: state.selectedLanguage,
                        items: const [
                          DropdownMenuItem(
                            value: 'Español',
                            child: Text(
                              'Español',
                              style: TextStyle(
                                color: Color(0xFF1F2937),
                                fontFamily: 'Work Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'English',
                            child: Text(
                              'English',
                              style: TextStyle(
                                color: Color(0xFF1F2937),
                                fontFamily: 'Work Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<HomeBloc>().add(
                              HomeChangeLanguage(value),
                            );
                          }
                        },
                        underline: const SizedBox(),
                        isDense: true,
                      ),
                    ),
                  ),
                  // Almacenamiento
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.database,
                    iconColor: DAGRDColors.azulSecundario,
                    showBorder: true,
                    title: 'Almacenamiento',
                    subtitle: 'Uso de almacenamiento',
                    trailing: const Text(
                      '18,8MB',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: DAGRDColors.azulSecundario,
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 16 / 14,
                      ),
                    ),
                  ),

                  // Limpiar Datos
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeClearData());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Datos limpiados correctamente'),
                            backgroundColor: DAGRDColors.azulDAGRD,
                          ),
                        );
                      },
                      child: const Text(
                        'Limpiar Datos ahora',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Sección Ayuda
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                children: [
                  // Ayuda
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.question,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Ayuda',
                    subtitle:
                        'Centro de ayuda, contáctanos, política de privacidad',
                    onTap: () {
                      // Implementar navegación a ayuda
                    },
                  ),

                  // Acerca de
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.info,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Acerca de',
                    subtitle: 'Caja de Herramientas DAGRD App v1.0.1',
                    onTap: () {
                      // Implementar diálogo de acerca de
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Sección Sesión
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                children: [
                  // Cerrar Sesión
                  _buildSettingsTile(
                    context: context,
                    icon: AppIcons.signOut,
                    iconColor: Colors.red,
                    title: 'Cerrar Sesión',
                    subtitle: 'Salir de tu cuenta actual',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Mostrar diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: DAGRDColors.negroDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Ejecutar logout
  void _performLogout(BuildContext context) {
    try {
      // Limpiar datos del HomeBloc
      context.read<HomeBloc>().add(HomeClearData());
      
      // Ejecutar logout en AuthBloc
      context.read<AuthBloc>().add(const AuthLogoutRequested());
      
      // Mostrar mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada exitosamente'),
          backgroundColor: DAGRDColors.azulDAGRD,
        ),
      );
      
      // Navegar a la pantalla de login
      context.go('/login');
    } catch (e) {
      // Mostrar error si algo falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showBorder = false,
  }) {
    return Container(
      decoration: showBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              ),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    icon,
                    key: const ValueKey('active'),
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 20 / 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 20 / 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSvgSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomSvgSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: SizedBox(
        width: 45,
        height: 35,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: value
              ? SvgPicture.asset(
                  AppIcons.toggle,
                  key: const ValueKey('active'),
                  width: 45,
                  height: 45,
                  colorFilter: ColorFilter.mode(
                    DAGRDColors.azulSecundario,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  AppIcons.toggleInactive,
                  key: const ValueKey('inactive'),
                  width: 45,
                  height: 45,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }
}
