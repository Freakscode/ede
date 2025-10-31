import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/presentation/bloc/auth_state.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBack: true,
        showInfo: false,
        showProfile: false,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            final user = authState.user;
            
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                const Center(
                  child: Text(
                    'Perfil',
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
                
                // Avatar Section
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ThemeColors.azulSecundario.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeColors.azulSecundario,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.persona,
                        width: 50,
                        height: 50,
                        colorFilter: ColorFilter.mode(
                          ThemeColors.azulSecundario,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // User Name
                Center(
                  child: Text(
                    user.nombre,
                    style: const TextStyle(
                      color: ThemeColors.negroDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // User Type Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: user.isDagrdUser
                          ? ThemeColors.azulSecundario.withOpacity(0.1)
                          : ThemeColors.grisMedio.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: user.isDagrdUser
                            ? ThemeColors.azulSecundario
                            : ThemeColors.grisMedio,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      user.isDagrdUser ? 'Usuario DAGRD' : 'Usuario General',
                      style: TextStyle(
                        color: user.isDagrdUser
                            ? ThemeColors.azulSecundario
                            : ThemeColors.grisOscuro,
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Personal Information Section
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
                        'Información Personal',
                        style: TextStyle(
                          color: ThemeColors.negroDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProfileInfoTile(
                        icon: AppIcons.persona,
                        iconColor: ThemeColors.azulSecundario,
                        label: 'Cédula',
                        value: user.cedula,
                      ),
                      if (user.cargo != null && user.cargo!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ProfileInfoTile(
                          icon: AppIcons.wrench,
                          iconColor: ThemeColors.azulSecundario,
                          label: 'Profesión',
                          value: user.cargo!,
                        ),
                      ],
                      if (user.email != null && user.email!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ProfileInfoTile(
                          icon: AppIcons.message,
                          iconColor: ThemeColors.azulSecundario,
                          label: 'Email',
                          value: user.email!,
                        ),
                      ],
                      if (user.telefono != null && user.telefono!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ProfileInfoTile(
                          icon: AppIcons.message,
                          iconColor: ThemeColors.azulSecundario,
                          label: 'Teléfono',
                          value: user.telefono!,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Permissions Section
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
                        'Permisos',
                        style: TextStyle(
                          color: ThemeColors.negroDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProfilePermissionTile(
                        icon: AppIcons.info,
                        iconColor: ThemeColors.azulSecundario,
                        label: 'Funcionalidades DAGRD',
                        isEnabled: user.canAccessDagrdFeatures,
                      ),
                      const SizedBox(height: 12),
                      ProfilePermissionTile(
                        icon: AppIcons.home,
                        iconColor: ThemeColors.azulSecundario,
                        label: 'Funcionalidades Generales',
                        isEnabled: user.canAccessGeneralFeatures,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          
          // If not authenticated, show message
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.persona,
                  width: 80,
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    ThemeColors.grisMedio,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No hay usuario autenticado',
                  style: TextStyle(
                    color: ThemeColors.grisOscuro,
                    fontFamily: 'Work Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: ThemeColors.grisOscuro,
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: ThemeColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfilePermissionTile extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  final bool isEnabled;

  const ProfilePermissionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: ThemeColors.negroDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 20 / 13,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isEnabled
                ? ThemeColors.success.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isEnabled ? Icons.check : Icons.close,
            size: 16,
            color: isEnabled ? ThemeColors.success : Colors.grey,
          ),
        ),
      ],
    );
  }
}
