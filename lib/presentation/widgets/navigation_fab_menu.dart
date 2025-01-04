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
                    title: const Text('Identificación de la Evaluación'),
                    selected: currentRoute == '/id_evaluacion',
                    onTap: () {
                      context.pop(); // Cierra el modal
                      if (currentRoute != '/id_evaluacion') {
                        context.go('/id_evaluacion');
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Identificación de la Edificación'),
                    selected: currentRoute == '/id_edificacion',
                    onTap: () {
                      context.pop(); // Cierra el modal
                      if (currentRoute != '/id_edificacion') {
                        context.go('/id_edificacion');
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