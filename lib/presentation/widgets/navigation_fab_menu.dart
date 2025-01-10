import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationFabMenu extends StatelessWidget {
  final String currentRoute;

  const NavigationFabMenu({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: theme.colorScheme.surface,
          builder: (BuildContext context) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barra de arrastre
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Título
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Navegación',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  // Lista scrolleable
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _buildNavigationItem(
                          context,
                          'id_evaluacion',
                          '1. Identificación de la Evaluación',
                          Icons.assignment,
                        ),
                        _buildNavigationItem(
                          context,
                          'id_edificacion',
                          '2. Identificación de la Edificación',
                          Icons.business,
                        ),
                        _buildNavigationItem(
                          context,
                          'descripcion_edificacion',
                          '3. Descripción de la Edificación',
                          Icons.description,
                        ),
                        _buildNavigationItem(
                          context,
                          'riesgos_externos',
                          '4. Riesgos Externos',
                          Icons.warning,
                        ),
                        _buildNavigationItem(
                          context,
                          'evaluacion_danos',
                          '5. Evaluación de Daños',
                          Icons.build,
                        ),
                        _buildNavigationItem(
                          context,
                          'nivel_dano',
                          '6. Nivel de Daño',
                          Icons.assessment,
                        ),
                        _buildNavigationItem(
                          context,
                          'habitabilidad',
                          '7. Habitabilidad',
                          Icons.home,
                        ),
                        _buildNavigationItem(
                          context,
                          'acciones',
                          '8. Acciones Recomendadas',
                          Icons.recommend,
                        ),
                        _buildNavigationItem(
                          context,
                          'resumen',
                          'Resumen',
                          Icons.summarize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
        );
      },
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.primary,
      child: const Icon(Icons.menu),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    String route,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final bool isSelected = currentRoute == '/$route';
    
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.secondary.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          context.go('/$route');
        }
      },
    );
  }
} 