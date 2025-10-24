import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class FormsInProgressDialog extends StatelessWidget {
  final int pendingFormsCount;
  final VoidCallback? onViewForms;
  final VoidCallback? onCreateNew;

  const FormsInProgressDialog({
    super.key,
    required this.pendingFormsCount,
    this.onViewForms,
    this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 40,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con botón de cerrar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Formularios en proceso',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 18 / 16, // 112.5%
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: const Icon(
                      Icons.close,
                      size: 26,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mensaje informativo
                  Text(
                    'Tienes $pendingFormsCount formularios pendientes.',
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontFamily: 'Work Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 24 / 13, // 184.615%
                      ),
                      children: [
                        TextSpan(text: 'Para retomarlos, selecciona '),
                        TextSpan(
                          text: 'Ver formularios.',
                          style: TextStyle(fontWeight: FontWeight.w700), // Bold
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 24 / 13, // 184.615%
                      ),
                      children: [
                        TextSpan(text: 'Para empezar desde cero, elige '),
                        TextSpan(
                          text: 'Crear nuevo.',
                          style: TextStyle(fontWeight: FontWeight.w700), // Bold
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón Ver formularios
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onViewForms?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DAGRDColors.azulDAGRD,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.edit,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Ver formularios',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700, // Bold
                              height: 24 / 13, // 184.615%
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botón Crear nuevo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCreateNew?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DAGRDColors.amarDAGRD,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.add,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Crear nuevo',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700, // Bold
                              height: 24 / 13, // 184.615%
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nota informativa
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppIcons.info,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'No se sobrescribirá el formulario anterior',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
