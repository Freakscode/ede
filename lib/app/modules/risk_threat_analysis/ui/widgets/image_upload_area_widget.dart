import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';

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
        color: const Color(0xFFFFFFFF),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
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
                Color(0xFF6B7280),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF706F6F),
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