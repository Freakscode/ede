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
        title: const Text('Descripción de la Edificación'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Características\nGenerales'),
            Tab(text: 'Usos\nPredominantes'),
            Tab(text: 'Sistema Estructural\ny Material'),
            Tab(text: 'Sistemas de\nEntrepiso'),
            Tab(text: 'Sistemas de\nCubierta'),
            Tab(text: 'Elementos No\nEstructurales'),
            Tab(text: 'Datos\nAdicionales'),
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
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pisos y Sótanos
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
              const SizedBox(height: 16),
              
              // Dimensiones
              Text(
                'Dimensiones aproximadas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
              const SizedBox(height: 16),
              
              // Unidades
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Unidades residenciales',
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
                      decoration: const InputDecoration(
                        labelText: 'Unidades comerciales',
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
              
              // Unidades no habitadas
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Número de unidades no habitadas',
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
              const SizedBox(height: 16),
              
              // Número de ocupantes
              TextFormField(
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
              
              // Muertos y Heridos
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Muertos',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !(state.noSeSabe ?? false),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                context.read<DescripcionEdificacionBloc>().add(
                                  SetMuertosHeridos(
                                    muertos: value.isNotEmpty ? int.parse(value) : null,
                                    heridos: state.heridos,
                                    noSeSabe: state.noSeSabe ?? false,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Heridos',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !(state.noSeSabe ?? false),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (value) {
                                context.read<DescripcionEdificacionBloc>().add(
                                  SetMuertosHeridos(
                                    muertos: state.muertos,
                                    heridos: value.isNotEmpty ? int.parse(value) : null,
                                    noSeSabe: state.noSeSabe ?? false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('No se sabe'),
                        value: state.noSeSabe ?? false,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetMuertosHeridos(
                              muertos: value! ? null : state.muertos,
                              heridos: value ? null : state.heridos,
                              noSeSabe: value,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Acceso a la edificación
              Text(
                'Acceso a la edificación:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Obstruido'),
                          value: state.accesoObstruido ?? false,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetAcceso(
                                obstruido: value ?? false,
                                libre: value ?? false ? false : state.accesoLibre ?? false,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Libre'),
                          value: state.accesoLibre ?? false,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetAcceso(
                                obstruido: value ?? false ? false : state.accesoObstruido ?? false,
                                libre: value ?? false,
                              ),
                            );
                          },
                        ),
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
    // Definir las opciones para cada sistema estructural
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3.3.1 Sistema estructural',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sistemas estructurales
                  ...sistemasYMateriales.entries.map((entry) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(entry.key),
                          value: state.sistemaEstructural == entry.key,
                          onChanged: (bool? value) {
                            if (value == true) {
                              context.read<DescripcionEdificacionBloc>().add(
                                SetSistemaEstructuralYMaterial(entry.key)
                              );
                            }
                          },
                        ),
                        if (state.sistemaEstructural == entry.key && entry.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Column(
                              children: entry.value.map((material) {
                                return RadioListTile<String>(
                                  title: Text(material),
                                  value: material,
                                  groupValue: state.material,
                                  onChanged: (value) {
                                    context.read<DescripcionEdificacionBloc>().add(
                                      SetSistemaEstructuralYMaterial(
                                        entry.key,
                                        material: value,
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        if (entry.key == 'Otro' && state.sistemaEstructural == 'Otro')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                  }),
                  
                  const SizedBox(height: 16),
                  // Observaciones
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    initialValue: state.observaciones,
                    onChanged: (value) {
                      context.read<DescripcionEdificacionBloc>().add(
                        SetObservaciones(value),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  // Sistema múltiple
                  CheckboxListTile(
                    title: const Text('¿Existe más de un sistema en planta o en altura?'),
                    value: state.existeMasDeUnSistema ?? false,
                    onChanged: (bool? value) {
                      context.read<DescripcionEdificacionBloc>().add(
                        SetSistemaMultiple(value ?? false),
                      );
                    },
                  ),
                  if (state.existeMasDeUnSistema == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '¿Cuál?',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: state.cualOtroSistemaMultiple,
                        onChanged: (value) {
                          context.read<DescripcionEdificacionBloc>().add(
                            SetSistemaMultiple(true, cual: value),
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

                  const Divider(height: 32),

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

                  const Divider(height: 32),

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
                    const Divider(height: 32),

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
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3.7 Nivel de diseño
                  const Text(
                    '3.7 Nivel de diseño',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Ingenieril'),
                          value: 'Ingenieril',
                          groupValue: state.nivelDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetNivelDiseno(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('No ingenieril'),
                          value: 'No ingenieril',
                          groupValue: state.nivelDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetNivelDiseno(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Precario'),
                          value: 'Precario',
                          groupValue: state.nivelDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetNivelDiseno(value!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // 3.8 Calidad del diseño
                  const Text(
                    '3.8 Calidad del diseño y la construcción de la estructura original',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Bueno'),
                          value: 'Bueno',
                          groupValue: state.calidadDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetCalidadDiseno(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Regular'),
                          value: 'Regular',
                          groupValue: state.calidadDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetCalidadDiseno(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Malo'),
                          value: 'Malo',
                          groupValue: state.calidadDiseno,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetCalidadDiseno(value!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // 3.9 Estado de la edificación
                  const Text(
                    '3.9 Estado de la edificación (Conservación)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Bueno'),
                          value: 'Bueno',
                          groupValue: state.estadoEdificacion,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetEstadoEdificacion(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Regular'),
                          value: 'Regular',
                          groupValue: state.estadoEdificacion,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetEstadoEdificacion(value!),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Malo'),
                          value: 'Malo',
                          groupValue: state.estadoEdificacion,
                          onChanged: (value) {
                            context.read<DescripcionEdificacionBloc>().add(
                              SetEstadoEdificacion(value!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
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