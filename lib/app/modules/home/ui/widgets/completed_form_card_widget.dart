import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/models/form_data_model.dart';
import 'action_button_widget.dart';

class CompletedFormCardWidget extends StatelessWidget {
  final FormDataModel form;
  final VoidCallback onDownload;
  final VoidCallback onAssociateToSIRE;
  final VoidCallback onSendEmail;
  final VoidCallback onDelete;
  final Future<Map<String, double>> Function(String) getFormProgress;

  const CompletedFormCardWidget({
    super.key,
    required this.form,
    required this.onDownload,
    required this.onAssociateToSIRE,
    required this.onSendEmail,
    required this.onDelete,
    required this.getFormProgress,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: getFormProgress(form.id),
      builder: (context, snapshot) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.files,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          DAGRDColors.azulDAGRD,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          form.title,
                          style: const TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 16 / 14,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                AppIcons.trash,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFDC2626),
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: onDelete,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completado: ${form.formattedLastModified}',
                        style: const TextStyle(
                          color: Color(0xFFC6C6C6),
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 16 / 14,
                        ),
                      ),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          form.riskEvent?.name ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 16 / 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Botones de acción para formularios completados
                  // Botón Descargar
                  ActionButtonWidget(
                    title: 'Descargar',
                    icon: Icons.download_outlined,
                    backgroundColor: const Color(0xFF232B48), // Azul DAGRD
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    onTap: onDownload,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Botón Asociar a SIRE
                  ActionButtonWidget(
                    title: 'Asociar a SIRE',
                    icon: Icons.link_outlined,
                    backgroundColor: const Color(0xFFFCD34D), // Amarillo
                    textColor: const Color(0xFF1E1E1E), // Gris oscuro
                    iconColor: const Color(0xFF1E1E1E), // Gris oscuro
                    onTap: onAssociateToSIRE,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Botón Enviar por correo
                  ActionButtonWidget(
                    title: 'Enviar por correo',
                    icon: Icons.send_outlined,
                    backgroundColor: const Color(0xFF3B82F6), // Azul medio
                    textColor: const Color(0xFFFFFFFF), // Blanco
                    iconColor: const Color(0xFFFFFFFF), // Blanco
                    onTap: onSendEmail,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
