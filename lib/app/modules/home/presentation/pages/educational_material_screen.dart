import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/infographic_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/section_header_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/video_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/document_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/material_tab_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/material_filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

/// Pantalla de Material Educativo que muestra recursos de aprendizaje
/// y capacitación para los usuarios de la aplicación.
class EducationalMaterialScreen extends StatefulWidget {
  const EducationalMaterialScreen({super.key});

  @override
  State<EducationalMaterialScreen> createState() =>
      _EducationalMaterialScreenState();
}

class _EducationalMaterialScreenState extends State<EducationalMaterialScreen> {
  // Constantes
  static const int _infographicsTabIndex = 0;
  static const int _videosTabIndex = 1;
  static const int _documentsTabIndex = 2;

  // Datos estáticos
  static const List<String> _filters = [
    'Todos',
    'Evaluación EDE',
    'Análisis del Riesgo',
    'Gestión del Riesgo',
    'Emergencias',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final selectedTab = state.educationalTabIndex;
        final selectedFilter = state.educationalFilter;
        
        return Column(
      children: [
        // Tabs de navegación - fijo arriba
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTab(
                    index: _infographicsTabIndex,
                    label: 'Infografías',
                    iconAsset: AppIcons.images,
                    selectedTab: selectedTab,
                  ),
                ),
                Expanded(
                  child: _buildTab(
                    index: _videosTabIndex,
                    label: 'Videos',
                    iconAsset: AppIcons.video,
                    selectedTab: selectedTab,
                  ),
                ),
                Expanded(
                  child: _buildTab(
                    index: _documentsTabIndex,
                    label: 'Documentos',
                    iconAsset: AppIcons.files,
                    selectedTab: selectedTab,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filtros - fijo debajo de tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildFilters(selectedFilter),
        ),

        const SizedBox(height: 24),

        // Contenido - scrollable
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildContent(selectedTab),
              const SizedBox(height: 24), // Espacio al final
            ],
          ),
        ),
      ],
    );
      },
    );
  }

  

  Widget _buildTab({
    required int index,
    required String label,
    required String iconAsset,
    required int selectedTab,
  }) {
    return MaterialTabWidget(
      index: index,
      label: label,
      iconAsset: iconAsset,
      isSelected: selectedTab == index,
      onTap: () {
        context.read<HomeBloc>().add(ChangeEducationalTab(index));
      },
    );
  }

  Widget _buildFilters(String selectedFilter) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];

          return MaterialFilterChipWidget(
            label: filter,
            isSelected: selectedFilter == filter,
            onTap: () {
              context.read<HomeBloc>().add(ChangeEducationalFilter(filter));
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(int selectedTab) {
    if (selectedTab == 0) {
      // Mostrar encabezado y card de infografía
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWidget(
            title: _getTitleForTab(selectedTab),
            description: _getDescriptionForTab(selectedTab),
          ),
          const SizedBox(height: 16),
          _buildInfographicCard(),
        ],
      );
    }

    if (selectedTab == 1) {
      // Mostrar encabezado y card de video
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWidget(
            title: _getTitleForTab(selectedTab),
            description: _getDescriptionForTab(selectedTab),
          ),
          const SizedBox(height: 16),
          _buildVideoCard(),
        ],
      );
    }

    // Tab de Documentos
    if (selectedTab == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWidget(
            title: _getTitleForTab(selectedTab),
            description: _getDescriptionForTab(selectedTab),
          ),
          const SizedBox(height: 16),
          _buildDocumentCard(),
        ],
      );
    }

    // Para otros tabs, mostrar contenido simple
    return SectionHeaderWidget(
      title: _getTitleForTab(selectedTab),
      description: _getDescriptionForTab(selectedTab),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDocumentCard() {
    return DocumentCardWidget(
      title: 'Manual de evaluación estructural',
      description:
          'Guía completa para la evaluación de daños estructurales post-sismo',
      publishedDate: '10/jul/2025',
      onView: () {
        // TODO: Implementar visualización del documento
      },
      onDownload: () {
        // TODO: Implementar descarga del documento
      },
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

  Widget _buildVideoCard() {
    return const VideoCardWidget(
      title: 'Protocolo de Seguridad en Emergencias',
      description: 'Video educativo sobre procedimientos de seguridad',
      duration: '12:45',
      publishedDate: '15/sep/2025',
      categoryBadge: 'Seguridad',
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
