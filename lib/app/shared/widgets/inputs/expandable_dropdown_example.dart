import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/expandable_dropdown_field.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';

/// Ejemplo de uso del ExpandableDropdownField con diferentes categorías
class ExpandableDropdownExample extends StatefulWidget {
  const ExpandableDropdownExample({super.key});

  @override
  State<ExpandableDropdownExample> createState() => _ExpandableDropdownExampleState();
}

class _ExpandableDropdownExampleState extends State<ExpandableDropdownExample> {
  bool _isProbabilidadSelected = false;
  bool _isIntensidadSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown para Probabilidad
            ExpandableDropdownField(
              hint: 'Selecciona la probabilidad',
              isSelected: _isProbabilidadSelected,
              onTap: () {
                setState(() {
                  _isProbabilidadSelected = !_isProbabilidadSelected;
                  _isIntensidadSelected = false; // Cerrar el otro
                });
              },
              categories: [
                DropdownCategory.probabilidadDeslizamiento(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Dropdown para Intensidad
            ExpandableDropdownField(
              hint: 'Selecciona la intensidad',
              isSelected: _isIntensidadSelected,
              onTap: () {
                setState(() {
                  _isIntensidadSelected = !_isIntensidadSelected;
                  _isProbabilidadSelected = false; // Cerrar el otro
                });
              },
              categories: [
                DropdownCategory.intensidad(),
              ],
            ),

            const SizedBox(height: 16),

            // Dropdown personalizado con múltiples categorías
            ExpandableDropdownField(
              hint: 'Análisis completo',
              isSelected: false,
              categories: [
                DropdownCategory.probabilidadDeslizamiento(),
                DropdownCategory.intensidad(),
                DropdownCategory.custom(
                  title: 'Vulnerabilidad de infraestructura',
                  levels: ['BAJA', 'MEDIA', 'ALTA', 'MUY ALTA'],
                  detailedLevels: [
                    RiskLevel.bajo(
                      customItems: [
                        'Infraestructura nueva y bien mantenida.',
                        'Cumple con normas de construcción.',
                      ],
                    ),
                    RiskLevel.medioBajo(
                      customItems: [
                        'Infraestructura en buen estado.',
                        'Mantenimiento regular.',
                      ],
                    ),
                    RiskLevel.medioAlto(
                      customItems: [
                        'Infraestructura con algunos deterioros.',
                        'Mantenimiento ocasional.',
                      ],
                    ),
                    RiskLevel.alto(
                      customItems: [
                        'Infraestructura deteriorada.',
                        'Sin mantenimiento adecuado.',
                        'No cumple normas actuales.',
                      ],
                      customNote: 'NOTA: Requiere reforzamiento estructural inmediato',
                    ),
                  ],
                  additionalData: {
                    'category_type': 'vulnerability',
                    'assessment_date': DateTime.now().toIso8601String(),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}