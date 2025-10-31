import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget de card de video con imagen, badge, título, descripción y acciones
class VideoCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String publishedDate;
  final String categoryBadge;
  final String? videoUrl;
  final VoidCallback? onFavorite;
  final VoidCallback? onView;

  const VideoCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.publishedDate,
    required this.categoryBadge,
    this.videoUrl,
    this.onFavorite,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
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
          // Sección de imagen con badge e icono de video
          Stack(
            children: [
              // Preview del video de YouTube
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
                child: _buildVideoThumbnail(),
              ),
              // Badge de categoría
              _CategoryBadge(text: categoryBadge),
              // Icono de video en el centro
              Positioned(
                left: 148,
                top: 68,
                child: Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232B48).withOpacity(0.75),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.video,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              // Botón de vista
              Positioned(
                right: 10,
                bottom: 10,
                child: GestureDetector(
                  onTap: onView,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: ThemeColors.azulDAGRD,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.preview,
                     
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.negroDAGRD,
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
                        onPressed: onFavorite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ThemeColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    height: 16 / 12,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Duración: $duration • Publicado: $publishedDate',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF706F6F),
                          fontFamily: 'Work Sans',
                          height: 16 / 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  /// Construye el thumbnail del video de YouTube
  Widget _buildVideoThumbnail() {
    // Si no hay videoUrl, mostrar placeholder
    if (videoUrl == null || videoUrl!.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: Colors.grey,
        ),
      );
    }

    // Extraer el ID del video de YouTube
    final videoId = _extractYouTubeVideoId(videoUrl!);
    
    if (videoId == null) {
      return const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: Colors.grey,
        ),
      );
    }

    // Construir la URL del thumbnail de YouTube
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        errorBuilder: (context, error, stackTrace) {
          // Si falla al cargar el thumbnail, mostrar placeholder
          return const Center(
            child: Icon(
              Icons.image,
              size: 80,
              color: Colors.grey,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
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
}

/// Widget para el badge de categoría (ej: "Evaluación EDE")
class _CategoryBadge extends StatelessWidget {
  final String text;

  const _CategoryBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeColors.amarDAGRD,
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
}
