import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/infographic_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/section_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Pantalla de Material Educativo que muestra recursos de aprendizaje
/// y capacitación para los usuarios de la aplicación.
class EducationalMaterialScreen extends StatefulWidget {
  const EducationalMaterialScreen({super.key});

  @override
  State<EducationalMaterialScreen> createState() => _EducationalMaterialScreenState();
}

class _EducationalMaterialScreenState extends State<EducationalMaterialScreen> {
  int _selectedTab = 0; // 0: Infografías, 1: Videos, 2: Documentos
  String _selectedFilter = 'Todos';

  // Filtros disponibles
  final List<String> _filters = [
    'Todos',
    'Evaluación EDE',
    'Análisis del Riesgo',
    'Gestión del Riesgo',
    'Emergencias',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        
        // Tabs de navegación
        _buildTabs(),
        
        const SizedBox(height: 10),
        
        // Filtros
        _buildFilters(),
        
        const SizedBox(height: 24),
        
        // Contenido de la sección seleccionada
        _buildContent(),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              index: 0,
              label: 'Infografías',
              iconAsset: AppIcons.images,
            ),
          ),
          Expanded(
            child: _buildTab(
              index: 1,
              label: 'Videos',
              iconAsset: AppIcons.video,
            ),
          ),
          Expanded(
            child: _buildTab(
              index: 2,
              label: 'Documentos',
              iconAsset: AppIcons.files,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String label,
    required String iconAsset,
  }) {
    final isSelected = _selectedTab == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? DAGRDColors.azulDAGRD : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isSelected ? DAGRDColors.azulDAGRD : DAGRDColors.grisMedio,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? DAGRDColors.azulDAGRD : DAGRDColors.grisMedio,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return InkWell(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? DAGRDColors.azulDAGRD : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedTab == 0) {
      // Mostrar encabezado y card de infografía
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWidget(
            title: _getTitleForTab(_selectedTab),
            description: _getDescriptionForTab(_selectedTab),
          ),
          const SizedBox(height: 16),
          _buildInfographicCard(),
        ],
      );
    }
    
    // Para otros tabs, mostrar contenido simple
    return SectionHeaderWidget(
      title: _getTitleForTab(_selectedTab),
      description: _getDescriptionForTab(_selectedTab),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildInfographicCard() {
    return const InfographicCardWidget(
      title: 'Gestión del Riesgo - Definiciones generales',
      description: 'Material educativo Gestión del Riesgo',
      publishedDate: '10/jul/2025',
      categoryBadge: 'Evaluación EDE',
    );
  }

  String _getTitleForTab(int index) {
    switch (index) {
      case 0:
        return 'Infografías';
      case 1:
        return 'Videos educativos';
      case 2:
        return 'Documentos';
      default:
        return 'Material Educativo';
    }
  }

  String _getDescriptionForTab(int index) {
    switch (index) {
      case 0:
        return 'Visualiza información de manera clara y atractiva';
      case 1:
        return 'Contenido audiovisual sobre procedimientos y protocolos';
      case 2:
        return 'Documentación técnica y manuales de procedimientos';
      default:
        return 'Recursos de aprendizaje y capacitación';
    }
  }
}


