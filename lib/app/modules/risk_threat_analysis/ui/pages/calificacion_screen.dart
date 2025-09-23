import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class CalificacionScreen extends StatelessWidget {
  const CalificacionScreen({super.key});

  static List<DropdownCategory> get _probabilidadCategories => [
    DropdownCategory.custom(
      title: 'Características Geotécnicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Pendientes bajas modeladas en suelos (< 5°).',
            'Pendientes bajas, medias o altas, modeladas en roca sana o levemente meteorizada sin fracturas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Pendientes moderadas modeladas en suelos (5° - 15°).',
            'Pendientes bajas modeladas en suelos (< 5°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Pendientes altas modeladas en suelos (15° - 30°).',
            'Pendientes moderadas modeladas en suelos (5° - 15°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Pendientes medias o altas modeladas en roca fracturada.',
            'Pendientes muy altas modeladas en suelos (> 30°).',
            'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
            'Pendientes medias o altas, modeladas en llenos antrópicos.',
          ],
          customNote:
              'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Intervención Antrópica',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin intervención antrópica significativa.',
            'Manejo adecuado del terreno.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Intervención mínima controlada.',
            'Medidas de control implementadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Intervención moderada sin control adecuado.',
            'Cortes y rellenos sin técnica apropiada.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Intervención severa descontrolada.',
            'Cortes verticales sin soporte.',
            'Rellenos sin compactación.',
            'Modificación drástica del drenaje natural.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo aguas lluvia',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sistema de drenaje completo y funcional.',
            'Mantenimiento regular del sistema.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje básico funcional.',
            'Mantenimiento ocasional.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Encharcamientos frecuentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Concentración de aguas superficiales.',
            'Erosión activa por escorrentía.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo de redes hidro sanitarias',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Redes en excelente estado.',
            'Sin fugas ni infiltraciones.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: ['Redes en buen estado.', 'Fugas menores controladas.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Redes con deterioro moderado.', 'Fugas frecuentes.'],
        ),
        RiskLevel.alto(
          customItems: [
            'Redes en mal estado.',
            'Fugas permanentes y significativas.',
            'Saturación del suelo por filtraciones.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Antecedentes',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin antecedentes de movimientos.',
            'Zona estable históricamente.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Antecedentes menores aislados.',
            'Eventos de baja magnitud.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Antecedentes moderados documentados.',
            'Eventos recurrentes de magnitud media.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Antecedentes de eventos mayores.',
            'Historial de deslizamientos significativos.',
            'Eventos recientes y recurrentes.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Evidencias de materialización o reactivación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Sin evidencias visibles.', 'Terreno estable.'],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Evidencias menores localizadas.',
            'Grietas superficiales aisladas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Evidencias moderadas.',
            'Grietas en desarrollo.',
            'Deformaciones menores.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Evidencias claras de inestabilidad.',
            'Grietas activas y en expansión.',
            'Movimientos visibles recientes.',
            'Deformaciones significativas.',
          ],
        ),
      ],
    ),
  ];

  static List<DropdownCategory> get _intensidadCategories => [
    DropdownCategory.intensidad(),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
      child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
        builder: (context, state) {
          return Column(
            children: [
              Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 27,
                ),
                title: Text(
                  'Calificación de la Amenaza',
                  style: const TextStyle(
                    color: Color(0xFF706F6F),
                    fontFamily: 'Work Sans',
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 28 / 18,
                  ),
                ),
                trailing: SvgPicture.asset(
                  AppIcons.info,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    DAGRDColors.amarDAGRD,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CustomElevatedButton(
                text: 'Factor de Amenaza',
                onPressed: () {},
                backgroundColor: DAGRDColors.azulDAGRD,
                textColor: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                borderRadius: 8,
              ),
              const SizedBox(height: 24),
              ExpandableDropdownField(
                hint: 'Probabilidad',
                value: state.selectedProbabilidad,
                isSelected: state.isProbabilidadDropdownOpen,
                categories: _probabilidadCategories,
                onTap: () {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ToggleProbabilidadDropdown(),
                  );
                },
              ),
              const SizedBox(height: 16),
              ExpandableDropdownField(
                hint: 'Intensidad',
                value: state.selectedIntensidad,
                isSelected: state.isIntensidadDropdownOpen,
                categories: _intensidadCategories,
                onTap: () {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ToggleIntensidadDropdown(),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Ver Niveles de Amenaza
              Container(
                width: double.infinity,
                height: 44,
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2563EB)),
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFEFF6FF), // background: #EFF6FF
                ),
                child: InkWell(
                  onTap: () {
                    // Acción para ver niveles de amenaza
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.info,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2563EB),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ver Niveles de Amenaza',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16, // 150% line-height
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(
                        AppIcons.preview,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2563EB),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Barra de progreso
              Column(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(
                        99,
                      ), // Completamente redondeado
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: 0.5, // 50% completado
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFCC00),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '0% completado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DAGRDColors.grisMedio, 
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12, // line-height: 133.333%
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Sección Calificación Amenaza
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calificación Amenaza',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF232B48), // AzulDAGRD
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 16 / 16, // line-height: 100%
                    ),
                  ),
                  Container(
                    width: 165,
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB), // Color bordes
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'SIN CALIFICAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E), // Color textos
                          fontFamily: 'Work Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 16 / 16, // line-height: 100%
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Botón Guardar avance
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para guardar avance
                  },
                  icon: SvgPicture.asset(
                    AppIcons.save,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.blancoDAGRD,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Guardar avance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // #FFF
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 24 / 14, // line-height: 171.429%
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Volver
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: DAGRDColors.negroDAGRD,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Volver',
                          style: TextStyle(
                            color: DAGRDColors.negroDAGRD, // #000
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 18 / 16, // line-height: 112.5%
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón Continuar
                  InkWell(
                    onTap: () {
                      // Acción para continuar
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Continuar',
                          style: TextStyle(
                            color: DAGRDColors.negroDAGRD, // #000
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 18 / 16, // line-height: 112.5%
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: DAGRDColors.negroDAGRD,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Padding bottom adicional
            ],
          );
        },
      ),
    );
  }
}