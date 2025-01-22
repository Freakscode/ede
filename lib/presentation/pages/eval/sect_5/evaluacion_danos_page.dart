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
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/evaluacion_danos',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle(
                theme,
                'Evaluación de Daños',
                'Registre los daños observados en la edificación',
                Icons.assessment,
              ),
              const SizedBox(height: 24),
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

  Widget _buildSectionTitle(ThemeData theme, String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCondicionesExistentes(ThemeData theme) {
    final condiciones = {
      '5.1': 'Colapso total',
      '5.2': 'Colapso parcial',
      '5.3': 'Asentamiento severo en elementos estructurales',
      '5.4': 'Inclinación o desviación importante de la edificación o de un piso',
      '5.5': 'Problemas de inestabilidad en el suelo de cimentación',
      '5.6': 'Riesgo de caídas de elementos de la edificación',
    };

    return Card(
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5.1 Condiciones Existentes',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Determinar la existencia de las siguientes condiciones:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  children: condiciones.entries.map((entry) {
                    final isSelected = state.condicionesExistentes[entry.key] == true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.secondary.withOpacity(0.1) : theme.colorScheme.surface,
                        border: Border.all(
                          color: isSelected 
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primary.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: theme.colorScheme.secondary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        title: Text(
                          entry.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.8),
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            _buildCustomRadio(
                              context,
                              entry.key,
                              true,
                              'Sí',
                              state.condicionesExistentes[entry.key],
                              theme,
                            ),
                            _buildCustomRadio(
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

  Widget _buildCustomRadio(
    BuildContext context,
    String key,
    bool value,
    String label,
    bool? groupValue,
    ThemeData theme,
  ) {
    final isSelected = groupValue == value;
    final isRedCondition = ['5.1', '5.2', '5.3', '5.4'].contains(key);
    final isOrangeCondition = ['5.5', '5.6'].contains(key);
    
    Color getColor() {
      if (!isSelected) return Colors.transparent;
      if (value == false) return Colors.green; // Para "No"
      if (isRedCondition) return Colors.red;
      if (isOrangeCondition) return Colors.orange;
      return theme.colorScheme.secondary;
    }

    Color getBorderColor() {
      if (!isSelected) return theme.colorScheme.primary.withOpacity(0.3);
      if (value == false) return Colors.green; // Para "No"
      if (isRedCondition) return Colors.red;
      if (isOrangeCondition) return Colors.orange;
      return theme.colorScheme.secondary;
    }

    Color getTextColor() {
      if (!isSelected) return theme.colorScheme.primary.withOpacity(0.7);
      return isSelected ? Colors.white : theme.colorScheme.primary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<EvaluacionDanosBloc>().add(
            SetCondicionExistente(key, value),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: getBorderColor(),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: getTextColor(),
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
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
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.build_circle,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5.2 Nivel de Daño en Elementos',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Establecer el nivel de daño de los siguientes elementos:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.read<EvaluacionDanosBloc>().add(
                                      SetNivelElemento(entry.key, nivelOption),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (nivelOption == 'Sin daño' 
                                              ? theme.colorScheme.surface 
                                              : _getNivelColor(nivelOption, theme).withOpacity(0.1))
                                          : theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? _getNivelColor(nivelOption, theme)
                                            : theme.colorScheme.primary.withOpacity(0.2),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      nivelOption,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: isSelected
                                            ? _getNivelColor(nivelOption, theme)
                                            : theme.colorScheme.primary.withOpacity(0.7),
                                        fontWeight: isSelected ? FontWeight.bold : null,
                                      ),
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
        return theme.colorScheme.primary.withOpacity(0.7);
      case 'Leve':
        return theme.colorScheme.secondary;
      case 'Moderado':
        return theme.colorScheme.error.withOpacity(0.7);
      case 'Severo':
        return theme.colorScheme.error;
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