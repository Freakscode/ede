import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'widgets/form_card.dart';

class FormsHistoryScreen extends StatefulWidget {
  const FormsHistoryScreen({super.key});

  @override
  State<FormsHistoryScreen> createState() => _FormsHistoryScreenState();
}

class _FormsHistoryScreenState extends State<FormsHistoryScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: true,
        showInfo: true,
        showProfile: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 28),
          Center(
            child: Text(
              'Mis Formularios',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DAGRDColors.azulDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() => _tabIndex = 0);
                          },
                          child: Text(
                            'En proceso',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _tabIndex == 0 ? DAGRDColors.azulDAGRD : DAGRDColors.grisMedio,
                              fontFamily: 'Work Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() => _tabIndex = 1);
                          },
                          child: Text(
                            'Finalizados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _tabIndex == 1 ? DAGRDColors.azulDAGRD : DAGRDColors.grisMedio,
                              fontFamily: 'Work Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  left: _tabIndex == 0 ? 0 : MediaQuery.of(context).size.width / 2 - 26,
                  right: _tabIndex == 0 ? MediaQuery.of(context).size.width / 2 - 26 : 0,
                  bottom: 0,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: DAGRDColors.azulDAGRD,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _tabIndex == 0 ? '2 formularios en proceso' : '0 formularios finalizados',
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 26 / 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_tabIndex == 0) ...[
            FormCard(
              title: 'Análisis de Riesgo - Avenidas torrenciales',
              lastEdit: '19-08-25',
              tag: 'Avenidas torrenciales',
              progress: 0.15,
              threat: 0.10,
              vulnerability: 0.20,
            ),
            const SizedBox(height: 16),
            FormCard(
              title: 'Risk Analysis - Landslides',
              lastEdit: '19-08-25',
              tag: 'Landslides',
              progress: 0.485,
              threat: 0.32,
              vulnerability: 0.65,
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No hay formularios finalizados',
                  style: TextStyle(
                    color: DAGRDColors.grisMedio,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {},
        items: const [
          CustomBottomNavBarItem(
            label: 'Home',
            iconAsset: AppIcons.home,
          ),
          CustomBottomNavBarItem(
            label: 'Educational\nMaterial',
            iconAsset: AppIcons.book,
          ),
          CustomBottomNavBarItem(
            label: 'My Forms',
            iconAsset: AppIcons.files,
          ),
          CustomBottomNavBarItem(
            label: 'Settings',
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

