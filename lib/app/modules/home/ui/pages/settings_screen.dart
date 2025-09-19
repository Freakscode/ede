import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_state.dart';

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
                  const SizedBox(height: 16),

                  // Notificaciones
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.notifications_outlined,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Notificaciones',
                    subtitle: 'Recibir alertas y notificaciones',
                    trailing: CustomSvgSwitch(
                      value: state.notificationsEnabled,
                      onChanged: (value) {
                        context.read<HomeBloc>().add(HomeToggleNotifications(value));
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Modo oscuro
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.dark_mode_outlined,
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

                  const SizedBox(height: 16),

                  // Idioma
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.language_outlined,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Idioma',
                    subtitle: 'Seleccionar idioma de la app',
                    trailing: DropdownButton<String>(
                      value: state.selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'Español', child: Text('Español')),
                        DropdownMenuItem(value: 'English', child: Text('English')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<HomeBloc>().add(HomeChangeLanguage(value));
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Almacenamiento
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.storage_outlined,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Almacenamiento',
                    subtitle: 'Uso de almacenamiento',
                    trailing: const Text(
                      '18,8MB',
                      style: TextStyle(
                        color: DAGRDColors.azulDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

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
                          color: DAGRDColors.azulDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                    icon: Icons.help_outline,
                    iconColor: DAGRDColors.azulSecundario,
                    title: 'Ayuda',
                    subtitle: 'Centro de ayuda, contáctanos, política de privacidad',
                    onTap: () {
                      // Implementar navegación a ayuda
                    },
                  ),

                  const SizedBox(height: 16),

                  // Acerca de
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.info_outline,
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
          ],
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
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
                      color: DAGRDColors.negroDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: DAGRDColors.grisMedio,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

class CustomSvgSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomSvgSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

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
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
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
