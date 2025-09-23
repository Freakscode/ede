import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class RiskThreatAnalysisScreen extends StatelessWidget {
  const RiskThreatAnalysisScreen({super.key});

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
                        color: Color(0xFF232B48), // AzulDAGRD
                        fontFamily: 'Work Sans',
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 28 / 20, // 140% line-height
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 27),
                      title: Text(
                        'Calificación de la Amenaza',
                        style: const TextStyle(
                          color: Color(0xFF706F6F), // GrisDAGRD
                          fontFamily: 'Work Sans',
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          height: 28 / 18, // 155.556% line-height
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
                    // Dropdown de Probabilidad
                    CustomDropdownField(
                      hint: 'Probabilidad',
                      value: state.selectedProbabilidad,
                      isSelected: state.isProbabilidadDropdownOpen,
                      onTap: () {
                        context.read<RiskThreatAnalysisBloc>().add(ToggleProbabilidadDropdown());
                      },
                    ),
                    const SizedBox(height: 16),
                    // Dropdown de Intensidad
                    CustomDropdownField(
                      hint: 'Intensidad',
                      value: state.selectedIntensidad,
                      isSelected: state.isIntensidadDropdownOpen,
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



class CustomDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSelected;

  const CustomDropdownField({
    super.key,
    required this.hint,
    this.value,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? DAGRDColors.amarDAGRD 
            : (backgroundColor ?? Colors.white),
          border: Border.all(
            color: isSelected 
              ? DAGRDColors.amarDAGRD 
              : (borderColor ?? const Color(0xFFD1D5DB)),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: isSelected 
                    ? const Color(0xFF1E1E1E)
                    : (value != null 
                        ? (textColor ?? const Color(0xFF1E1E1E))
                        : const Color(0xFF1E1E1E)),
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16, // 150% line-height
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isSelected 
                ? const Color(0xFF1E1E1E)
                : const Color(0xFF666666),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}