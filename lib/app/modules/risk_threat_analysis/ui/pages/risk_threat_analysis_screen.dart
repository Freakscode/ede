import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class RiskThreatAnalysisScreen extends StatelessWidget {
  const RiskThreatAnalysisScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'Características Geotécnicas',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
    {
      'title': 'Intervención Antrópica',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
    {
      'title': 'Manejo aguas lluvia',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
    {
      'title': 'Manejo de redes hidro sanitarias',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
    {
      'title': 'Antecedentes',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
    {
      'title': 'Evidencias de materialización o reactivación',
      'levels': ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO']
    },
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
                      categories: _categories,
                      onTap: () {
                        context.read<RiskThreatAnalysisBloc>().add(ToggleProbabilidadDropdown());
                      },
                    ),
                    const SizedBox(height: 16),
                    ExpandableDropdownField(
                      hint: 'Intensidad',
                      value: state.selectedIntensidad,
                      isSelected: state.isIntensidadDropdownOpen,
                      categories: _categories,
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
