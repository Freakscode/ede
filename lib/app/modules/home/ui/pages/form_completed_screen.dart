import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class FormCompletedScreen extends StatelessWidget {
  const FormCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título principal
              const Text(
                'Formulario finalizado correctamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Texto instructivo
              const Text(
                'El formulario ha sido completado. Seleccione la acción que desea realizar a continuación:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Botón Descargar
              _buildActionButton(
                context: context,
                title: 'Descargar',
                icon: Icons.download_outlined,
                backgroundColor: DAGRDColors.negroDAGRD,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  _handleDownload(context);
                },
              ),
              
              const SizedBox(height: 16),
              
              // Botón Asociar a SIRE
              _buildActionButton(
                context: context,
                title: 'Asociar a SIRE',
                icon: Icons.link_outlined,
                backgroundColor: DAGRDColors.amarDAGRD,
                textColor: DAGRDColors.negroDAGRD,
                iconColor: DAGRDColors.negroDAGRD,
                onTap: () {
                  _handleAssociateToSIRE(context);
                },
              ),
              
              const SizedBox(height: 16),
              
              // Botón Enviar por correo
              _buildActionButton(
                context: context,
                title: 'Enviar por correo',
                icon: Icons.send_outlined,
                backgroundColor: DAGRDColors.azulDAGRD,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  _handleSendEmail(context);
                },
              ),
              
              const SizedBox(height: 48),
              
              // Enlace "Volver al inicio"
              GestureDetector(
                onTap: () {
                  context.go('/home');
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
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDownload(BuildContext context) {
    // TODO: Implementar lógica de descarga
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de descarga en desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleAssociateToSIRE(BuildContext context) {
    // TODO: Implementar lógica de asociación a SIRE
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de asociación a SIRE en desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleSendEmail(BuildContext context) {
    // TODO: Implementar lógica de envío por correo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de envío por correo en desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
