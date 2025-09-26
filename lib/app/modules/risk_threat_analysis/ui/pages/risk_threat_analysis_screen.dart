import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/calificacion_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class RiskThreatAnalysisScreen extends StatefulWidget {
  final String? selectedEvent;
  final Map<String, dynamic>? navigationData;
  
  const RiskThreatAnalysisScreen({super.key, this.selectedEvent, this.navigationData});

  @override
  State<RiskThreatAnalysisScreen> createState() => _RiskThreatAnalysisScreenState();
}

class _RiskThreatAnalysisScreenState extends State<RiskThreatAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      CalificacionScreen(navigationData: widget.navigationData),
      const Center(child: Text('Evidencias Screen')),
      const Center(child: Text('Resultados Screen')),
    ];

    return BlocProvider(
      create: (context) {
        final bloc = RiskThreatAnalysisBloc();
        // Si hay un evento seleccionado, actualizarlo en el bloc
        if (widget.selectedEvent != null && widget.selectedEvent!.isNotEmpty) {
          bloc.add(UpdateSelectedRiskEvent(widget.selectedEvent!));
        }
        return bloc;
      },
      child: BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(
              showBack: false,
              showInfo: true,
              showProfile: true,
            ),
            body: SingleChildScrollView(child: screens[state.currentBottomNavIndex]),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: state.currentBottomNavIndex,
              onTap: (index) {
                context.read<RiskThreatAnalysisBloc>().add(
                  ChangeBottomNavIndex(index),
                );
              },
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
          );
        },
      ),
    );
  }
}
