// ignore_for_file: unused_import, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/form/descripcionEdificacion/descripcion_edificacion_event.dart';
import '../../../widgets/navigation_fab_menu.dart';
import '../../../blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import '../../../blocs/form/descripcionEdificacion/descripcion_edificacion_state.dart';

class DescripcionEdificacionPage extends StatefulWidget {
  const DescripcionEdificacionPage({super.key});

  @override
  State<DescripcionEdificacionPage> createState() => _DescripcionEdificacionPageState();
}

class _DescripcionEdificacionPageState extends State<DescripcionEdificacionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para los campos de texto
  final _pisosSobreTerrenoController = TextEditingController();
  final _sotanosController = TextEditingController();
  final _frenteController = TextEditingController();
  final _fondoController = TextEditingController();
  final _unidadesResidencialesController = TextEditingController();
  final _unidadesComercialesController = TextEditingController();
  final _unidadesNoHabitadasController = TextEditingController();
  final _numeroOcupantesController = TextEditingController();
  final _muertosController = TextEditingController();
  final _heridosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    final state = context.read<DescripcionEdificacionBloc>().state;
    _loadDataFromState(state);
  }

  void _loadDataFromState(DescripcionEdificacionState state) {
    if (state.pisosSobreTerreno != null) {
      _pisosSobreTerrenoController.text = state.pisosSobreTerreno.toString();
    }
    if (state.sotanos != null) {
      _sotanosController.text = state.sotanos.toString();
    }
    if (state.frenteDimension != null) {
      _frenteController.text = state.frenteDimension.toString();
    }
    if (state.fondoDimension != null) {
      _fondoController.text = state.fondoDimension.toString();
    }
    if (state.unidadesResidenciales != null) {
      _unidadesResidencialesController.text = state.unidadesResidenciales.toString();
    }
    if (state.unidadesComerciales != null) {
      _unidadesComercialesController.text = state.unidadesComerciales.toString();
    }
    if (state.unidadesNoHabitadas != null) {
      _unidadesNoHabitadasController.text = state.unidadesNoHabitadas.toString();
    }
    if (state.numeroOcupantes != null) {
      _numeroOcupantesController.text = state.numeroOcupantes.toString();
    }
    if (state.muertos != null) {
      _muertosController.text = state.muertos.toString();
    }
    if (state.heridos != null) {
      _heridosController.text = state.heridos.toString();
    }
  }

  bool _validateCaracteristicasGenerales(DescripcionEdificacionState state) {
    return state.pisosSobreTerreno != null &&
        state.sotanos != null &&
        state.frenteDimension != null &&
        state.fondoDimension != null &&
        state.unidadesResidenciales != null &&
        state.unidadesComerciales != null &&
        state.unidadesNoHabitadas != null &&
        state.numeroOcupantes != null &&
        (state.noSeSabe == true || (state.muertos != null && state.heridos != null)) &&
        (state.accesoObstruido != null || state.accesoLibre != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descripción'),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          indicatorWeight: 3,
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).colorScheme.secondary.withOpacity(0.1);
              }
              return null;
            },
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.home_work, size: 24),
              text: 'Características',
            ),
            Tab(
              icon: Icon(Icons.business, size: 24),
              text: 'Usos',
            ),
            Tab(
              icon: Icon(Icons.architecture, size: 24),
              text: 'Estructural',
            ),
            Tab(
              icon: Icon(Icons.layers, size: 24),
              text: 'Entrepisos',
            ),
            Tab(
              icon: Icon(Icons.roofing, size: 24),
              text: 'Cubierta',
            ),
            Tab(
              icon: Icon(Icons.view_compact_alt, size: 24),
              text: 'No Estructural',
            ),
            Tab(
              icon: Icon(Icons.info, size: 24),
              text: 'Adicionales',
            ),
          ],
        ),
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/descripcion_edificacion',
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCaracteristicasGenerales(),
            _buildUsosPredominantes(),
            _buildSistemaEstructural(),
            _buildSistemasEntrepiso(),
            _buildSistemasCubierta(),
            _buildElementosNoEstructurales(),
            _buildDatosAdicionales(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaracteristicasGenerales() {
    return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pisos y Sótanos
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                  controller: _pisosSobreTerrenoController,
                      decoration: const InputDecoration(
                        labelText: 'No. de pisos sobre el terreno',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<DescripcionEdificacionBloc>()
                              .add(SetPisosSobreTerreno(int.parse(value)));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                  controller: _sotanosController,
                      decoration: const InputDecoration(
                        labelText: 'Sótanos',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<DescripcionEdificacionBloc>()
                              .add(SetSotanos(int.parse(value)));
                        }
                      },
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
              
              // Dimensiones
              Text(
                'Dimensiones aproximadas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                  controller: _frenteController,
                      decoration: const InputDecoration(
                        labelText: 'Frente (m)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final state = context.read<DescripcionEdificacionBloc>().state;
                          context.read<DescripcionEdificacionBloc>().add(
                            SetDimensiones(
                              double.parse(value),
                              state.fondoDimension ?? 0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                  controller: _fondoController,
                      decoration: const InputDecoration(
                        labelText: 'Fondo (m)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final state = context.read<DescripcionEdificacionBloc>().state;
                          context.read<DescripcionEdificacionBloc>().add(
                            SetDimensiones(
                              state.frenteDimension ?? 0,
                              double.parse(value),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 24),
              
              // Unidades
          Text(
            'Unidades',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                  controller: _unidadesResidencialesController,
                      decoration: const InputDecoration(
                    labelText: 'Residenciales',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<DescripcionEdificacionBloc>()
                              .add(SetUnidadesResidenciales(int.parse(value)));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                  controller: _unidadesComercialesController,
                      decoration: const InputDecoration(
                    labelText: 'Comerciales',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<DescripcionEdificacionBloc>()
                              .add(SetUnidadesComerciales(int.parse(value)));
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
            controller: _unidadesNoHabitadasController,
                decoration: const InputDecoration(
              labelText: 'No habitadas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    context.read<DescripcionEdificacionBloc>()
                        .add(SetUnidadesNoHabitadas(int.parse(value)));
                  }
                },
              ),
          const SizedBox(height: 24),
          
          // Ocupantes y Víctimas
          Text(
            'Ocupantes y Víctimas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
              TextFormField(
            controller: _numeroOcupantesController,
                decoration: const InputDecoration(
                  labelText: 'Número de ocupantes',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    context.read<DescripcionEdificacionBloc>()
                        .add(SetNumeroOcupantes(int.parse(value)));
                  }
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.noSeSabe != true) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                controller: _muertosController,
                              decoration: const InputDecoration(
                                labelText: 'Muertos',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                  if (value.isNotEmpty) {
                                context.read<DescripcionEdificacionBloc>().add(
                                  SetMuertosHeridos(
                                        muertos: int.parse(value),
                                    heridos: state.heridos,
                                    noSeSabe: state.noSeSabe ?? false,
                                  ),
                                );
                                  }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                                controller: _heridosController,
                              decoration: const InputDecoration(
                                labelText: 'Heridos',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                  if (value.isNotEmpty) {
                                context.read<DescripcionEdificacionBloc>().add(
                                  SetMuertosHeridos(
                                    muertos: state.muertos,
                                        heridos: int.parse(value),
                                    noSeSabe: state.noSeSabe ?? false,
                                  ),
                                );
                                  }
                              },
                            ),
                          ),
                        ],
                      ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetMuertosHeridos(
                                    muertos: state.noSeSabe == true ? null : state.muertos,
                                    heridos: state.noSeSabe == true ? null : state.heridos,
                                    noSeSabe: !(state.noSeSabe ?? false),
                            ),
                          );
                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state.noSeSabe == true
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.surface,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                'No se sabe',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
          const SizedBox(height: 24),
              
              // Acceso a la edificación
              Text(
                'Acceso a la edificación',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetAcceso(
                                  obstruido: !(state.accesoObstruido ?? false),
                                  libre: state.accesoLibre ?? false,
                              ),
                            );
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.accesoObstruido == true
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.surface,
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              'Obstruido',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetAcceso(
                                  obstruido: state.accesoObstruido ?? false,
                                  libre: !(state.accesoLibre ?? false),
                              ),
                            );
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.accesoLibre == true
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.surface,
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              'Libre',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ),
                      ),
                    ],
                    ),
                  );
                },
              ),
            ],
      ),
    );
  }

  Widget _buildUsosPredominantes() {
    final usos = [
      'Almacenamiento',
      'Comercial',
      'Educativo',
      'Industrial',
      'Institucional',
      'Oficina',
      'Parqueaderos',
      'Residencial',
      'Reunión',
      'Salud',
      'Seguridad',
      'Servicios Públicos',
      'Otro',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Uso predominante
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Uso Predominante',
                          border: OutlineInputBorder(),
                        ),
                        value: state.usoPredominante,
                        items: usos.map((uso) {
                          return DropdownMenuItem(
                            value: uso,
                            child: Text(uso),
                          );
                        }).toList(),
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetUsoPredominante(
                              value ?? '',
                              otroUso: value == 'Otro' ? state.otroUso : null,
                            ),
                          );
                        },
                      ),
                      if (state.usoPredominante == 'Otro') ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Especifique otro uso',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: state.otroUso,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetUsoPredominante('Otro', otroUso: value),
                            );
                          },
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Fecha de diseño o construcción
              Text(
                'Fecha de diseño o construcción',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Antes de 1984'),
                        value: 'Antes de 1984',
                        groupValue: state.fechaConstruccion,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFechaConstruccion(value ?? ''),
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Entre 1984 y 1997'),
                        value: 'Entre 1984 y 1997',
                        groupValue: state.fechaConstruccion,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFechaConstruccion(value ?? ''),
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Entre 1998 y 2010'),
                        value: 'Entre 1998 y 2010',
                        groupValue: state.fechaConstruccion,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFechaConstruccion(value ?? ''),
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Después de 2010'),
                        value: 'Después de 2010',
                        groupValue: state.fechaConstruccion,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFechaConstruccion(value ?? ''),
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Desconocida'),
                        value: 'Desconocida',
                        groupValue: state.fechaConstruccion,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFechaConstruccion(value ?? ''),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSistemaEstructural() {
    final sistemasYMateriales = {
      'Muros de carga': [
        'Mampostería Simple',
        'Mampostería Confinada',
        'Mampostería Reforzada',
        'Mampostería de adobe',
        'Concreto',
        'Concreto prefabricado',
        'Madera o guadua',
        'Tierra o tapia pisada',
        'Bahareque'
      ],
      'Pórticos': [
        'Concreto no arriostrados',
        'Concreto arriostrados',
        'Acero no arriostrados',
        'Acero arriostrados',
        'Madera o guadua',
        'Cerchas en acero',
        'Concreto prefabricado',
        'Cerchas en madera o guadua'
      ],
      'Combinado o Dual': [
        'Concreto',
        'Acero',
        'Concreto y mampostería',
        'Concreto y acero'
      ],
      'Otro': ['Losa - columna en concreto'],
      'No es claro': []
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sistema estructural',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // Sistemas estructurales
                  ...sistemasYMateriales.entries.map((entry) {
                    bool isSelected = state.sistemaEstructural == entry.key;
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetSistemaEstructuralYMaterial(entry.key)
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Icon(
                                isSelected ? Icons.check_circle : Icons.circle_outlined,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected && entry.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Column(
                              children: entry.value.map((material) {
                                bool isMaterialSelected = state.material == material;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                    context.read<DescripcionEdificacionBloc>().add(
                                      SetSistemaEstructuralYMaterial(
                                        entry.key,
                                          material: material,
                                      ),
                                    );
                                  },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isMaterialSelected
                                          ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
                                          : Theme.of(context).colorScheme.surface,
                                      foregroundColor: Theme.of(context).colorScheme.primary,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            material,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                        Icon(
                                          isMaterialSelected ? Icons.check_circle : Icons.circle_outlined,
                                          color: isMaterialSelected
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }),

                  if (state.sistemaEstructural == 'Otro')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '¿Cuál?',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: state.cualOtroSistema,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetSistemaEstructuralYMaterial(
                              'Otro',
                              cualOtroSistema: value,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSistemasEntrepiso() {
    final materialesEntrepiso = {
      'Concreto': [
        'Reticular celulado',
        'Losas postensadas',
        'Losa Maciza',
        'Vigas y losa Maciza',
        'Losa armada en una dirección',
        'Losa armada en dos direcciones'
      ],
      'Acero': [
        'Vigas y rejilla de acero',
        'Cerchas y rejilla de acero'
      ],
      'Mixtos': [
        'Vigas en acero y bloques de ladrillo',
        'Vigas en concreto y bloques de ladrillo',
        'Vigas en madera y losa de concreto',
        'Vigas de concreto y Steel deck',
        'Cerchas de acero y entramado de madera',
        'Vigas de acero y Steel deck',
        'Vigas o cerchas en acero y losa maciza en concreto'
      ],
      'Madera': ['Vigas y entramado de madera o guadua'],
      'Guadua': ['Vigas y entramado de madera o guadua'],
      'No es claro': [],
      'Otro': []
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3.4 Sistemas de entrepiso',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Materiales principales
                  ...materialesEntrepiso.keys.map((material) => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(material),
                        value: state.materialEntrepiso == material,
                        onChanged: (bool? value) {
                          if (value == true) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetSistemaEntrepiso(
                                material,
                                tipos: state.materialEntrepiso == material ? state.tiposEntrepiso : [],
                              ),
                            );
                          }
                        },
                      ),
                      if (state.materialEntrepiso == material && materialesEntrepiso[material]!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Column(
                            children: materialesEntrepiso[material]!.map((tipo) {
                              return CheckboxListTile(
                                title: Text(tipo),
                                value: state.tiposEntrepiso?.contains(tipo) ?? false,
                                onChanged: (bool? value) {
                                  final currentTipos = List<String>.from(state.tiposEntrepiso ?? []);
                                  if (value ?? false) {
                                    currentTipos.add(tipo);
                                  } else {
                                    currentTipos.remove(tipo);
                                  }
                                  context.read<DescripcionEdificacionBloc>().add(
                                    SetSistemaEntrepiso(
                                      material,
                                      tipos: currentTipos,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  )),

                  if (state.materialEntrepiso == 'Otro')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '¿Cuál?',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: state.otroEntrepiso,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetSistemaEntrepiso(
                              'Otro',
                              otroTipo: value,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSistemasCubierta() {
    final sistemasSoporte = [
      'Vigas de madera',
      'Vigas de acero',
      'Vigas de concreto',
      'Cerchas de madera',
      'Cerchas de acero',
      'Otro',
    ];

    final revestimientos = [
      'Precario (plástico, paja)',
      'Teja de barro',
      'Teja de asbesto cemento',
      'Teja Plástica',
      'Teja de zinc',
      'Teja termo acústica',
      'Losa maciza de concreto',
      'Losa aligerada de concreto',
      'Cúpula, bóveda, arco en mampostería, tierra o madera',
      'Otro',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3.5.1 Sistema de soporte',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...sistemasSoporte.map((sistema) => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(sistema),
                        value: state.sistemaSoporte?.contains(sistema) ?? false,
                        onChanged: (bool? value) {
                          final currentSistemas = List<String>.from(state.sistemaSoporte ?? []);
                          if (value ?? false) {
                            currentSistemas.add(sistema);
                          } else {
                            currentSistemas.remove(sistema);
                          }
                          context.read<DescripcionEdificacionBloc>().add(
                            SetSistemaSoporte(
                              currentSistemas,
                              otroSistema: sistema == 'Otro' && value == true 
                                ? state.otroSistemaSoporte 
                                : null,
                            ),
                          );
                        },
                      ),
                      if (sistema == 'Otro' && state.sistemaSoporte?.contains('Otro') == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '¿Cuál?',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.otroSistemaSoporte,
                            onChanged: (value) {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetSistemaSoporte(
                                  state.sistemaSoporte ?? [],
                                  otroSistema: value,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  )),

                  Divider(
                    height: 32,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),

                  const Text(
                    '3.5.2 Revestimiento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...revestimientos.map((revestimiento) => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(revestimiento),
                        value: state.revestimiento?.contains(revestimiento) ?? false,
                        onChanged: (bool? value) {
                          final currentRevestimientos = List<String>.from(state.revestimiento ?? []);
                          if (value ?? false) {
                            currentRevestimientos.add(revestimiento);
                          } else {
                            currentRevestimientos.remove(revestimiento);
                          }
                          context.read<DescripcionEdificacionBloc>().add(
                            SetRevestimiento(
                              currentRevestimientos,
                              otroRevestimiento: revestimiento == 'Otro' && value == true 
                                ? state.otroRevestimiento 
                                : null,
                            ),
                          );
                        },
                      ),
                      if (revestimiento == 'Otro' && state.revestimiento?.contains('Otro') == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '¿Cuál?',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.otroRevestimiento,
                            onChanged: (value) {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetRevestimiento(
                                  state.revestimiento ?? [],
                                  otroRevestimiento: value,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildElementosNoEstructurales() {
    final murosDivisorios = [
      'Mampostería',
      'Tierra',
      'Bahareque',
      'Particiones livianas',
      'Otro',
    ];

    final fachadas = [
      'Mampostería',
      'Tierra',
      'Paneles',
      'Vidrio',
      'Otro',
    ];

    final escaleras = [
      'Concreto',
      'Metálica',
      'Madera',
      'Mixtas',
      'Otro',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              bool mostrarEscaleras = (state.pisosSobreTerreno ?? 0) > 1 || 
                                    ((state.pisosSobreTerreno ?? 0) == 1 && (state.sotanos ?? 0) >= 1);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3.6.1 Muros divisorios
                  const Text(
                    '3.6.1 Muros divisorios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...murosDivisorios.map((muro) => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(muro),
                        value: state.murosDivisorios?.contains(muro) ?? false,
                        onChanged: (bool? value) {
                          final currentMuros = List<String>.from(state.murosDivisorios ?? []);
                          if (value ?? false) {
                            currentMuros.add(muro);
                          } else {
                            currentMuros.remove(muro);
                          }
                          context.read<DescripcionEdificacionBloc>().add(
                            SetMurosDivisorios(
                              currentMuros,
                              otroMuro: muro == 'Otro' && value == true 
                                ? state.otroMuroDivisorio 
                                : null,
                            ),
                          );
                        },
                      ),
                      if (muro == 'Otro' && state.murosDivisorios?.contains('Otro') == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '¿Cuál?',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.otroMuroDivisorio,
                            onChanged: (value) {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetMurosDivisorios(
                                  state.murosDivisorios ?? [],
                                  otroMuro: value,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  )),

                  Divider(
                    height: 32,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),

                  // 3.6.2 Fachadas
                  const Text(
                    '3.6.2 Fachadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...fachadas.map((fachada) => Column(
                    children: [
                      CheckboxListTile(
                        title: Text(fachada),
                        value: state.fachadas?.contains(fachada) ?? false,
                        onChanged: (bool? value) {
                          final currentFachadas = List<String>.from(state.fachadas ?? []);
                          if (value ?? false) {
                            currentFachadas.add(fachada);
                          } else {
                            currentFachadas.remove(fachada);
                          }
                          context.read<DescripcionEdificacionBloc>().add(
                            SetFachadas(
                              currentFachadas,
                              otraFachada: fachada == 'Otro' && value == true 
                                ? state.otraFachada 
                                : null,
                            ),
                          );
                        },
                      ),
                      if (fachada == 'Otro' && state.fachadas?.contains('Otro') == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '¿Cuál?',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.otraFachada,
                            onChanged: (value) {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetFachadas(
                                  state.fachadas ?? [],
                                  otraFachada: value,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  )),

                  if (mostrarEscaleras) ...[
                    Divider(
                      height: 32,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),

                    // 3.6.3 Escaleras
                    const Text(
                      '3.6.3 Escaleras',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...escaleras.map((escalera) => Column(
                      children: [
                        CheckboxListTile(
                          title: Text(escalera),
                          value: state.escaleras?.contains(escalera) ?? false,
                          onChanged: (bool? value) {
                            final currentEscaleras = List<String>.from(state.escaleras ?? []);
                            if (value ?? false) {
                              currentEscaleras.add(escalera);
                            } else {
                              currentEscaleras.remove(escalera);
                            }
                            context.read<DescripcionEdificacionBloc>().add(
                              SetEscaleras(
                                currentEscaleras,
                                otraEscalera: escalera == 'Otro' && value == true 
                                  ? state.otraEscalera 
                                  : null,
                              ),
                            );
                          },
                        ),
                        if (escalera == 'Otro' && state.escaleras?.contains('Otro') == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: '¿Cuál?',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: state.otraEscalera,
                              onChanged: (value) {
                                context.read<DescripcionEdificacionBloc>().add(
                                  SetEscaleras(
                                    state.escaleras ?? [],
                                    otraEscalera: value,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    )),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDatosAdicionales() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3.7 Nivel de diseño
          Text(
            'Nivel de diseño',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
                  ),
                  const SizedBox(height: 16),
          BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Row(
                    children: [
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetNivelDiseno('Ingenieril'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.nivelDiseno == 'Ingenieril'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.nivelDiseno == 'Ingenieril'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.nivelDiseno == 'Ingenieril'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Ingenieril',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.nivelDiseno == 'Ingenieril' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetNivelDiseno('No ingenieril'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.nivelDiseno == 'No ingenieril'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.nivelDiseno == 'No ingenieril'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.nivelDiseno == 'No ingenieril'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'No ingenieril',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.nivelDiseno == 'No ingenieril' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetNivelDiseno('Precario'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.nivelDiseno == 'Precario'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.nivelDiseno == 'Precario'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.nivelDiseno == 'Precario'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Precario',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.nivelDiseno == 'Precario' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                        ),
                      ),
                    ],
              );
            },
                  ),

          const SizedBox(height: 24),

                  // 3.8 Calidad del diseño
          Text(
            'Calidad del diseño y la construcción',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
                  ),
                  const SizedBox(height: 16),
          BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Row(
                    children: [
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetCalidadDiseno('Bueno'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.calidadDiseno == 'Bueno'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.calidadDiseno == 'Bueno'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.calidadDiseno == 'Bueno'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Bueno',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.calidadDiseno == 'Bueno' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetCalidadDiseno('Regular'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.calidadDiseno == 'Regular'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.calidadDiseno == 'Regular'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.calidadDiseno == 'Regular'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Regular',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.calidadDiseno == 'Regular' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetCalidadDiseno('Malo'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.calidadDiseno == 'Malo'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.calidadDiseno == 'Malo'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.calidadDiseno == 'Malo'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Malo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.calidadDiseno == 'Malo' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                        ),
                      ),
                    ],
              );
            },
                  ),

          const SizedBox(height: 24),

                  // 3.9 Estado de la edificación
          Text(
            'Estado de la edificación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
                  ),
                  const SizedBox(height: 16),
          BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Row(
                    children: [
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetEstadoEdificacion('Bueno'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.estadoEdificacion == 'Bueno'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.estadoEdificacion == 'Bueno'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.estadoEdificacion == 'Bueno'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Bueno',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.estadoEdificacion == 'Bueno' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetEstadoEdificacion('Regular'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.estadoEdificacion == 'Regular'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.estadoEdificacion == 'Regular'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.estadoEdificacion == 'Regular'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Regular',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.estadoEdificacion == 'Regular' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                            context.read<DescripcionEdificacionBloc>().add(
                          SetEstadoEdificacion('Malo'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.estadoEdificacion == 'Malo'
                            ? const Color(0xFF1B3A5C)  // Dark blue
                            : Colors.white,
                        foregroundColor: state.estadoEdificacion == 'Malo'
                            ? Colors.white
                            : const Color(0xFF1B3A5C),  // Dark blue
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: state.estadoEdificacion == 'Malo'
                                ? const Color(0xFF1B3A5C)  // Dark blue
                                : const Color(0xFFFFD700),  // Yellow
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Malo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.estadoEdificacion == 'Malo' ? Colors.white : const Color(0xFF1B3A5C),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pisosSobreTerrenoController.dispose();
    _sotanosController.dispose();
    _frenteController.dispose();
    _fondoController.dispose();
    _unidadesResidencialesController.dispose();
    _unidadesComercialesController.dispose();
    _unidadesNoHabitadasController.dispose();
    _numeroOcupantesController.dispose();
    _muertosController.dispose();
    _heridosController.dispose();
    _tabController.dispose();
    super.dispose();
  }
} 