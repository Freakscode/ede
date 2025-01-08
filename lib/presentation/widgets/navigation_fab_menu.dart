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
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Navegación',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text('1. Identificación de la Evaluación'),
                    selected: currentRoute == '/id_evaluacion',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/id_evaluacion') {
                        context.go('/id_evaluacion');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('2. Identificación de la Edificación'),
                    selected: currentRoute == '/id_edificacion',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/id_edificacion') {
                        context.go('/id_edificacion');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('3. Descripción de la Edificación'),
                    selected: currentRoute == '/descripcion_edificacion',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/descripcion_edificacion') {
                        context.go('/descripcion_edificacion');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.warning),
                    title: const Text('4. Riesgos Externos'),
                    selected: currentRoute == '/riesgos_externos',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/riesgos_externos') {
                        context.go('/riesgos_externos');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.build),
                    title: const Text('5. Evaluación de Daños'),
                    selected: currentRoute == '/evaluacion_danos',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/evaluacion_danos') {
                        context.go('/evaluacion_danos');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.assessment),
                    title: const Text('6. Nivel de Daño'),
                    selected: currentRoute == '/nivel_dano',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/nivel_dano') {
                        context.go('/nivel_dano');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('7. Habitabilidad'),
                    selected: currentRoute == '/habitabilidad',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/habitabilidad') {
                        context.go('/habitabilidad');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.recommend),
                    title: const Text('8. Acciones Recomendadas'),
                    selected: currentRoute == '/acciones',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/acciones') {
                        context.go('/acciones');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.summarize),
                    title: const Text('Resumen'),
                    selected: currentRoute == '/resumen',
                    onTap: () {
                      context.pop();
                      if (currentRoute != '/resumen') {
                        context.go('/resumen');
                      }
                    },
                  ),
                ],
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
      child: const Icon(Icons.menu),
    );
  }
} 