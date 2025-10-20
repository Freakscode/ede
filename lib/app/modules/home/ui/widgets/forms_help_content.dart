import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class FormsHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          description: "En esta sección encontrará el historial de formularios que has creado en la aplicación. Puedes gestionarlos de la siguiente manera:",
        ),
        
        HelpSection(
          title: "1. Formularios en proceso",
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
                    text: "Muestran el avance del diligenciamiento en porcentaje (%).",
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
                    text: "Incluyen el progreso de cada componente (Amenaza y Vulnerabilidad).",
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
                    text: "Puedes elegir entre:",
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
                "  •",
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
                    text: "Continuar: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text(
                            "Continuar",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Work Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: "Para seguir completando el formulario pendiente.",
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
                "  •",
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
                    text: "Ícono Eliminar: ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.delete, size: 16, color: Colors.red),
                    ),
                  ),
                  const TextSpan(
                    text: "Para descartar el formulario si ya no lo necesitas.",
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
          title: "2. Formularios finalizados",
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
                    text: "Se guardan en la pestaña Finalizados.",
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
                    text: "Desde allí podrá visualizarlos o descargarlos para su consulta o uso posterior. ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      height: 1.615,
                    ),
                  ),
                  const TextSpan(
                    text: "Link ayuda",
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
          ],
        ),
      ],
    );
  }
}

