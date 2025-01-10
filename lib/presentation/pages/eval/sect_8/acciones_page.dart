import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/acciones/acciones_bloc.dart';
import '../../../../presentation/blocs/form/acciones/acciones_event.dart';
import '../../../../presentation/blocs/form/acciones/acciones_state.dart';
import '../../../../presentation/widgets/navigation_fab_menu.dart';

class AccionesPage extends StatelessWidget {
  const AccionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Acciones Recomendadas'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/acciones',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEvaluacionesCard(theme),
              const SizedBox(height: 32),
              _buildMedidasSeguridadCard(theme),
              const SizedBox(height: 32),
              _buildEntidadesCard(theme),
              const SizedBox(height: 32),
              _buildRecomendacionesCard(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluacionesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8.1 Evaluaciones Adicionales',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleccione las evaluaciones adicionales requeridas:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return Column(
                  children: _buildEvaluacionOptions(context, state, theme),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedidasSeguridadCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8.2 Medidas de Seguridad',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Indique las medidas de seguridad necesarias:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return Column(
                  children: _buildMedidasOptions(context, state, theme),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntidadesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8.3 Entidades Recomendadas',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleccione las entidades que deben intervenir:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return Column(
                  children: _buildEntidadesOptions(context, state, theme),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecomendacionesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8.4 Recomendaciones Específicas',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agregue recomendaciones específicas para la edificación:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return TextFormField(
                  initialValue: state.recomendacionesEspecificas,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Escriba aquí las recomendaciones específicas...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: (value) => context.read<AccionesBloc>().add(
                    SetRecomendacionesEspecificas(value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String description,
    bool isSelected,
    ThemeData theme,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) => onChanged(value!),
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
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEvaluacionOptions(
    BuildContext context,
    AccionesState state,
    ThemeData theme,
  ) {
    final evaluaciones = [
      {
        'tipo': 'Estructural',
        'descripcion': 'Evaluación detallada de la estructura',
        'seleccionado': state.evaluacionAdicional['Estructural']?.isNotEmpty ?? false,
      },
      {
        'tipo': 'Geotécnica',
        'descripcion': 'Evaluación del suelo y cimentación',
        'seleccionado': state.evaluacionAdicional['Geotécnica']?.isNotEmpty ?? false,
      },
      {
        'tipo': 'Otra',
        'descripcion': 'Otro tipo de evaluación necesaria',
        'seleccionado': state.evaluacionAdicional['Otra']?.isNotEmpty ?? false,
      },
    ];

    return evaluaciones.map((evaluacion) => _buildOptionCard(
      context,
      evaluacion['tipo'] as String,
      evaluacion['descripcion'] as String,
      evaluacion['seleccionado'] as bool,
      theme,
      (value) => context.read<AccionesBloc>().add(
        SetEvaluacionAdicional(
          tipo: evaluacion['tipo'] as String,
          descripcion: value ? 'Requerida' : '',
        ),
      ),
    )).toList();
  }

  List<Widget> _buildMedidasOptions(
    BuildContext context,
    AccionesState state,
    ThemeData theme,
  ) {
    final medidas = [
      {
        'key': 'restringirPeatones',
        'titulo': 'Restringir paso de peatones',
        'descripcion': 'Limitar el acceso peatonal en áreas específicas',
      },
      {
        'key': 'restringirVehiculos',
        'titulo': 'Restringir paso de vehículos pesados',
        'descripcion': 'Evitar el tránsito de vehículos de gran peso',
      },
      {
        'key': 'evacuarParcialmente',
        'titulo': 'Evacuar parcialmente la edificación',
        'descripcion': 'Desalojar áreas específicas que presentan riesgo',
      },
      {
        'key': 'evacuarTotalmente',
        'titulo': 'Evacuar totalmente la edificación',
        'descripcion': 'Desalojar completamente la edificación',
      },
      {
        'key': 'evacuarVecinas',
        'titulo': 'Evacuar edificaciones vecinas',
        'descripcion': 'Desalojar edificaciones adyacentes en riesgo',
      },
      {
        'key': 'vigilanciaPermanente',
        'titulo': 'Establecer vigilancia permanente',
        'descripcion': 'Monitoreo continuo de la edificación',
      },
      {
        'key': 'monitoreoEstructural',
        'titulo': 'Monitoreo estructural',
        'descripcion': 'Seguimiento del comportamiento estructural',
      },
      {
        'key': 'aislamiento',
        'titulo': 'Aislamiento en las siguientes áreas',
        'descripcion': 'Restringir acceso a zonas específicas',
      },
      {
        'key': 'apuntalar',
        'titulo': 'Apuntalar o asegurar elementos en riesgo',
        'descripcion': 'Reforzar elementos estructurales comprometidos',
      },
      {
        'key': 'demoler',
        'titulo': 'Demoler elementos en peligro de caer',
        'descripcion': 'Remover elementos que representan riesgo',
      },
      {
        'key': 'manejoSustancias',
        'titulo': 'Manejo de sustancias peligrosas',
        'descripcion': 'Control de materiales peligrosos',
      },
      {
        'key': 'desconectarServicios',
        'titulo': 'Desconectar servicios públicos',
        'descripcion': 'Suspender servicios que representan riesgo',
      },
      {
        'key': 'seguimiento',
        'titulo': 'Seguimiento',
        'descripcion': 'Monitoreo continuo de la situación',
      },
    ];

    return medidas.map((medida) => _buildOptionCard(
      context,
      medida['titulo'] as String,
      medida['descripcion'] as String,
      state.recomendaciones[medida['key']] ?? false,
      theme,
      (value) => context.read<AccionesBloc>().add(
        SetRecomendacion(
          recomendacion: medida['key'] as String,
          valor: value,
        ),
      ),
    )).toList();
  }

  List<Widget> _buildEntidadesOptions(
    BuildContext context,
    AccionesState state,
    ThemeData theme,
  ) {
    final entidades = [
      {
        'key': 'Planeación',
        'titulo': 'Planeación Municipal',
        'descripcion': 'Oficina de planeación y desarrollo urbano',
      },
      {
        'key': 'Bomberos',
        'titulo': 'Cuerpo de Bomberos',
        'descripcion': 'Atención de emergencias y prevención',
      },
      {
        'key': 'Policía',
        'titulo': 'Policía Nacional',
        'descripcion': 'Seguridad y control del área',
      },
      {
        'key': 'Ejército',
        'titulo': 'Ejército Nacional',
        'descripcion': 'Apoyo en situaciones de emergencia',
      },
      {
        'key': 'Tránsito',
        'titulo': 'Secretaría de Tránsito',
        'descripcion': 'Control de movilidad en la zona',
      },
      {
        'key': 'Rescate',
        'titulo': 'Grupos de Rescate',
        'descripcion': 'Equipos especializados de búsqueda y rescate',
      },
      {
        'key': 'Otra',
        'titulo': 'Otra Entidad',
        'descripcion': 'Especifique otra entidad necesaria',
      },
    ];

    return entidades.map((entidad) {
      final isSelected = state.entidadesRecomendadas[entidad['key']] ?? false;
      return Column(
        children: [
          _buildOptionCard(
            context,
            entidad['titulo'] as String,
            entidad['descripcion'] as String,
            isSelected,
            theme,
            (value) => context.read<AccionesBloc>().add(
              SetEntidadRecomendada(
                entidad: entidad['key'] as String,
                valor: value,
              ),
            ),
          ),
          if (entidad['key'] == 'Otra' && isSelected) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                initialValue: state.otraEntidad,
                decoration: InputDecoration(
                  labelText: 'Especifique la entidad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                onChanged: (value) => context.read<AccionesBloc>().add(
                  SetEntidadRecomendada(
                    entidad: 'Otra',
                    valor: true,
                    otraEntidad: value,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }).toList();
  }
} 