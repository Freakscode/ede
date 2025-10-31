import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormCardInProgress extends StatelessWidget {
  final String title;
  final String lastEdit;
  final String tag;
  final double progress;
  final double threat;
  final double vulnerability;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FormCardInProgress({
    super.key,
    required this.title,
    required this.lastEdit,
    required this.tag,
    required this.progress,
    required this.threat,
    required this.vulnerability,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.files,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  ThemeColors.azulDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 16 / 14,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.trash,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFDC2626),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Última edición:\n$lastEdit',
                style: const TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso',
                style: TextStyle(
                  color: ThemeColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amenaza',
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
              Text(
                '${(threat * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.5),
            child: LinearProgressIndicator(
              value: threat,
              minHeight: 9,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vulnerabilidad',
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(vulnerability * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 16 / 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.5),
            child: LinearProgressIndicator(
              value: vulnerability,
              minHeight: 9,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.azulDAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onTap,
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              label: const Text(
                'Continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
