import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class RiskThreatAnalysisScreen extends StatelessWidget {
  const RiskThreatAnalysisScreen({super.key});

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
          customNote: 'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
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
          customItems: [
            'Redes en buen estado.',
            'Fugas menores controladas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Redes con deterioro moderado.',
            'Fugas frecuentes.',
          ],
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
          customItems: [
            'Sin evidencias visibles.',
            'Terreno estable.',
          ],
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
    return BlocProvider(
      create: (context) => RiskThreatAnalysisBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(
          showBack: false,
          showInfo: true,
          showProfile: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 27),
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
                        context.read<RiskThreatAnalysisBloc>().add(ToggleProbabilidadDropdown());
                      },
                    ),
                    const SizedBox(height: 16),
                    ExpandableDropdownField(
                      hint: 'Intensidad',
                      value: state.selectedIntensidad,
                      isSelected: state.isIntensidadDropdownOpen,
                      categories: _intensidadCategories,
                      onTap: () {
                        context.read<RiskThreatAnalysisBloc>().add(ToggleIntensidadDropdown());
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
