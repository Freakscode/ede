import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class InfoNoteWidget extends StatelessWidget {
  const InfoNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ThemeColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Nota: ',
                  style: TextStyle(
                    color: ThemeColors.azulSecundario,
                    fontFamily: 'Work Sans',
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 16 / 13,
                  ),
                ),
                TextSpan(
                  text:
                      'Máximo 3 imágenes permitidas. Cada imagen debe ser georreferenciada.',
                  style: TextStyle(
                    color: ThemeColors.azulSecundario,
                    fontFamily: 'Work Sans',
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: 16 / 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}