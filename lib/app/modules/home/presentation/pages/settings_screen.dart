import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_state.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/events/auth_events.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated && authState.message != null) {
          CustomSnackBar.showSuccess(
            context,
            title: 'Sesión cerrada',
            message: authState.message!,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              const Center(
                child: Text(
                  'Configuración',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.azulDAGRD,
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
                  border: Border.all(color: ThemeColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferencias',
                      style: TextStyle(
                        color: ThemeColors.negroDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SettingsTile(
                      icon: AppIcons.bell,
                      iconColor: ThemeColors.azulSecundario,
                      title: 'Notificaciones',
                      subtitle: 'Recibir alertas y notificaciones',
                      trailing: CustomSvgSwitch(
                        value: state.notificationsEnabled,
                        onChanged: (value) {
                          context.read<HomeBloc>().add(HomeToggleNotifications(value));
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: AppIcons.moon,
                      iconColor: ThemeColors.azulSecundario,
                      title: 'Modo oscuro',
                      subtitle: 'Cambiar color de la aplicación',
                      trailing: CustomSvgSwitch(
                        value: state.darkModeEnabled,
                        onChanged: (value) {
                          context.read<HomeBloc>().add(HomeToggleDarkMode(value));
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: AppIcons.globe,
                      iconColor: ThemeColors.azulSecundario,
                      title: 'Idioma',
                      subtitle: 'Seleccionar idioma de la app',
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ThemeColors.outlineVariant, width: 1),
                          color: ThemeColors.surfaceVariant,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: DropdownButton<String>(
                          value: state.selectedLanguage,
                          items: const [
                            DropdownMenuItem(
                              value: 'Español',
                              child: Text(
                                'Español',
                                style: TextStyle(
                                  color: ThemeColors.grisOscuro,
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
                                  color: ThemeColors.grisOscuro,
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
                              context.read<HomeBloc>().add(HomeChangeLanguage(value));
                            }
                          },
                          underline: const SizedBox(),
                          isDense: true,
                        ),
                      ),
                    ),
                    SettingsTile(
                      icon: AppIcons.database,
                      iconColor: ThemeColors.azulSecundario,
                      showBorder: true,
                      title: 'Almacenamiento',
                      subtitle: 'Uso de almacenamiento',
                      trailing: const Text(
                        '18,8MB',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: ThemeColors.azulSecundario,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 16 / 14,
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(HomeClearData());
                          CustomSnackBar.showSuccess(
                            context,
                            title: 'Datos limpiados',
                            message: 'Los datos han sido limpiados correctamente',
                          );
                        },
                        child: const Text(
                          'Limpiar Datos ahora',
                          style: TextStyle(
                            color: ThemeColors.azulSecundario,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThemeColors.outline),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: AppIcons.question,
                      iconColor: ThemeColors.azulSecundario,
                      title: 'Ayuda',
                      subtitle: 'Centro de ayuda, contáctanos, política de privacidad',
                      onTap: () {
                        // TODO: Implementar navegación a ayuda
                      },
                    ),
                    SettingsTile(
                      icon: AppIcons.info,
                      iconColor: ThemeColors.azulSecundario,
                      title: 'Acerca de',
                      subtitle: 'Caja de Herramientas DAGRD App v1.0.1',
                      onTap: () {
                        // TODO: Implementar diálogo de acerca de
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthAuthenticated) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.outline),
                      ),
                      child: Column(
                        children: [
                          SettingsTile(
                            icon: AppIcons.signOut,
                            iconColor: Colors.red,
                            title: 'Cerrar Sesión',
                            subtitle: 'Salir de tu cuenta actual',
                            onTap: () {
                              CustomActionDialog.show(
                                context: context,
                                title: 'Cerrar Sesión',
                                message: '¿Estás seguro de que deseas cerrar sesión?',
                                leftButtonText: 'Cancelar',
                                leftButtonIcon: Icons.close,
                                rightButtonText: 'Cerrar Sesión',
                                rightButtonIcon: Icons.logout,
                                rightButtonColor: Colors.red,
                                onRightButtonPressed: () {
                                  Navigator.of(context).pop();
                                  context.read<HomeBloc>().add(HomeClearData());
                                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showBorder;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ThemeColors.outlineVariant, width: 1),
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
                        color: ThemeColors.negroDAGRD,
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
                        color: ThemeColors.negroDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 20 / 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
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
                    ThemeColors.azulSecundario,
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
