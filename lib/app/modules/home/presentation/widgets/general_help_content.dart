import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class GeneralHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          items: [
            HelpItem(
              textSpan: TextSpan(
                text: "Esta sección te permite realizar una evaluación de amenazas en 3 sencillos pasos:",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1E1E1E),
                  height: 1.615, // 161.538%
                ),
              ),
            ),
            HelpItem(
              icon: const Text(
                "1.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Información General: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Introduce los datos básicos de la evaluación",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                ],
              ),
            ),
            HelpItem(
              icon: const Text(
                "2.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Calificación Detallada: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Evalúa los factores específicos de probabilidad e intensidad.",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                ],
              ),
            ),
            HelpItem(
              icon: const Text(
                "3.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Evidencia Fotográfica: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Añade fotos para documentar la situación.",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        HelpSection(
          description: "Puedes navegar entre pasos usando los ícono del menu de la parte inferior o con los botones de anterior y siguiente.",
        ),
        
        HelpSection(
          customWidget: Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF), // #EFF6FF background
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFDBEAFE), width: 1), // #DBEAFE border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Consejo: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB), // Azul-informativo
                          fontFamily: 'Work Sans',
                          height: 20 / 14, // 142.857%
                        ),
                      ),
                      TextSpan(
                        text: "Guarda tu progreso frecuentemente usando el botón de guardar ubicado en la parte superior derecha",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2563EB), // Azul-informativo
                          fontFamily: 'Work Sans',
                          height: 20 / 14, // 142.857%
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
