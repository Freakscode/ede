import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/rating_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/evidence_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/rating_results_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/ui/pages/final_risk_results_screen.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/home_navigation_type.dart';

class RiskThreatAnalysisScreen extends StatefulWidget {
  final String? selectedEvent;
  final Map<String, dynamic>? navigationData;
  
  const RiskThreatAnalysisScreen({super.key, this.selectedEvent, this.navigationData});

  @override
  State<RiskThreatAnalysisScreen> createState() => _RiskThreatAnalysisScreenState();
}

class _RiskThreatAnalysisScreenState extends State<RiskThreatAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // Usar el bloc global e inicializar con el evento seleccionado si existe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<RiskThreatAnalysisBloc>();
      
      // Actualizar el evento seleccionado si es diferente
      if (widget.selectedEvent != null && widget.selectedEvent!.isNotEmpty) {
        bloc.add(UpdateSelectedRiskEvent(widget.selectedEvent!));
      }
      
      // Si tenemos navigationData con clasificación, procesarla
      if (widget.navigationData != null) {
        final classificationName = widget.navigationData!['classification'] as String?;
        final directToResults = widget.navigationData!['directToResults'] as bool? ?? false;
        
        if (classificationName != null) {
          // Si debe ir directo a resultados, ir al índice 2, sino al 0
          final targetIndex = directToResults ? 2 : 0;
          bloc.add(ChangeBottomNavIndex(targetIndex));
          
          // Aplicar la nueva clasificación
          bloc.add(SelectClassification(classificationName));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
        builder: (context, state) {
          final List<Widget> screens = [
            RatingScreen(navigationData: widget.navigationData),
            const EvidenceScreen(),
            const RatingResultsScreen(),
            FinalRiskResultsScreen(eventName: state.selectedRiskEvent),
          ];
          
          return Scaffold(
            appBar:  CustomAppBar(
              showBack: true,
              onBack: () {
                if (state.currentBottomNavIndex > 0) {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ChangeBottomNavIndex(state.currentBottomNavIndex - 1),
                  );
                } else {
                  // Cuando estamos en el primer índice, volver al HomeScreen con categorías
                  final navigationData = HomeNavigationType.riskCategories.toNavigationData();
                  context.go('/home', extra: navigationData);
                }
              },
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
      );
  }
}
