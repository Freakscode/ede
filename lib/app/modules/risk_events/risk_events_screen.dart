import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/risk_events/widgets/event_card.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiskEventsScreen extends StatefulWidget {
  const RiskEventsScreen({super.key});

  @override
  State<RiskEventsScreen> createState() => _RiskEventsScreenState();
}

class _RiskEventsScreenState extends State<RiskEventsScreen> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/educational_material');
        break;
      case 2:
        context.go('/forms_history');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: true,
        showInfo: true,
        showProfile: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Metodología de Análisis del Riesgo',
                  style: const TextStyle(
                    color: Color(0xFF232B48),
                    fontFamily: 'Work Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20, // line-height / font-size
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Seleccione un evento',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF706F6F),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 28 / 16, // line-height / font-size
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    EventCard(
                      iconAsset: AppIcons.movimientoMasa,
                      title: 'Movimiento en Masa',
                      onTap: () => context.go('/forms_history'),
                    ),
                    EventCard(
                      iconAsset: AppIcons.movimientoMasa,
                      title: 'Avenidas torrenciales',
                      onTap: () => context.go('/forms_history'),
                    ),
                    EventCard(
                      iconAsset: AppIcons.inundacionCH,
                      title: 'Inundación',
                      onTap: () => context.go('/forms_history'),
                    ),
                    EventCard(
                      iconAsset: AppIcons.estructuralCH,
                      title: 'Estructural',
                      onTap: () => context.go('/forms_history'),
                    ),
                    EventCard(
                      iconAsset: AppIcons.inundacionCH,
                      title: 'Inundación',
                      onTap: () => context.go('/forms_history'),
                    ),
                    EventCard(
                      iconAsset: AppIcons.estructuralCH,
                      title: 'Estructural',
                      onTap: () => context.go('/forms_history'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        items: const [
          CustomBottomNavBarItem(label: 'Inicio', iconAsset: AppIcons.home),
          CustomBottomNavBarItem(
            label: 'Material\neducativo',
            iconAsset: AppIcons.book,
          ),
          CustomBottomNavBarItem(
            label: 'Mis formularios',
            iconAsset: AppIcons.files,
          ),
          CustomBottomNavBarItem(
            label: 'Configuración',
            iconAsset: AppIcons.gear,
          ),
        ],
        backgroundColor: DAGRDColors.azulDAGRD,
        selectedColor: Colors.white,
        unselectedColor: Colors.white60,
        selectedIconBgColor: Colors.white,
      ),
    );
  }
}
