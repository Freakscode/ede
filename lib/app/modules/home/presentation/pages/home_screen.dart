import 'dart:math';

import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            
            // Container with specified CSS styling
            Container(
              height: 105,
              padding: const EdgeInsets.all(23),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: DAGRDColors.azulDAGRD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.analisisRiesgo,
                    width: 60,
                    height: 54.203,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Metodología de Análisis del Riesgo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),

            Container(
              height: 105,
              padding: const EdgeInsets.all(23),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: DAGRDColors.azulDAGRD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.danoEdificaciones,
                    width: 60,
                    height: 54.203,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Evaluación del daño en edificaciones EDE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            Container(
              height: 105,
              padding: const EdgeInsets.all(23),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: DAGRDColors.azulDAGRD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.danoEdificaciones,
                    width: 60,
                    height: 54.203,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Formulario de caracterización de movimientos en masa',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: DAGRDColors.azulDAGRD,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.17, // 14px / 12px = 1.1667
          
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.17,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: _selectedIndex == 0
                  ? const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: SvgPicture.asset(
                AppIcons.home,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 0 ? DAGRDColors.azulDAGRD : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.book,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Material\neducativo',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.files,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Mis formularios',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.gear,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}