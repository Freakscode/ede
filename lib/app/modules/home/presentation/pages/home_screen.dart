import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_forms_section.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_main_section.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caja_herramientas/app/modules/tutorial/home_tutorial_overlay.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _tutorialShown = false;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = HomeMainSection();
        break;
      case 1:
        bodyContent = const Center(
          child: Text(
            'Material educativo (contenido aquí)',
            style: TextStyle(fontSize: 18),
          ),
        );
        break;
      case 2:
        bodyContent = const HomeFormsSection();
        break;
      case 3:
        bodyContent = const Center(
          child: Text(
            'Configuración (contenido aquí)',
            style: TextStyle(fontSize: 18),
          ),
        );
        break;
      default:
        bodyContent = const SizedBox.shrink();
    }
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: false,
        showInfo: true,
        showProfile: true,
      ),
      body: bodyContent,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
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