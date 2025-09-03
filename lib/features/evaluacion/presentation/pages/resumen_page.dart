import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form/identificacionEdificacion/id_edificacion_state.dart';
import '../bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../widgets/navigation_fab_menu.dart';

class ResumenPage extends StatelessWidget {
  const ResumenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de la Evaluación'),
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/resumen',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildIdentificacionEdificacion(context),
            // ... otros widgets del resumen
          ],
        ),
      ),
    );
  }

  Widget _buildIdentificacionEdificacion(BuildContext context) {
    return BlocBuilder<EdificacionBloc, EdificacionState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identificación de la Edificación',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Nombre:', state.nombreEdificacion ?? 'No especificado'),
                _buildInfoRow('Dirección:', state.direccion ?? 'No especificada'),
                _buildInfoRow('Departamento:', state.departamento ?? 'No especificado'),
                _buildInfoRow('Municipio:', state.municipio ?? 'No especificado'),
                _buildInfoRow('Comuna:', state.comuna ?? 'No especificada'),
                _buildInfoRow('Barrio:', state.barrio ?? 'No especificado'),
                _buildInfoRow('Código Catastral:', state.cbml ?? 'No especificado'),
                const Divider(height: 32),
                Text(
                  'Coordenadas GPS',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Latitud:', state.latitud != null ? '+${state.latitud}' : 'No especificada'),
                _buildInfoRow('Longitud:', state.longitud != null ? '-${state.longitud}' : 'No especificada'),
                const Divider(height: 32),
                Text(
                  'Persona de Contacto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Nombre:', state.nombreContacto ?? 'No especificado'),
                _buildInfoRow('Teléfono:', state.telefonoContacto ?? 'No especificado'),
                _buildInfoRow('Email:', state.emailContacto ?? 'No especificado'),
                _buildInfoRow('Ocupación:', state.ocupacion ?? 'No especificada'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 