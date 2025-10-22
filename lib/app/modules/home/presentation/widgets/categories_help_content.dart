import 'package:flutter/material.dart';
import '../../../../shared/widgets/dialogs/help_dialog.dart';

class CategoriesHelpContent {
  static Widget build() {
    return HelpContent(
      sections: [
        HelpSection(
          description: "La metodología de la aplicación se basa en un análisis multicriterio semi-cuantitativo considerando variables de amenaza y vulnerabilidad.",
        ),
        
        HelpSection(
          title: "1. Seleccione una categoría de análisis:",
          items: [
            HelpItem(
              text: "Amenaza:",
              description: "Evalúa la probabilidad de ocurrencia del fenómeno según sus características.",
            ),
            HelpItem(
              text: "Vulnerabilidad:",
              description: "Analiza las condiciones físicas, sociales y funcionales que pueden aumentar los impactos del fenómeno.",
            ),
          ],
        ),
        
        HelpSection(
          title: "2. Complete ambos formularios:",
          description: "Para realizar una evaluación completa del riesgo, debe completar tanto el formulario de Amenaza como el de Vulnerabilidad.",
          customWidget: const HelpNote(
            text: "Puedes guardar tu progreso frecuentemente usando el botón de guardar avance ubicado en la parte inferior de las variables.",
            icon: Icon(Icons.info_outline, size: 16, color: Colors.blue),
          ),
        ),
        
        HelpSection(
          title: "3. Resultados del riesgo:",
          description: "Al completar los formularios, se mostrarán los resultados en categorías ordinales (Alto, Medio-Alto, Medio-Bajo, Bajo).",
          customWidget: const HelpButtonExample(
            text: "Resultados Riesgo Movimiento en masa",
            backgroundColor: Colors.amber,
            textColor: Colors.black,
            icon: Icon(Icons.touch_app, size: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

