import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class RatingHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          description: "En esta sección debe asignar una calificación a las variables de cada factor de amenaza.",
        ),
        
        HelpSection(
          title: "1. Cómo calificar:",
          items: [
            HelpItem(
              text: "Despliegue el factor de amenaza presionando sobre el para observar las variables a calificar.",
            ),
            HelpItem(
              text: "Cada variable puede calificarse de 1 a 4 por medio de los valores seleccionables BAJO(1), MEDIO-BAJO(2), MEDIO-ALTO(3) Y ALTO(4), o seleccionar \"No aplica\" si corresponde. Al elegir una opción de la escala, la interfaz muestra información adicional que describe el significado de esa calificación.",
              trailing: const Text(
                "Material ayuda",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
            HelpItem(
              text: "Valor por defecto: Todas las variables inician en 0. Si se dejan en 0, el sistema las interpreta como no calificadas.",
            ),
          ],
        ),
        
        HelpSection(
          title: "2. icono de información:",
          items: [
            HelpItem(
              text: "Permite consultar definiciones o detalles para orientar la calificación.",
              icon: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.black,
                ),
              ),
            ),
            HelpItem(
              text: "Guardar avance: Puede almacenar el progreso en cualquier momento y continuar más tarde.",
            ),
            HelpItem(
              text: "Navegación:",
            ),
          ],
          customWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const HelpButtonExample(
                    text: "Continuar",
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Avanza al siguiente paso del formulario.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const HelpButtonExample(
                    text: "Volver",
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Regresa a la sección anterior.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
