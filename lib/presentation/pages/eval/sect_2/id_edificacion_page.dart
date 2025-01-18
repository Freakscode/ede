// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../../../blocs/form/identificacionEdificacion/id_edificacion_event.dart';
import '../../../blocs/form/identificacionEdificacion/id_edificacion_state.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/navigation_fab_menu.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../widgets/direccion_preview.dart';
import 'dart:async';
import '../../../../data/models/colombia_data.dart';

enum TipoIdentificacion { medellin, areaMetropolitana }

class EdificacionPageWrapper extends StatelessWidget {
  const EdificacionPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const EdificacionPage();
  }
}

class EdificacionPage extends StatefulWidget {
  const EdificacionPage({super.key});

  @override
  State<EdificacionPage> createState() => _EdificacionPageState();
}

class _EdificacionPageState extends State<EdificacionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers para Datos Generales
  final _nombreEdificacionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _comunaController = TextEditingController();
  final _barrioController = TextEditingController();
  final _codigoBarrioController = TextEditingController();

  // Controllers para Identificación Catastral
  final _cbmlController = TextEditingController();

  // Controllers para Persona de Contacto
  final _nombreContactoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _ocupacionController = TextEditingController();

  TipoIdentificacion _tipoIdentificacion = TipoIdentificacion.medellin;
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;

  // Timers para debounce
  Timer? _nombreEdificacionDebouncer;
  Timer? _direccionDebouncer;
  Timer? _comunaDebouncer;
  Timer? _barrioDebouncer;
  Timer? _codigoBarrioDebouncer;
  Timer? _cbmlDebouncer;
  Timer? _nombreContactoDebouncer;
  Timer? _telefonoDebouncer;
  Timer? _emailDebouncer;
  Timer? _ocupacionDebouncer;

  String? _selectedDepartamento;
  String? _selectedMunicipio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Cargar datos del estado inmediatamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EdificacionBloc>().state;
      
      setState(() {
        // Si no hay valores en el estado, usar Antioquia y Medellín como default
        _selectedDepartamento = state.departamento ?? 'Antioquia';
        _selectedMunicipio = state.municipio ?? 'Medellín';
      });

      // Cargar el resto de los datos
      _loadDataFromState(state);

      // Si los valores por defecto fueron usados, actualizar el bloc
      if (state.departamento == null || state.municipio == null) {
        context.read<EdificacionBloc>()
          ..add(SetDepartamento(_selectedDepartamento!))
          ..add(SetMunicipio(_selectedMunicipio!));
      }
    });
  }

  void _loadDataFromState(EdificacionState state) {
    // Cargar nombre de edificación
    if (state.nombreEdificacion?.isNotEmpty ?? false) {
      _nombreEdificacionController.text = state.nombreEdificacion!;
    }

    // Cargar comuna solo si existe y corresponde a Medellín
    if (state.comuna?.isNotEmpty ?? false) {
      _comunaController.text = state.comuna!;
    }

    // Cargar el resto de los campos...
    if (state.direccion?.isNotEmpty ?? false) {
      _direccionController.text = state.direccion!;
    }
    if (state.barrio?.isNotEmpty ?? false) {
      _barrioController.text = state.barrio!;
    }
    // ... resto del código de carga de datos ...
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EdificacionBloc, EdificacionState>(
      listener: (context, state) {
        _loadDataFromState(state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Identificación de la Edificación'),
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
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Theme.of(context).colorScheme.secondary.withOpacity(0.1);
                }
                return null;
              },
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.description, size: 24),
                text: 'Datos Generales',
              ),
              Tab(
                icon: Icon(Icons.location_city, size: 24),
                text: 'Dirección',
              ),
              Tab(
                icon: Icon(Icons.location_on, size: 24),
                text: 'Catastro',
              ),
              Tab(
                icon: Icon(Icons.person, size: 24),
                text: 'Contacto',
              ),
            ],
          ),
          actions: [
            BlocBuilder<EdificacionBloc, EdificacionState>(
              builder: (context, state) {
                final bool isComplete = _validateAllFields(state);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isComplete ? Icons.check_circle : Icons.info_outline,
                    color: isComplete ? Colors.green : Colors.orange,
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: const NavigationFabMenu(
          currentRoute: '/id_edificacion',
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildDatosGenerales(context),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildDireccionEstructurada(context),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildIdentificacionCatastral(context),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildPersonaContacto(context),
                    ),
                  ],
                ),
              ),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosGenerales(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _nombreEdificacionController,
          label: 'Nombre de la Edificación',
          debouncer: _nombreEdificacionDebouncer,
          onChanged: (value) => context.read<EdificacionBloc>().add(SetNombreEdificacion(value)),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Ubicación General
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                value: _selectedDepartamento,
                items: departamentosColombia.map((departamento) {
                  return DropdownMenuItem<String>(
                    value: departamento.nombre,
                    child: Text(
                      departamento.nombre,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDepartamento = value;
                      // Resetear municipio cuando cambia el departamento
                      _selectedMunicipio = departamentosColombia
                          .firstWhere((d) => d.nombre == value)
                          .municipios
                          .first;
                    });
                    // Actualizar el bloc
                    context.read<EdificacionBloc>().add(SetDepartamento(value));
                    context.read<EdificacionBloc>().add(SetMunicipio(_selectedMunicipio!));
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un departamento';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: const InputDecoration(
                  labelText: 'Municipio',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                value: _selectedMunicipio,
                items: _selectedDepartamento != null
                    ? departamentosColombia
                        .firstWhere((d) => d.nombre == _selectedDepartamento)
                        .municipios
                        .map((municipio) {
                        return DropdownMenuItem<String>(
                          value: municipio,
                          child: Text(
                            municipio,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList()
                    : [],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMunicipio = value;
                    });
                    // Actualizar el bloc
                    context.read<EdificacionBloc>().add(SetMunicipio(value));
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un municipio';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _selectedDepartamento == 'Antioquia' && _selectedMunicipio == 'Medellín'
          ? DropdownButtonFormField<String>(
              isExpanded: true,
              menuMaxHeight: 300,
              decoration: const InputDecoration(
                labelText: 'Comuna o Corregimiento',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              value: _comunaController.text.isEmpty ? null : _comunaController.text,
              items: departamentosColombia
                .firstWhere((d) => d.nombre == 'Antioquia')
                .comunasCorregimientos?['Medellín']
                ?.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList() ?? [],
              onChanged: (value) {
                if (value != null) {
                  _comunaController.text = value;
                  context.read<EdificacionBloc>().add(SetComuna(value));
                }
              },
              validator: (value) {
                if (_selectedDepartamento == 'Antioquia' && 
                    _selectedMunicipio == 'Medellín' && 
                    (value == null || value.isEmpty)) {
                  return 'Por favor seleccione una comuna o corregimiento';
                }
                return null;
              },
            )
          : TextFormField(
              controller: _comunaController,
              decoration: const InputDecoration(
                labelText: 'Comuna',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _debounce(_comunaDebouncer, () {
                  if (mounted) {
                    context.read<EdificacionBloc>().add(SetComuna(value));
                  }
                });
              },
            ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _barrioController,
          label: 'Barrio',
          debouncer: _barrioDebouncer,
          onChanged: (value) => context.read<EdificacionBloc>().add(SetBarrio(value)),
        ),
      ],
    );
  }

  Widget _buildIdentificacionCatastral(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tipoIdentificacion = TipoIdentificacion.medellin;
                    _cbmlController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tipoIdentificacion == TipoIdentificacion.medellin
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Medellín'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tipoIdentificacion = TipoIdentificacion.areaMetropolitana;
                    _cbmlController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tipoIdentificacion == TipoIdentificacion.areaMetropolitana
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Área Metropolitana'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cbmlController,
          decoration: InputDecoration(
            labelText: _tipoIdentificacion == TipoIdentificacion.medellin
                ? 'Código Catastral'
                : 'Código Catastral',
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _debounce(_cbmlDebouncer, () {
              if (mounted) {
                context.read<EdificacionBloc>().add(SetCBML(value));
              }
            });
          },
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPersonaContacto(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nombreContactoController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Contacto',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _debounce(_nombreContactoDebouncer, () {
              if (mounted) {
                context.read<EdificacionBloc>().add(SetNombreContacto(value));
              }
            });
          },
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _telefonoController,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            _debounce(_telefonoDebouncer, () {
              if (mounted) {
                context.read<EdificacionBloc>().add(SetTelefonoContacto(value));
              }
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            _debounce(_emailDebouncer, () {
              if (mounted) {
                context.read<EdificacionBloc>().add(SetEmailContacto(value));
              }
            });
          },
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo de Ocupante',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                BlocBuilder<EdificacionBloc, EdificacionState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<EdificacionBloc>().add(
                                    SetOcupacion('Propietario'),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: state.ocupacion == 'Propietario'
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.surface,
                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Propietario'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<EdificacionBloc>().add(
                                    SetOcupacion('Inquilino'),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: state.ocupacion == 'Inquilino'
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.surface,
                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Inquilino'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<EdificacionBloc>().add(
                                    SetOcupacion('Otro'),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: state.ocupacion == 'Otro'
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.surface,
                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Otro'),
                              ),
                            ),
                          ],
                        ),
                        if (state.ocupacion == 'Otro') ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _ocupacionController,
                            decoration: const InputDecoration(
                              labelText: 'Especifique',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _debounce(_ocupacionDebouncer, () {
                                if (mounted) {
                                  context.read<EdificacionBloc>().add(
                                    SetOcupacion('Otro: $value'),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_tabController.index > 0)
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                _tabController.animateTo(_tabController.index - 1);
              },
              child: const Text('Anterior'),
            ),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (_tabController.index < 3) {
                  _tabController.animateTo(_tabController.index + 1);
                } else {
                  _guardarYContinuar(context);
                }
              }
            },
            child: Text(_tabController.index < 2 ? 'Siguiente' : 'Continuar'),
          ),
        ],
      ),
    );
  }

  void _guardarYContinuar(BuildContext context) {
    final state = context.read<EdificacionBloc>().state;

    if (_validateAllFields(state)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos guardados correctamente'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navegar a la sección de identificación de la evaluación
      context.go('/id_evaluacion');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateAllFields(EdificacionState state) {
    return state.nombreEdificacion?.isNotEmpty == true &&
        state.direccion?.isNotEmpty == true &&
        state.cbml?.isNotEmpty == true &&
        state.nombreContacto?.isNotEmpty == true;
  }

  @override
  void dispose() {
    _nombreEdificacionDebouncer?.cancel();
    _direccionDebouncer?.cancel();
    _comunaDebouncer?.cancel();
    _barrioDebouncer?.cancel();
    _codigoBarrioDebouncer?.cancel();
    _cbmlDebouncer?.cancel();
    _nombreContactoDebouncer?.cancel();
    _telefonoDebouncer?.cancel();
    _emailDebouncer?.cancel();
    _ocupacionDebouncer?.cancel();
    
    _nombreEdificacionController.dispose();
    _direccionController.dispose();
    _comunaController.dispose();
    _barrioController.dispose();
    _codigoBarrioController.dispose();
    _cbmlController.dispose();
    _nombreContactoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _ocupacionController.dispose();
    
    _tabController.dispose();
    super.dispose();
  }

  void _debounce(Timer? timer, VoidCallback callback) {
    if (timer?.isActive ?? false) timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), callback);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
    Timer? debouncer,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: (value) {
        controller.value = controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        if (debouncer?.isActive ?? false) debouncer?.cancel();
        debouncer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            onChanged(value);
          }
        });
      },
      validator: validator,
    );
  }

  Widget _buildDireccionEstructurada(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DireccionPreview(),
        const SizedBox(height: 24),
        
        // Vía Principal
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vía Principal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Vía',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                        items: ['CL', 'CR', 'CQ', 'TV', 'DG']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e == 'CL' ? 'Calle' :
                                    e == 'CR' ? 'Carrera' :
                                    e == 'CQ' ? 'Circular' :
                                    e == 'TV' ? 'Transversal' : 'Diagonal',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetTipoVia(value ?? ''));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Número',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetNumeroVia(value));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apéndice',
                          border: OutlineInputBorder(),
                          hintText: 'A-H, AA-HH',
                        ),
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetApendiceVia(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Orientación',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                        value: context.watch<EdificacionBloc>().state.orientacionVia?.isEmpty ?? true 
                            ? null 
                            : context.watch<EdificacionBloc>().state.orientacionVia,
                        items: [
                          DropdownMenuItem(
                            value: '', 
                            child: Text(
                              'Sin orientación',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (context.watch<EdificacionBloc>().state.tipoVia == 'CL')
                            DropdownMenuItem(
                              value: 'SUR',
                              child: Text(
                                'SUR',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          else if (context.watch<EdificacionBloc>().state.tipoVia == 'CR')
                            DropdownMenuItem(
                              value: 'ESTE',
                              child: Text(
                                'ESTE',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(
                            SetOrientacionVia(value ?? '', context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Cruce
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cruce',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: (value) {
                    context.read<EdificacionBloc>().add(SetNumeroCruce(value));
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apéndice',
                          border: OutlineInputBorder(),
                          hintText: 'A-H, AA-HH',
                        ),
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetApendiceCruce(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Orientación',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                        value: context.watch<EdificacionBloc>().state.orientacionCruce?.isEmpty ?? true 
                            ? null 
                            : context.watch<EdificacionBloc>().state.orientacionCruce,
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(
                              'Sin orientación',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (context.watch<EdificacionBloc>().state.tipoVia == 'CL')
                            DropdownMenuItem(
                              value: 'SUR',
                              child: Text(
                                'SUR',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          else if (context.watch<EdificacionBloc>().state.tipoVia == 'CR')
                            DropdownMenuItem(
                              value: 'ESTE',
                              child: Text(
                                'ESTE',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(
                            SetOrientacionCruce(value ?? '', context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Número y Complemento
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Número y Complemento',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Número',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetNumero(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(),
                          hintText: 'Edificio, Manzana, etc.',
                        ),
                        onChanged: (value) {
                          context.read<EdificacionBloc>().add(SetComplemento(value));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaracteristicasEdificacion(BuildContext context) {
    return Column(
      children: [
        // Eliminar todo el contenido relacionado con pisos, subterráneos y año
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

