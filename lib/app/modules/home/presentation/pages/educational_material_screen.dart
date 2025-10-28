import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/infographic_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/section_header_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/video_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/document_card_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/material_tab_widget.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/material_filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

/// Modelo de datos para materiales educativos
class EducationalMaterial {
  final String id;
  final String title;
  final String description;
  final String publishedDate;
  final String category;
  final String? duration; // Solo para videos
  final String? videoUrl; // URL del video de YouTube
  final String? imageUrl; // URL de la imagen (para infografías)
  final String type; // 'infographic', 'video', 'document'

  const EducationalMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.publishedDate,
    required this.category,
    this.duration,
    this.videoUrl,
    this.imageUrl,
    required this.type,
  });
}

/// Datos de ejemplo para materiales educativos
final List<EducationalMaterial> _infographicMaterials = [
  EducationalMaterial(
    id: 'inf_1',
    title: 'Gestión del Riesgo - Definiciones generales',
    description: 'Material educativo Gestión del Riesgo',
    publishedDate: '10/jul/2025',
    category: 'Evaluación EDE',
    imageUrl:
        'https://sigred.pascualbravo.edu.co:23443/files/istockphoto-1318666502-612x612.jpg',
    type: 'infographic',
  ),
  const EducationalMaterial(
    id: 'inf_2',
    title: 'Mapas de Amenaza Natural',
    description: 'Guía de interpretación de mapas de amenaza',
    publishedDate: '15/ago/2025',
    category: 'Análisis del Riesgo',
    imageUrl:
        'https://www.medellin.gov.co/es/wp-content/uploads/2025/10/Imagen-de-ponente-en-evento.jpg',

    type: 'infographic',
  ),
  const EducationalMaterial(
    id: 'inf_3',
    title: 'Protocolo de Emergencias',
    description: 'Procedimientos para respuesta ante emergencias',
    publishedDate: '20/sep/2025',
    imageUrl:
        'https://sigred.pascualbravo.edu.co:23443/files/istockphoto-1318666502-612x612.jpg',
    category: 'Emergencias',
    type: 'infographic',
  ),
];

final List<EducationalMaterial> _videoMaterials = [
  EducationalMaterial(
    id: 'vid_1',
    title: 'Protocolo de Seguridad en Emergencias',
    description: 'Video educativo sobre procedimientos de seguridad',
    duration: '12:45',
    publishedDate: '15/sep/2025',
    category: 'Seguridad',
    videoUrl: 'https://www.youtube.com/watch?v=nlAuuffksms',
    type: 'video',
  ),
  const EducationalMaterial(
    id: 'vid_2',
    title: 'Evaluación de Daños Estructurales',
    description: 'Tutorial paso a paso para evaluación EDE',
    duration: '25:30',
    publishedDate: '10/jul/2025',
    category: 'Evaluación EDE',
    videoUrl: 'https://www.youtube.com/watch?v=nlAuuffksms',
    type: 'video',
  ),
  const EducationalMaterial(
    id: 'vid_3',
    title: 'Manejo de Emergencias en Campo',
    description: 'Técnicas de respuesta en situaciones de emergencia',
    duration: '18:20',
    publishedDate: '05/oct/2025',
    videoUrl: 'https://www.youtube.com/watch?v=nlAuuffksms',
    category: 'Emergencias',
    type: 'video',
  ),
];

