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
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Avatar Section
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: DAGRDColors.azulSecundario.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: DAGRDColors.azulDAGRD,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.persona,
                            width: 60,
                            height: 60,
                            colorFilter: ColorFilter.mode(
                              DAGRDColors.azulDAGRD,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // User Name
                    Center(
                      child: Text(
                        user.nombre,
                        style: const TextStyle(
                          color: DAGRDColors.negroDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 28 / 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // User Type Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: user.isDagrdUser
                              ? DAGRDColors.azulSecundario.withOpacity(0.1)
                              : DAGRDColors.grisMedio.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: user.isDagrdUser
                                ? DAGRDColors.azulSecundario
                                : DAGRDColors.grisMedio,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          user.isDagrdUser ? 'Usuario DAGRD' : 'Usuario General',
                          style: TextStyle(
                            color: user.isDagrdUser
                                ? DAGRDColors.azulSecundario
                                : DAGRDColors.grisOscuro,
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Personal Information Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: DAGRDColors.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información Personal',
                            style: TextStyle(
                              color: DAGRDColors.negroDAGRD,
                              fontFamily: 'Work Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            icon: AppIcons.persona,
                            label: 'Cédula',
                            value: user.cedula,
                          ),
                          const SizedBox(height: 16),
                          if (user.email != null && user.email!.isNotEmpty)
                            _buildInfoRow(
                              icon: AppIcons.message,
                              label: 'Email',
                              value: user.email!,
                            ),
                          if (user.email != null && user.email!.isNotEmpty)
                            const SizedBox(height: 16),
                          if (user.telefono != null && user.telefono!.isNotEmpty)
                            _buildInfoRow(
                              icon: AppIcons.message,
                              label: 'Teléfono',
                              value: user.telefono!,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Permissions Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: DAGRDColors.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Permisos',
                            style: TextStyle(
                              color: DAGRDColors.negroDAGRD,
                              fontFamily: 'Work Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPermissionItem(
                            icon: AppIcons.info,
                            label: 'Funcionalidades DAGRD',
                            isEnabled: user.canAccessDagrdFeatures,
                          ),
                          const SizedBox(height: 12),
                          _buildPermissionItem(
                            icon: AppIcons.home,
                            label: 'Funcionalidades Generales',
                            isEnabled: user.canAccessGeneralFeatures,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                    DAGRDColors.grisMedio,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No hay usuario autenticado',
                  style: const TextStyle(
                    color: DAGRDColors.grisOscuro,
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

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: DAGRDColors.azulSecundario.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              DAGRDColors.azulSecundario,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: DAGRDColors.grisOscuro,
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem({
    required String icon,
    required String label,
    required bool isEnabled,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            isEnabled ? DAGRDColors.success : DAGRDColors.grisMedio,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: DAGRDColors.negroDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isEnabled
                ? DAGRDColors.success.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isEnabled ? Icons.check : Icons.close,
            size: 16,
            color: isEnabled ? DAGRDColors.success : Colors.grey,
          ),
        ),
      ],
    );
  }
}

