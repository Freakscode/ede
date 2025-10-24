import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class ImageUploadAreaWidget extends StatelessWidget {
  final VoidCallback onSelectFromGallery;
  final VoidCallback onTakePhoto;

  const ImageUploadAreaWidget({
    super.key,
    required this.onSelectFromGallery,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: DAGRDColors.surface,
        border: Border.all(
          color: DAGRDColors.outlineVariant,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUploadOption(
            icon: AppIcons.images,
            label: 'Imágenes',
            onTap: onSelectFromGallery,
          ),
          _buildUploadOption(
            icon: AppIcons.camera,
            label: 'Cámara',
            onTap: onTakePhoto,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 46,
              height: 46,
              colorFilter: const ColorFilter.mode(
                DAGRDColors.grisMedio,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DAGRDColors.grisMedio,
                fontFamily: 'Work Sans',
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 20 / 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}