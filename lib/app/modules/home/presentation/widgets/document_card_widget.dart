import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';

class DocumentCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String publishedDate;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const DocumentCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.publishedDate,
    this.onView,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(AppIcons.files, width: 48, height: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Work Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 16 / 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Publicado: $publishedDate',
                style: const TextStyle(
                  color: Color(0xFF706F6F),
                  fontFamily: 'Work Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
              Expanded(child: SizedBox.shrink()),
              InkWell(
                onTap: onView,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DAGRDColors.azulDAGRD.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: DAGRDColors.azulDAGRD,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Ver',
                        style: TextStyle(
                          color: DAGRDColors.azulDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: onDownload,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DAGRDColors.azulDAGRD.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppIcons.download,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          DAGRDColors.azulDAGRD,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Descargar',
                        style: TextStyle(
                          color: DAGRDColors.azulDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
