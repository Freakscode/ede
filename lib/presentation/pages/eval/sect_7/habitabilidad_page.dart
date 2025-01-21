import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../../../presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import '../../../../presentation/blocs/form/habitabilidad/habitabilidad_state.dart';
import '../../../../presentation/blocs/form/habitabilidad/habitabilidad_event.dart';
import '../../../../presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import '../../../../presentation/blocs/form/riesgosExternos/riesgos_externos_state.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_state.dart';
import '../../../../presentation/widgets/navigation_fab_menu.dart';

class HabitabilidadPage extends StatelessWidget {
  const HabitabilidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calcular habitabilidad al cargar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calcularHabitabilidad(context);
    });
    
    return BlocBuilder<RiesgosExternosBloc, RiesgosExternosState>(
      builder: (context, riesgosState) {
        return BlocBuilder<NivelDanoBloc, NivelDanoState>(
          builder: (context, nivelDanoState) {
            // Recalcular cuando cambien los estados
            _calcularHabitabilidad(context);
            
            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              appBar: AppBar(
                title: const Text('Habitabilidad'),
                backgroundColor: theme.colorScheme.surface,
                elevation: 2,
              ),
              floatingActionButton: const NavigationFabMenu(
                currentRoute: '/habitabilidad',
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHabitabilidadCard(theme),
                      const SizedBox(height: 32),
                      _buildClasificacionCard(theme),
                      const SizedBox(height: 32),
                      _buildResumenDatos(theme, riesgosState, nivelDanoState),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _calcularHabitabilidad(BuildContext context) {
    log('=== Calculando Habitabilidad ===');
    
    final riesgosState = context.read<RiesgosExternosBloc>().state;
    final nivelDanoState = context.read<NivelDanoBloc>().state;

    // Verificar que tengamos los datos necesarios
    if (riesgosState.riesgos.isEmpty || nivelDanoState.nivelDano == null) {
      log('Datos insuficientes para calcular habitabilidad');
      return;
    }

    // Mapear solo los riesgos externos de la sección 4
    final riesgosExternos = Map<String, RiesgoItem>.fromEntries(
      riesgosState.riesgos.entries
          .where((e) => RegExp(r'^4\.[1-6]$').hasMatch(e.key))
          .map((e) => MapEntry(e.key, e.value))
    );

    // Obtener nivel de daño
    final nivelDano = nivelDanoState.nivelDano ?? 'Sin daño';

    log('Riesgos externos: $riesgosExternos');
    log('Nivel de daño: $nivelDano');

    // Disparar evento para calcular habitabilidad
    context.read<HabitabilidadBloc>().add(
      CalcularHabitabilidad(
        riesgosExternos: riesgosExternos,
        nivelDano: nivelDano,
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
              '7.1 Criterio de Habitabilidad',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Determine el criterio de habitabilidad según la evaluación:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<HabitabilidadBloc, HabitabilidadState>(
              builder: (context, state) {
                final (color, icon, description) = _getHabitabilidadInfo(state.criterioHabitabilidad, theme);
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.criterioHabitabilidad ?? 'Sin evaluar',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
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

  Widget _buildClasificacionCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7.2 Clasificación',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleccione la clasificación específica de la edificación:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<HabitabilidadBloc, HabitabilidadState>(
              builder: (context, state) {
                final (codigo, descripcion) = _getClasificacionInfo(state.clasificacion);
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.secondary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        codigo,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (descripcion != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          descripcion,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
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

  (Color, IconData, String) _getHabitabilidadInfo(String? criterio, ThemeData theme) {
    switch (criterio) {
      case 'Habitable':
        return (
          Colors.green,
          Icons.check_circle,
          'La edificación es segura para su ocupación',
        );
      case 'Acceso restringido':
        return (
          Colors.orange,
          Icons.warning,
          'El acceso a la edificación debe ser limitado',
        );
      case 'No Habitable':
        return (
          Colors.red,
          Icons.dangerous,
          'La edificación no es segura para su ocupación',
        );
      default:
        return (
          Colors.grey,
          Icons.help,
          'Complete la evaluación para determinar la habitabilidad',
        );
    }
  }

  (String, String?) _getClasificacionInfo(String? clasificacion) {
    switch (clasificacion) {
      case 'H - Segura':
        return ('H', 'La edificación puede ser ocupada sin restricciones');
      case 'R1 - Áreas inseguras':
        return ('R1', 'Existen áreas específicas que no son seguras');
      case 'R2 - Entrada limitada':
        return ('R2', 'El acceso debe ser limitado y supervisado');
      case 'I1 - Riesgo externo':
        return ('I1', 'Riesgos externos hacen insegura la ocupación');
      case 'I2 - Afectación Funcional':
        return ('I2', 'La funcionalidad está comprometida');
      case 'I3 - Daño severo en la edificación':
        return ('I3', 'Daños estructurales severos');
      default:
        return ('?', null);
    }
  }

  Widget _buildResumenDatos(
    ThemeData theme,
    RiesgosExternosState riesgosState,
    NivelDanoState nivelDanoState,
  ) {
    // Filtrar solo los riesgos de la sección 4
    final riesgosSeccion4 = riesgosState.riesgos.entries
        .where((e) => RegExp(r'^4\.[1-6]$').hasMatch(e.key))
        .toList()
        ..sort((a, b) => a.key.compareTo(b.key));  // Ordenar por número

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Datos',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sección 4: Riesgos Externos',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...riesgosSeccion4.map((e) => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Text(
                '${e.key}: ${e.value.existeRiesgo ? "Sí" : "No"}${e.value.comprometeAccesos ? " (Compromete acceso)" : ""}',
                style: theme.textTheme.bodyMedium,
              ),
            )),
            const SizedBox(height: 16),
            Text(
              'Sección 6: Nivel de Daño',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Nivel de daño: ${nivelDanoState.nivelDano ?? "No establecido"}${nivelDanoState.nivelDano?.startsWith("I2") == true ? " (Caso especial)" : ""}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 