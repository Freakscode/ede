import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/domain/entities/form_entity.dart';
import 'action_button_widget.dart';

class CompletedFormCardWidget extends StatelessWidget {
  final FormEntity form;
  final VoidCallback onDownload;
  final VoidCallback onAssociateToSIRE;
  final VoidCallback onSendEmail;
  final VoidCallback onDelete;
  final Future<Map<String, double>> Function(String) getFormProgress;
  final bool isUserAuthenticated;

  const CompletedFormCardWidget({
    super.key,
    required this.form,
    required this.onDownload,
    required this.onAssociateToSIRE,
    required this.onSendEmail,
    required this.onDelete,
    required this.getFormProgress,
    this.isUserAuthenticated = false,
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
                            color: DAGRDColors.onSurface,
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
                              color: DAGRDColors.errorClaro,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                AppIcons.trash,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  DAGRDColors.errorOscuro,
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
                      Expanded(
                        child: Text(
                          'Completado: ${form.formattedLastModified}',
                          style: const TextStyle(
                            color: DAGRDColors.grisDeshabilitado,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 16 / 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DAGRDColors.azulInfoClaro,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            form.riskEvent ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: DAGRDColors.azulSecundario,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 16 / 12,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                    backgroundColor: DAGRDColors.azulDAGRD, // Azul DAGRD
                    textColor: DAGRDColors.blancoDAGRD,
                    iconColor: DAGRDColors.blancoDAGRD,
                    onTap: onDownload,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Botón Asociar a SIRE - Solo visible si el usuario está autenticado
                  if (isUserAuthenticated) ...[
                    ActionButtonWidget(
                      title: 'Asociar a SIRE',
                      icon: Icons.link_outlined,
                      backgroundColor: DAGRDColors.amarilloClaro, // Amarillo
                      textColor: DAGRDColors.onSurface, // Gris oscuro
                      iconColor: DAGRDColors.onSurface, // Gris oscuro
                      onTap: onAssociateToSIRE,
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Botón Enviar por correo
                  ActionButtonWidget(
                    title: 'Enviar por correo',
                    icon: Icons.send_outlined,
                    backgroundColor: DAGRDColors.azulMedio, // Azul medio
                    textColor: DAGRDColors.blancoDAGRD, // Blanco
                    iconColor: DAGRDColors.blancoDAGRD, // Blanco
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
