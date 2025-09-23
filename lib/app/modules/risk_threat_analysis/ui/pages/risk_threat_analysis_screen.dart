import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RiskThreatAnalysisScreen extends StatelessWidget {
  const RiskThreatAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: false,
        showInfo: true,
        showProfile: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 28),

          child: Column(
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
                contentPadding: EdgeInsets.symmetric(horizontal: 27),
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
              SizedBox(height: 18),
              CustomElevatedButton(
                text: 'Factor de Amenaza',
                onPressed: () {},
                backgroundColor: DAGRDColors.azulDAGRD,
                textColor: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

