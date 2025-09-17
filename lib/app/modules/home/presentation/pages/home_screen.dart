import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caja_herramientas/app/modules/tutorial/home_tutorial_overlay.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import '../widgets/home_tool_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tutorial_home_shown') ?? false;
    if (!shown && !_tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorialOverlay();
      });
    }
  }

  void _showTutorialOverlay() async {
    // final prefs = await SharedPreferences.getInstance();
    await showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return TutorialPosterOverlayScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: false,
        showInfo: true,
        showProfile: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28),
            Center(
              child: const Text(
                'Seleccione una herramienta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4, // 28px / 20px = 1.4 (line-height: 140%)
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            HomeToolCard(
              title: 'Metodología de Análisis del Riesgo',
              iconAsset: AppIcons.analisisRiesgo,
              backgroundColor: DAGRDColors.azulDAGRD,
            ),
            const SizedBox(height: 23),

            HomeToolCard(
              title: 'Evaluación del daño en edificaciones EDE',
              iconAsset: AppIcons.danoEdificaciones,
              backgroundColor: DAGRDColors.azulDAGRD,
              onTap: () => context.go('/home_evaluacion'),
            ),
            const SizedBox(height: 23),
            HomeToolCard(
              title: 'Formulario de caracterización de movimientos en masa',
              iconAsset: AppIcons.danoEdificaciones,
              backgroundColor: DAGRDColors.azulDAGRD,
            ),
            
            const SizedBox(height: 48),
            
            // Botón: Ir a portal SIRMED
              GestureDetector(
                onTap: () {
                  // TODO: Implement navigation to SIRMED portal
                  // Example: launch URL or navigate
                  context.go('/login');

                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DAGRDColors.amarDAGRD, width: 1),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.globe,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Ir a portal SIRMED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.71, // 24px / 14px = 1.71 (line-height: 171.429%)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          CustomBottomNavBarItem(
            label: 'Inicio',
            iconAsset: AppIcons.home,
          ),
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