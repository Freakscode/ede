import 'package:caja_herramientas/app/core/constants/app_assets.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/menu_card.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/app_main_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            // Contenido principal del home
            _buildWelcomeSection(),
            
            const SizedBox(height: 30),
            
            // Grid de herramientas principales
            _buildToolsGrid(context),
            
            const SizedBox(height: 30),
            
            // Sección de acciones rápidas
            _buildQuickActions(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DAGRDColors.azulDAGRD.withOpacity(0.1),
            DAGRDColors.amarDAGRD.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DAGRDColors.azulDAGRD.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: DAGRDColors.azulDAGRD,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gestiona evaluaciones y emergencias con las herramientas DAGRD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: DAGRDColors.azulDAGRD.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                AppAssets.logoDagrd,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Herramientas Principales',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: DAGRDColors.azulDAGRD,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            MenuCard(
              title: 'Evaluación\nde Daños',
              iconPath: AppIcons.estructural,
              color: Colors.blue[600]!,
              onTap: () {
                // TODO: Navegar a evaluación
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evaluación de Daños')),
                );
              },
            ),
            MenuCard(
              title: 'Habitabilidad',
              iconPath: AppIcons.persona,
              color: Colors.green[600]!,
              onTap: () {
                // TODO: Navegar a habitabilidad
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Habitabilidad')),
                );
              },
            ),
            MenuCard(
              title: 'Emergencias',
              iconPath: AppIcons.incendio,
              color: Colors.red[600]!,
              onTap: () => _showEmergencyMenu(context),
            ),
            MenuCard(
              title: 'Usuarios',
              iconPath: AppIcons.persona,
              color: Colors.purple[600]!,
              onTap: () {
                // TODO: Navegar a usuarios
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gestión de Usuarios')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: DAGRDColors.azulDAGRD,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'Nueva Evaluación',
                Icons.add_circle_outline,
                DAGRDColors.amarDAGRD,
                () {
                  // TODO: Crear nueva evaluación
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                'Ver Reportes',
                Icons.assessment_outlined,
                Colors.blue[600]!,
                () {
                  // TODO: Ver reportes
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmergencyMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle del modal
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Título
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Tipos de Emergencia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: DAGRDColors.azulDAGRD,
                ),
              ),
            ),
            
            // Grid de emergencias
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildEmergencyCard('Sismo', AppIcons.sismo, Colors.orange[600]!),
                  _buildEmergencyCard('Incendio', AppIcons.incendio, Colors.red[600]!),
                  _buildEmergencyCard('Inundación', AppIcons.inundacion, Colors.blue[600]!),
                  _buildEmergencyCard('Deslizamiento', AppIcons.deslizamiento, Colors.brown[600]!),
                  _buildEmergencyCard('Viento Fuerte', AppIcons.viento, Colors.grey[600]!),
                  _buildEmergencyCard('Explosión', AppIcons.explosion, Colors.orange[800]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(String title, String iconPath, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Manejar selección de emergencia
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
