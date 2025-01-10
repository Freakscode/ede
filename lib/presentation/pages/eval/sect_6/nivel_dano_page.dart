import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_event.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_state.dart';
import '../../../../presentation/widgets/navigation_fab_menu.dart';

class NivelDanoPage extends StatelessWidget {
  const NivelDanoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Nivel de Daño'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/nivel_dano',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSeveridadDanos(theme),
              const SizedBox(height: 32),
              _buildNivelDano(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeveridadDanos(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6.2 Severidad de Daños',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La severidad se calcula automáticamente según la evaluación de daños:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<NivelDanoBloc, NivelDanoState>(
              builder: (context, state) {
                final severidadColor = _getSeveridadColor(state.severidadDanos, theme);
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: severidadColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: severidadColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: severidadColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getSeveridadIcon(state.severidadDanos),
                        color: severidadColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.severidadDanos ?? 'Sin evaluar',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: severidadColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSeveridadDescription(state.severidadDanos),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNivelDano(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6.3 Nivel de Daño',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'El nivel de daño se determina según el porcentaje y la severidad:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<NivelDanoBloc, NivelDanoState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getNivelDanoColor(state.nivelDano, theme).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getNivelDanoColor(state.nivelDano, theme),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getNivelDanoIcon(state.nivelDano),
                        color: _getNivelDanoColor(state.nivelDano, theme),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.nivelDano ?? 'No calculado',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: _getNivelDanoColor(state.nivelDano, theme),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getNivelDanoDescription(state.nivelDano),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeveridadColor(String? severidad, ThemeData theme) {
    switch (severidad) {
      case 'Bajo':
        return Colors.green;
      case 'Medio':
        return Colors.orange;
      case 'Alto':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getSeveridadIcon(String? severidad) {
    switch (severidad) {
      case 'Bajo':
        return Icons.check_circle;
      case 'Medio':
        return Icons.warning;
      case 'Alto':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getSeveridadDescription(String? severidad) {
    switch (severidad) {
      case 'Bajo':
        return 'Daños menores que no comprometen la estructura';
      case 'Medio':
        return 'Daños moderados que requieren atención';
      case 'Alto':
        return 'Daños severos que comprometen la estructura';
      default:
        return 'Complete la evaluación de daños para calcular la severidad';
    }
  }

  Color _getNivelDanoColor(String? nivel, ThemeData theme) {
    switch (nivel) {
      case 'Sin Daño':
        return Colors.green;
      case 'Bajo':
        return Colors.lightGreen;
      case 'Medio':
        return Colors.orange;
      case 'Alto':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getNivelDanoIcon(String? nivel) {
    switch (nivel) {
      case 'Sin Daño':
        return Icons.check_circle;
      case 'Bajo':
        return Icons.info;
      case 'Medio':
        return Icons.warning;
      case 'Alto':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getNivelDanoDescription(String? nivel) {
    switch (nivel) {
      case 'Sin Daño':
        return 'La edificación no presenta daños significativos';
      case 'Bajo':
        return 'Daños leves que no afectan la funcionalidad';
      case 'Medio':
        return 'Daños que requieren reparaciones importantes';
      case 'Alto':
        return 'Daños graves que comprometen la estabilidad';
      default:
        return 'Complete la evaluación para determinar el nivel de daño';
    }
  }
} 