import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class HomeHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          description: "Desde esta pantalla puede acceder a las principales herramientas de la aplicación:",
        ),
        
        HelpSection(
          title: "1. Herramientas de evaluación:",
          items: [
            HelpItem(
              icon: const Text(
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Metodología de Análisis del Riesgo: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Permite estimar el nivel de riesgo a partir de la relación entre amenaza y vulnerabilidad. ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Ver documento Metodología de Análisis del Riesgo",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2563EB),
                      decoration: TextDecoration.underline,
                      height: 1.615,
                    ),
                  ),
                ],
              ),
            ),
            HelpItem(
              icon: const Text(
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Evaluación del Daño en Edificaciones (EDE): ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Facilita el registro y análisis del nivel de afectación en edificaciones.",
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
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Formulario de caracterización de movimientos en masa: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Recoge información detallada para describir y analizar este tipo de fenómenos.",
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
          title: "2. Menú inferior de navegación:",
          items: [
            HelpItem(
              icon: const Text(
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Inicio: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Vuelve a esta pantalla principal.",
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
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Material educativo: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Acceda a infografías, videos y documentos relacionados con la gestión del riesgo y el uso de estas herramientas.",
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
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Mis formularios: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Consulte el historial de formularios realizados o en proceso. Aquí puede continuar con los formularios pendientes o descargar los finalizados.",
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
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Configuración: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Personalice las opciones de la aplicación según sus necesidades.",
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
          title: "3. Opciones superiores:",
          items: [
            HelpItem(
              icon: const Text(
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Ayuda: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        size: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: "Muestra esta orientación en cualquier momento.",
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
                "•",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                  height: 1.615,
                ),
              ),
              textSpan: TextSpan(
                children: [
                  const TextSpan(
                    text: "Perfil de usuario: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: "Si es un usuario DAGRD, podrá acceder a un perfil con opciones avanzadas.",
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
      ],
    );
  }
}
