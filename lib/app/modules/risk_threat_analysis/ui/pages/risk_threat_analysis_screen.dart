import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/calificacion_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';

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
        body: SingleChildScrollView(child: CalificacionScreen()),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0,
          onTap: (index) {},
          items: const [
            CustomBottomNavBarItem(
              label: 'Calificación',
              iconAsset: AppIcons.clipboardText,
            ),
            CustomBottomNavBarItem(
              label: 'Evidencias',
              iconAsset: AppIcons.images,
            ),
            CustomBottomNavBarItem(
              label: 'Resultados',
              iconAsset: AppIcons.hoja,
            ),
          ],
          backgroundColor: DAGRDColors.azulDAGRD,
          selectedColor: Colors.white,
          unselectedColor: Colors.white60,
          selectedIconBgColor: Colors.white,
        ),
      ),
    );
  }
}