final List<EducationalMaterial> _documentMaterials = [
  const EducationalMaterial(
    id: 'doc_1',
    title: 'Manual de evaluación estructural',
    description:
        'Guía completa para la evaluación de daños estructurales post-sismo',
    publishedDate: '10/jul/2025',
    category: 'Evaluación EDE',
    type: 'document',
  ),
  const EducationalMaterial(
    id: 'doc_2',
    title: 'Guía de Análisis de Riesgos',
    description: 'Metodología para análisis de riesgos naturales',
    publishedDate: '15/ago/2025',
    category: 'Análisis del Riesgo',
    type: 'document',
  ),
  const EducationalMaterial(
    id: 'doc_3',
    title: 'Protocolo de Gestión de Riesgos',
    description: 'Manual de procedimientos para gestión integral de riesgos',
    publishedDate: '20/sep/2025',
    category: 'Gestión del Riesgo',
    type: 'document',
  ),
  const EducationalMaterial(
    id: 'doc_4',
    title: 'Plantillas de Evaluación EDE',
    description: 'Documentos PDF con plantillas para evaluaciones EDE',
    publishedDate: '10/jul/2025',
    category: 'Evaluación EDE',
    type: 'document',
  ),
];

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
    'Seguridad',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: _getTitleForTab(selectedTab),
          description: _getDescriptionForTab(selectedTab),
        ),
        const SizedBox(height: 16),
        _buildMaterialList(selectedTab),
      ],
    );
  }

  Widget _buildMaterialList(int selectedTab) {
    if (selectedTab == 0) {
      return _buildFilteredInfographics();
    } else if (selectedTab == 1) {
      return _buildFilteredVideos();
    } else if (selectedTab == 2) {
      return _buildFilteredDocuments();
    }
    return const SizedBox.shrink();
  }

  Widget _buildFilteredInfographics() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final filteredMaterials = _filterMaterials(
          _infographicMaterials,
          state.educationalFilter,
        );

        if (filteredMaterials.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No hay infografías disponibles para este filtro',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: filteredMaterials.map((material) {
            final index = filteredMaterials.indexOf(material);
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                _buildInfographicCard(material),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilteredVideos() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final filteredMaterials = _filterMaterials(
          _videoMaterials,
          state.educationalFilter,
        );

        if (filteredMaterials.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No hay videos disponibles para este filtro',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: filteredMaterials.map((material) {
            final index = filteredMaterials.indexOf(material);
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                _buildVideoCard(material),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilteredDocuments() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final filteredMaterials = _filterMaterials(
          _documentMaterials,
          state.educationalFilter,
        );

        if (filteredMaterials.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No hay documentos disponibles para este filtro',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: filteredMaterials.map((material) {
            final index = filteredMaterials.indexOf(material);
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                _buildDocumentCard(material),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  List<EducationalMaterial> _filterMaterials(
    List<EducationalMaterial> materials,
    String filter,
  ) {
    if (filter == 'Todos') {
      return materials;
    }
    return materials.where((material) => material.category == filter).toList();
  }

  Widget _buildDocumentCard(EducationalMaterial material) {
    return DocumentCardWidget(
      title: material.title,
      description: material.description,
      publishedDate: material.publishedDate,
      onView: () {
        // TODO: Implementar visualización del documento
      },
      onDownload: () {
        // TODO: Implementar descarga del documento
      },
    );
  }

  Widget _buildInfographicCard(EducationalMaterial material) {
    return InfographicCardWidget(
      title: material.title,
      description: material.description,
      publishedDate: material.publishedDate,
      categoryBadge: material.category,
      imageUrl: material.imageUrl,
    );
  }

  Widget _buildVideoCard(EducationalMaterial material) {
    return VideoCardWidget(
      title: material.title,
      description: material.description,
      duration: material.duration ?? '00:00',
      publishedDate: material.publishedDate,
      categoryBadge: material.category,
      videoUrl: material.videoUrl,
      onView: () {
        _handleVideoView(material.videoUrl);
      },
    );
  }

  Future<void> _handleVideoView(String? videoUrl) async {
    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }

    if (!context.mounted) return;

    try {
      // Extraer el ID del video de YouTube
      final videoId = _extractYouTubeVideoId(videoUrl);

      if (videoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL de video inválida'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Crear URL embebida de YouTube con parámetros adicionales
      final embedUrl =
          'https://www.youtube.com/embed/$videoId?enablejsapi=1&rel=0&modestbranding=1';

      // Mostrar el diálogo con el video
      _showVideoDialog(context, embedUrl, videoUrl);
    } catch (e) {
      // Mostrar mensaje de error si hay una excepción
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el video: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Extrae el ID del video de YouTube desde la URL
  String? _extractYouTubeVideoId(String url) {
    // Formato: https://www.youtube.com/watch?v=VIDEO_ID
    final regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  /// Muestra un diálogo con el video de YouTube embebido
  void _showVideoDialog(
    BuildContext context,
    String embedUrl,
    String originalUrl,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header con botón de cerrar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reproductor de Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // WebView con el video
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(Colors.black)
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onPageStarted: (String url) {
                              // Opcional: mostrar loading indicator
                            },
                            onPageFinished: (String url) {
                              // Opcional: ocultar loading indicator
                            },
                            onWebResourceError: (WebResourceError error) {
                              // Manejar errores de carga del video
                              Navigator.of(context).pop();
                              _showVideoErrorDialog(context, originalUrl);
                            },
                          ),
                        )
                        ..loadRequest(Uri.parse(embedUrl)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Muestra un diálogo de error con opción de abrir en YouTube
  void _showVideoErrorDialog(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error al reproducir el video'),
          content: const Text(
            'No se pudo reproducir el video en la aplicación. ¿Deseas abrirlo en YouTube?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openVideoInYouTube(videoUrl);
              },
              child: const Text('Abrir en YouTube'),
            ),
          ],
        );
      },
    );
  }

  /// Abre el video en YouTube externa
  Future<void> _openVideoInYouTube(String videoUrl) async {
    try {
      final Uri url = Uri.parse(videoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Ignorar error
    }
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
