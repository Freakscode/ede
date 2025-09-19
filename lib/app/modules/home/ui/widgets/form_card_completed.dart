import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormCardCompleted extends StatelessWidget {
  final String title;
  final String lastEdit;
  final String tag;
  

  const FormCardCompleted({
    super.key,
    required this.title,
    required this.lastEdit,
    required this.tag,
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
                  DAGRDColors.azulDAGRD,
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
                      onPressed: () {},
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
                'Completado: $lastEdit',
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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azulDAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              icon: SvgPicture.asset(
                AppIcons.download,
                width: 29,
                height: 27,
                colorFilter: const ColorFilter.mode(
                  DAGRDColors.blancoDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text(
                'Descargar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.blancoDAGRD,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.amarDAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              icon: SvgPicture.asset(
                AppIcons.link,
                width: 29,
                height: 27,
                colorFilter: const ColorFilter.mode(
                  DAGRDColors.negroDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text(
                'Asociar a SIRE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azul3DAGRD,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              icon: SvgPicture.asset(
                AppIcons.send,
                width: 29,
                height: 27,
                colorFilter: const ColorFilter.mode(
                  DAGRDColors.blancoDAGRD,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text(
                'Enviar por correo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DAGRDColors.blancoDAGRD,
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
