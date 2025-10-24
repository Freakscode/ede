import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/form/nivelDano/nivel_dano_bloc.dart';
import '../../bloc/form/nivelDano/nivel_dano_state.dart';
import '../../bloc/form/nivelDano/nivel_dano_event.dart';
import '../../bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import '../../bloc/form/riesgosExternos/riesgos_externos_state.dart';
import '../../bloc/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../../bloc/form/evaluacionDanos/evaluacion_danos_state.dart';
import '../../widgets/navigation_fab_menu.dart';
import 'dart:developer';

class NivelDanoPage extends StatelessWidget {
  const NivelDanoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<RiesgosExternosBloc, RiesgosExternosState>(
      builder: (context, riesgosState) {
        return BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
          builder: (context, danosState) {
            // Calcular severidad cada vez que se actualice cualquier estado
            _calcularSeveridad(context, riesgosState, danosState);
            
            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              appBar: AppBar(
                title: const Text('Nivel de Daño'),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.surface,
                elevation: 0,
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
                      _buildPorcentajeAfectacion(context),
                      const SizedBox(height: 32),
                      _buildSeveridadDanos(theme),
                      const SizedBox(height: 32),
                      _buildNivelDano(theme),
                      const SizedBox(height: 32),
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

  void _calcularSeveridad(
    BuildContext context,
    RiesgosExternosState riesgosState,
    EvaluacionDanosState danosState,
  ) {
    log('=== Iniciando cálculo de severidad ===');
    
    // Obtener condiciones existentes
    final condicionesExistentes = Map<String, bool>.from(danosState.condicionesExistentes);
    final nivelesElementos = Map<String, String>.from(danosState.nivelesElementos);
    
    // Verificar condiciones para ALTO
    bool esAlto = false;
    // Si alguna de las primeras 4 condiciones es SI
    if (['5.1', '5.2', '5.3', '5.4'].any((id) => condicionesExistentes[id] == true)) {
      esAlto = true;
    }
    // O si el daño estructural (5.7) es severo
    if (nivelesElementos['5.7'] == 'Severo') {
      esAlto = true;
    }

    // Verificar condiciones para MEDIO ALTO
    bool esMedioAlto = false;
    if (!esAlto) {
      // Si 5.5 o 5.6 es SI
      if (['5.5', '5.6'].any((id) => condicionesExistentes[id] == true)) {
        esMedioAlto = true;
      }
      // O si el daño estructural (5.7) es moderado
      if (nivelesElementos['5.7'] == 'Moderado') {
        esMedioAlto = true;
      }
    }

    // Verificar condiciones para MEDIO
    bool esMedio = false;
    if (!esAlto && !esMedioAlto) {
      // Si alguno de los elementos no estructurales tiene daño moderado
      if (['5.8', '5.9', '5.10', '5.11'].any((id) => nivelesElementos[id] == 'Moderado')) {
        esMedio = true;
      }
    }

    // Verificar condiciones para BAJO
    bool esBajo = false;
    if (!esAlto && !esMedioAlto && !esMedio) {
      // Si todas las condiciones son NO y hay daños leves
      if (['5.1', '5.2', '5.3', '5.4', '5.5', '5.6'].every((id) => condicionesExistentes[id] == false) &&
          ['5.7', '5.8', '5.9', '5.10', '5.11'].any((id) => nivelesElementos[id] == 'Leve')) {
        esBajo = true;
      }
    }

    // Determinar la severidad final
    String severidad;
    if (esAlto) {
      severidad = 'Alto';
    } else if (esMedioAlto) {
      severidad = 'Medio Alto';
    } else if (esMedio) {
      severidad = 'Medio';
    } else if (esBajo) {
      severidad = 'Bajo';
    } else {
      severidad = 'Sin Daño';
    }

    log('Severidad calculada: $severidad');
    
    // Disparar el evento para actualizar la severidad
    context.read<NivelDanoBloc>().add(
      CalcularSeveridadDanos(
        condicionesExistentes: condicionesExistentes,
        nivelesElementos: nivelesElementos,
      ),
    );
  }

  Widget _buildPorcentajeAfectacion(BuildContext context) {
    final theme = Theme.of(context);
    final porcentajes = [
      'Ninguno',
      '< 10%',
      '10-40%',
      '40-70%',
      '>70%'
    ];

    return Card(
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Icons.percent_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '6.1 Porcentaje de Afectación de la Edificación en Planta',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Indique el porcentaje de afectación de la edificación en planta',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<NivelDanoBloc, NivelDanoState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: porcentajes.map((porcentaje) {
                    final isSelected = state.porcentajeAfectacion == porcentaje;
                    return InkWell(
                      onTap: () {
                        context.read<NivelDanoBloc>().add(
                          SetPorcentajeAfectacion(porcentaje),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : null,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          porcentaje,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
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
    return BlocBuilder<NivelDanoBloc, NivelDanoState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          shadowColor: theme.colorScheme.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '6.3 Nivel de Daño en la Edificación',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMatrizNivelDano(state, theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatrizNivelDano(NivelDanoState state, ThemeData theme) {
    final porcentajes = ['>70', '40-70', '10-40', '<10'];
    final severidades = ['Bajo', 'Medio', 'Medio Alto', 'Alto'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Matriz principal
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
              color: Colors.black26,
              width: 1,
            ),
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              // Construir filas para cada porcentaje
              for (var porcentaje in porcentajes)
                TableRow(
                  children: [
                    // Celda de porcentaje
                    TableCell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          porcentaje,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Celdas de severidad
                    for (var severidad in severidades)
                      TableCell(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: _getCeldaColor(severidad, porcentaje),
                            border: _esCeldaSeleccionada(state, severidad, porcentaje)
                                ? Border.all(
                                    color: Colors.black87,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: _esCasoEspecial(severidad, porcentaje)
                              ? const Center(
                                  child: Text(
                                    'X',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Etiquetas de severidad
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Row(
            children: [
              ...severidades.map((severidad) => Expanded(
                child: Center(
                  child: Text(
                    severidad,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Leyenda de colores
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildLeyendaItem('Bajo', const Color(0xFF43A047), theme),
            _buildLeyendaItem('Medio', const Color(0xFFFDD835), theme),
            _buildLeyendaItem('Medio Alto', const Color(0xFFF57C00), theme),
            _buildLeyendaItem('Alto', const Color(0xFFD32F2F), theme),
            _buildLeyendaItem('Caso Especial (X)', const Color(0xFFFFCDD2), theme),
          ],
        ),
      ],
    );
  }

  Widget _buildLeyendaItem(String texto, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool _esCeldaSeleccionada(NivelDanoState state, String severidad, String porcentaje) {
    if (state.severidadDanos == null || state.porcentajeAfectacion == null) {
      return false;
    }

    String porcentajeNormalizado = state.porcentajeAfectacion!;
    switch (porcentajeNormalizado) {
      case 'Ninguno':
        porcentajeNormalizado = '< 10%';
        break;
      case '< 10%':
        porcentajeNormalizado = '<10';
        break;
      case '10-40%':
        porcentajeNormalizado = '10-40';
        break;
      case '40-70%':
        porcentajeNormalizado = '40-70';
        break;
      case '>70%':
        porcentajeNormalizado = '>70';
        break;
    }

    return state.severidadDanos == severidad && porcentajeNormalizado == porcentaje;
  }

  Color _getCeldaColor(String severidad, String porcentaje) {
    // Casos especiales (X en la matriz) - rojo más claro
    if ((severidad == 'Medio' && porcentaje == '>70') ||
        (severidad == 'Medio Alto' && porcentaje == '40-70')) {
      return const Color(0xFFFFCDD2); // Rojo más claro para casos especiales
    }

    // Colores normales según la severidad
    switch (_calcularNivelDanoMatriz(severidad, porcentaje)) {
      case 'Alto':
        return const Color(0xFFD32F2F); // Rojo
      case 'Medio Alto':
        return const Color(0xFFF57C00); // Naranja
      case 'Medio':
        return const Color(0xFFFDD835); // Amarillo
      case 'Bajo':
        return const Color(0xFF43A047); // Verde
      default:
        return Colors.white;
    }
  }

  String _calcularNivelDanoMatriz(String severidad, String porcentaje) {
    if (severidad == 'Alto') return 'Alto';

    if (severidad == 'Medio Alto') {
      if (porcentaje == '>70' || porcentaje == '40-70') return 'Alto';
      if (porcentaje == '10-40') return 'Medio Alto';
      return 'Medio';
    }

    if (severidad == 'Medio') {
      if (porcentaje == '>70') return 'Caso Especial';
      if (porcentaje == '40-70') return 'Medio Alto';
      if (porcentaje == '10-40') return 'Medio';
      return 'Bajo';
    }

    if (severidad == 'Bajo') {
      if (porcentaje == '>70') return 'Medio Alto';
      if (porcentaje == '40-70') return 'Medio';
      return 'Bajo';
    }

    return 'Sin Daño';
  }

  Color _getSeveridadColor(String? severidad, ThemeData theme) {
    switch (severidad) {
      case 'Bajo':
        return const Color(0xFF43A047); // Verde
      case 'Medio':
        return const Color(0xFFFDD835); // Amarillo
      case 'Medio Alto':
        return const Color(0xFFF57C00); // Naranja
      case 'Alto':
        return const Color(0xFFD32F2F); // Rojo
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
      case 'Medio Alto':
        return Icons.warning_amber;
      case 'Alto':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getSeveridadDescription(String? severidad) {
    switch (severidad) {
      case 'Bajo':
        return 'Si en 5.1, 5.2, 5.3, 5.4, 5.5 y 5.6 se selecciona NO, y Si en 5.7 o 5.8 o 5.9 o 5.10 o 5.11 se selecciona Leve';
      case 'Medio':
        return 'Si en 5.8 o 5.9 o 5.10 o 5.11 se selecciona moderado';
      case 'Medio Alto':
        return 'Si en 5.5 o 5.6 se selecciona SI, Si en 5.7 se selecciona moderado';
      case 'Alto':
        return 'Si en 5.1 o 5.2 o 5.3 o 5.4 se selecciona SI o Si en 5.7 se selecciona severo';
      default:
        return 'Complete la evaluación de daños para calcular la severidad';
    }
  }

  bool _esCasoEspecial(String severidad, String porcentaje) {
    return (severidad == 'Medio' && porcentaje == '>70') ||
           (severidad == 'Medio Alto' && porcentaje == '40-70');
  }
} 