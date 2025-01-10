// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../presentation/blocs/form/evaluacion/evaluacion_bloc.dart';
import '../../../presentation/blocs/form/evaluacion/evaluacion_state.dart';
import '../../../presentation/widgets/navigation_fab_menu.dart';

class ResumenEvaluacionPage extends StatelessWidget {
  const ResumenEvaluacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Resumen de Evaluación'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/resumen_evaluacion',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIdentificacionCard(theme),
              const SizedBox(height: 32),
              _buildDanosCard(theme),
              const SizedBox(height: 32),
              _buildHabitabilidadCard(theme),
              const SizedBox(height: 32),
              _buildAccionesCard(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentificacionCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identificación de la Evaluación',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionBloc, EvaluacionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildInfoRow('Fecha', state.fechaInspeccion?.toString() ?? 'No especificada', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Hora', state.horaInspeccion?.toString() ?? 'No especificada', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('ID Grupo', state.idGrupo ?? 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('ID Evento', state.idEvento ?? 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Evento', state.eventoSeleccionado ?? 'No especificado', theme),
                    if (state.descripcionOtro != null) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow('Descripción otro evento', state.descripcionOtro!, theme),
                    ],
                    const SizedBox(height: 16),
                    _buildInfoRow('Dependencia/Entidad', state.dependenciaEntidad ?? 'No especificada', theme),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildDanosCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evaluación de Daños',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionBloc, EvaluacionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildInfoRow('Daños Estructurales', 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Daños No Estructurales', 'No especificado', theme),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitabilidadCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habitabilidad',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionBloc, EvaluacionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildInfoRow('Estado', 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Clasificación', 'No especificado', theme),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccionesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones Recomendadas',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionBloc, EvaluacionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildInfoRow('Evaluaciones Adicionales', 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Medidas de Seguridad', 'No especificado', theme),
                    const SizedBox(height: 16),
                    _buildInfoRow('Entidades Recomendadas', 'No especificado', theme),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 