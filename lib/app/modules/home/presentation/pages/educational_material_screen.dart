import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
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
      // Mostrar card de infografía
      return _buildInfographicCard();
    }
    
    // Para otros tabs, mostrar contenido simple
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTitleForTab(_selectedTab),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3E50),
              fontFamily: 'Work Sans',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getDescriptionForTab(_selectedTab),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF5C6F80),
              fontFamily: 'Work Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfographicCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de imagen con badge
          Stack(
            children: [
              // Placeholder para imagen
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              // Badge Evaluación EDE
              _buildCategoryBadge('Evaluación EDE'),
              // Botón de vista
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: DAGRDColors.azulDAGRD,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.preview,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Sección de contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Gestión del Riesgo - Definiciones generales',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: DAGRDColors.negroDAGRD,
                          fontFamily: 'Work Sans',
                          height: 16 / 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          AppIcons.star,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Material educativo Gestión del Riesgo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: DAGRDColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    height: 16 / 12,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Publicado: 10/jul/2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF706F6F),
                        fontFamily: 'Work Sans',
                        height: 16 / 12,
                      ),
                    ),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              AppIcons.download,
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF2563EB),
                                BlendMode.srcIn,
                              ),
                            ),
                            label: const Text(
                              'Descargar',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontFamily: 'Work Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 16 / 12,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para el badge de categoría (ej: "Evaluación EDE")
  Widget _buildCategoryBadge(String text) {
    return Positioned(
      left: 10,
      top: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: DAGRDColors.amarDAGRD,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontFamily: 'Work Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ),
      ),
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


