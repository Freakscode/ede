import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/home_event.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';

class FormCompletedScreen extends StatelessWidget {
  const FormCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Título principal
          const Text(
            'Formulario finalizado correctamente',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF232B48), // var(--AzulDAGRD, #232B48)
              fontFamily: 'Work Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4, // 28px / 20px = 140%
            ),
          ),

          const SizedBox(height: 24),

          // Texto instructivo
          const Text(
            'El formulario ha sido completado. Seleccione la acción que desea realizar a continuación:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1E1E1E), // var(--Textos, #1E1E1E)
              fontFamily: 'Work Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.615, // 21px / 13px = 161.538%
            ),
          ),

          const SizedBox(height: 48),

          // Botón Descargar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azulDAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _handleDownload(context),
              icon: SvgPicture.asset(
                AppIcons.download,
                width: 29,
                height: 27,
                colorFilter: const ColorFilter.mode(
                  DAGRDColors.blancoDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text(
                'Descargar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.blancoDAGRD,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Botón Asociar a SIRE - Solo visible si el usuario está logueado
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              // Solo mostrar el botón si el usuario está autenticado
              if (authState is AuthAuthenticated) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DAGRDColors.amarDAGRD,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => _handleAssociateToSIRE(context),
                        icon: SvgPicture.asset(
                          AppIcons.link,
                          width: 29,
                          height: 27,
                          colorFilter: const ColorFilter.mode(
                            DAGRDColors.negroDAGRD,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: const Text(
                          'Asociar a SIRE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DAGRDColors.negroDAGRD,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 24 / 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              }
              // Si no está autenticado, no mostrar nada (retornar widget vacío)
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 14),

          // Botón Enviar por correo
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azul3DAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _handleSendEmail(context),
              icon: SvgPicture.asset(
                AppIcons.send,
                width: 29,
                height: 27,
                colorFilter: const ColorFilter.mode(
                  DAGRDColors.blancoDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text(
                'Enviar por correo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.blancoDAGRD,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Enlace "Volver al inicio"
          GestureDetector(
            onTap: () {
              // Resetear el estado para ocultar el formulario completado y volver al home
              context.read<HomeBloc>().add(const HomeResetRiskSections());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.chevron_left,
                  color: DAGRDColors.negroDAGRD,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  'Volver al inicio',
                  style: TextStyle(
                    color: DAGRDColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDownload(BuildContext context) {
    // TODO: Implementar lógica de descarga
    CustomSnackBar.showWarning(
      context,
      title: 'Funcionalidad en desarrollo',
      message: 'La funcionalidad de descarga está en desarrollo',
    );
  }

  void _handleAssociateToSIRE(BuildContext context) {
    // TODO: Implementar lógica de asociación a SIRE
    CustomSnackBar.showWarning(
      context,
      title: 'Funcionalidad en desarrollo',
      message: 'La funcionalidad de asociación a SIRE está en desarrollo',
    );
  }

  void _handleSendEmail(BuildContext context) {
    // TODO: Implementar lógica de envío por correo
    CustomSnackBar.showWarning(
      context,
      title: 'Funcionalidad en desarrollo',
      message: 'La funcionalidad de envío por correo está en desarrollo',
    );
  }
}
