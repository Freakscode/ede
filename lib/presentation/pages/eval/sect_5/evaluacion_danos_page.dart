import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_event.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_state.dart';
import '../../../../presentation/widgets/navigation_fab_menu.dart';

class EvaluacionDanosPage extends StatelessWidget {
  const EvaluacionDanosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Evaluación de Daños'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/evaluacion_danos',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCondicionesExistentes(theme),
              const SizedBox(height: 24),
              _buildNivelesElementos(theme),
              const SizedBox(height: 24),
              _buildAlcanceEvaluacion(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCondicionesExistentes(ThemeData theme) {
    final condiciones = {
      '5.1': 'Colapso total',
      '5.2': 'Colapso parcial',
      '5.3': 'Asentamiento severo en elementos estructurales',
      '5.4': 'Inclinación o desviación importante de la edificación o de un piso',
      '5.5': 'Problemas de inestabilidad en el suelo de cimentación (Movimiento en masa, licuefacción, subsidencia, cambios volumétricos, asentamientos)',
      '5.6': 'Riesgo de caídas de elementos de la edificación (antepechos, fachadas, ventanas, etc.)',
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5.1 Condiciones Existentes',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Determinar la existencia de las siguientes condiciones:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  children: condiciones.entries.map((entry) {
                    final isSelected = state.condicionesExistentes[entry.key] == true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.secondary.withOpacity(0.1) : null,
                        border: Border.all(
                          color: isSelected 
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          entry.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected ? theme.colorScheme.primary : null,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildRadioOption(
                              context,
                              entry.key,
                              true,
                              'Sí',
                              state.condicionesExistentes[entry.key],
                              theme,
                            ),
                            const SizedBox(width: 16),
                            _buildRadioOption(
                              context,
                              entry.key,
                              false,
                              'No',
                              state.condicionesExistentes[entry.key],
                              theme,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNivelesElementos(ThemeData theme) {
    final elementos = {
      '5.7': 'Daño en muros de carga, columnas, y otros elementos estructurales primordiales',
      '5.8': 'Daño en sistemas de contrapiso, entrepiso, muros de contención',
      '5.9': 'Daño en muros divisorios, muros de fachada, antepechos, barandas',
      '5.10': 'Cubierta (recubrimiento y estructura de soporte)',
      '5.11': 'Cielo raso, escaleras, instalaciones y otros elementos no estructurales diferentes a muros',
    };

    final niveles = ['Sin daño', 'Leve', 'Moderado', 'Severo'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5.2 Nivel de Daño en Elementos',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Establecer el nivel de daño de los siguientes elementos:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  children: elementos.entries.map((entry) {
                    final nivel = state.nivelesElementos[entry.key];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _getNivelColor(nivel, theme).withOpacity(0.05),
                        border: Border.all(
                          color: nivel != null
                              ? _getNivelColor(nivel, theme)
                              : theme.colorScheme.primary.withOpacity(0.1),
                          width: nivel != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getNivelIcon(nivel),
                                color: _getNivelColor(nivel, theme),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: nivel != null
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.primary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: niveles.map((nivelOption) {
                              final isSelected = nivel == nivelOption;
                              return InkWell(
                                onTap: () {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetNivelElemento(entry.key, nivelOption),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.secondary.withOpacity(0.1)
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    nivelOption,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.primary.withOpacity(0.7),
                                      fontWeight: isSelected ? FontWeight.bold : null,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcanceEvaluacion(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5.3 Alcance de la Evaluación',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Indique el alcance de la evaluación realizada:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluación Exterior',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildAlcanceOption(
                      context,
                      'Parcial',
                      'Se evaluó parcialmente el exterior',
                      state.alcanceExterior == 'Parcial',
                      theme,
                      (value) => context.read<EvaluacionDanosBloc>().add(
                        SetAlcanceEvaluacion(alcanceExterior: value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAlcanceOption(
                      context,
                      'Completa',
                      'Se evaluó completamente el exterior',
                      state.alcanceExterior == 'Completa',
                      theme,
                      (value) => context.read<EvaluacionDanosBloc>().add(
                        SetAlcanceEvaluacion(alcanceExterior: value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Evaluación Interior',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildAlcanceOption(
                      context,
                      'No Ingreso',
                      'No se pudo ingresar al interior',
                      state.alcanceInterior == 'No Ingreso',
                      theme,
                      (value) => context.read<EvaluacionDanosBloc>().add(
                        SetAlcanceEvaluacion(alcanceInterior: value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAlcanceOption(
                      context,
                      'Parcial',
                      'Se evaluó parcialmente el interior',
                      state.alcanceInterior == 'Parcial',
                      theme,
                      (value) => context.read<EvaluacionDanosBloc>().add(
                        SetAlcanceEvaluacion(alcanceInterior: value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAlcanceOption(
                      context,
                      'Completa',
                      'Se evaluó completamente el interior',
                      state.alcanceInterior == 'Completa',
                      theme,
                      (value) => context.read<EvaluacionDanosBloc>().add(
                        SetAlcanceEvaluacion(alcanceInterior: value),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String key,
    bool value,
    String label,
    bool? groupValue,
    ThemeData theme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: value,
          groupValue: groupValue,
          activeColor: theme.colorScheme.secondary,
          onChanged: (newValue) {
            context.read<EvaluacionDanosBloc>().add(
              SetCondicionExistente(key, newValue),
            );
          },
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: groupValue == value
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAlcanceOption(
    BuildContext context,
    String title,
    String description,
    bool isSelected,
    ThemeData theme,
    Function(String) onSelected,
  ) {
    return InkWell(
      onTap: () => onSelected(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.secondary.withOpacity(0.1) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: title,
              groupValue: isSelected ? title : null,
              onChanged: (value) => onSelected(value!),
              activeColor: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNivelColor(String? nivel, ThemeData theme) {
    switch (nivel) {
      case 'Sin daño':
        return Colors.green;
      case 'Leve':
        return Colors.lightGreen;
      case 'Moderado':
        return Colors.orange;
      case 'Severo':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getNivelIcon(String? nivel) {
    switch (nivel) {
      case 'Sin daño':
        return Icons.check_circle;
      case 'Leve':
        return Icons.info;
      case 'Moderado':
        return Icons.warning;
      case 'Severo':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
} 