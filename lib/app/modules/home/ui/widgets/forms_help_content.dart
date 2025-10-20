import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class FormsHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          description: "En esta sección encontrará el historial de formularios creados y cómo gestionarlos.",
        ),
        
        HelpSection(
          title: "1. Formularios en proceso",
          items: [
            HelpItem(
              text: "Muestran el avance del diligenciamiento en porcentaje (%).",
            ),
            HelpItem(
              text: "Incluyen el progreso de cada componente (Amenaza y Vulnerabilidad).",
            ),
            HelpItem(
              text: "Puedes elegir entre:",
            ),
          ],
          customWidget: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const HelpButtonExample(
                    text: "Continuar",
                    backgroundColor: Colors.blue,
                    icon: Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Para seguir completando el formulario pendiente.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.delete, size: 16, color: Colors.red),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Para descartar el formulario si ya no lo necesitas.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        HelpSection(
          title: "2. Formularios finalizados",
          items: [
            HelpItem(
              text: "Se guardan en la pestaña Finalizados.",
            ),
            HelpItem(
              text: "Desde allí podrá visualizarlos o descargarlos para su consulta o uso posterior.",
              trailing: const Text(
                "Link ayuda",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
