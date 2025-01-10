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
import '../../../widgets/map_widget.dart';
import '../../../widgets/direccion_preview.dart';

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
  final _matriculaController = TextEditingController();
  final _pisosController = TextEditingController();
  final _subterraneosController = TextEditingController();
  final _yearController = TextEditingController();

  // Controllers para Persona de Contacto
  final _nombreContactoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _ocupacionController = TextEditingController();

  TipoIdentificacion _tipoIdentificacion = TipoIdentificacion.medellin;
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Cargar datos temporales del bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EdificacionBloc>().state;
      _loadDataFromState(state);
    });
  }

  void _loadDataFromState(EdificacionState state) {
    // Cargar todos los campos de la sección de edificación
    if (state.nombreEdificacion != null) {
      _nombreEdificacionController.text = state.nombreEdificacion!;
    }
    if (state.direccion != null) {
      _direccionController.text = state.direccion!;
    }
    if (state.comuna != null) {
      _comunaController.text = state.comuna!;
    }
    if (state.barrio != null) {
      _barrioController.text = state.barrio!;
    }
    if (state.codigoBarrio != null) {
      _codigoBarrioController.text = state.codigoBarrio!;
    }
    if (state.cbml != null) {
      _cbmlController.text = state.cbml!;
    }
    if (state.matriculaInmobiliaria != null) {
      _matriculaController.text = state.matriculaInmobiliaria!;
    }
    if (state.numeroPisos != null) {
      _pisosController.text = state.numeroPisos!;
    }
    if (state.subterraneos != null) {
      _subterraneosController.text = state.subterraneos!;
    }
    if (state.nombreContacto != null) {
      _nombreContactoController.text = state.nombreContacto!;
    }
    if (state.telefonoContacto != null) {
      _telefonoController.text = state.telefonoContacto!;
    }
    if (state.emailContacto != null) {
      _emailController.text = state.emailContacto!;
    }
    if (state.ocupacion != null) {
      _ocupacionController.text = state.ocupacion!;
    }
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 2,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.white,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
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
        TextFormField(
          controller: _nombreEdificacionController,
          decoration: const InputDecoration(
            labelText: 'Nombre de la Edificación',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<EdificacionBloc>().add(SetNombreEdificacion(value));
          },
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
                value: 'Antioquia',
                items: ['Antioquia'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  // Por defecto Antioquia
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
                value: 'Medellín',
                items: ['Medellín'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  // Por defecto Medellín
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: const InputDecoration(
                  labelText: 'Comuna',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: List.generate(16, (index) => 'Comuna ${index + 1}')
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  context.read<EdificacionBloc>().add(SetComuna(value ?? ''));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
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
                  labelText: 'Barrio',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: const [], // Cargar según la comuna seleccionada
                onChanged: (value) {
                  context.read<EdificacionBloc>().add(SetBarrio(value ?? ''));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIdentificacionCatastral(BuildContext context) {
    return Column(
      children: [
        // Botones de selección
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tipoIdentificacion = TipoIdentificacion.medellin;
                    _cbmlController.clear(); // Limpiar el campo al cambiar
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _tipoIdentificacion == TipoIdentificacion.medellin
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
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
                    _cbmlController.clear(); // Limpiar el campo al cambiar
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tipoIdentificacion ==
                          TipoIdentificacion.areaMetropolitana
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
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
            labelText: 'CBML',
            border: const OutlineInputBorder(),
            hintText: _tipoIdentificacion == TipoIdentificacion.medellin
                ? '11 dígitos'
                : '19 dígitos',
          ),
          keyboardType: TextInputType.number,
          maxLength:
              _tipoIdentificacion == TipoIdentificacion.medellin ? 11 : 19,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            context.read<EdificacionBloc>().add(SetCBML(value));
          },
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            final expectedLength =
                _tipoIdentificacion == TipoIdentificacion.medellin ? 11 : 19;
            if (value!.length != expectedLength) {
              return 'Debe tener exactamente $expectedLength dígitos';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _matriculaController,
          decoration: const InputDecoration(
            labelText: 'Matrícula Inmobiliaria',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context
                .read<EdificacionBloc>()
                .add(SetMatriculaInmobiliaria(value));
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<EdificacionBloc, EdificacionState>(
          builder: (context, state) {
            LatLng? initialPosition;
            if (state.latitud != null && state.longitud != null) {
              initialPosition = LatLng(state.latitud!, state.longitud!);
            }
            return MapWidget(initialPosition: initialPosition);
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
            context.read<EdificacionBloc>().add(SetNombreContacto(value));
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
            context.read<EdificacionBloc>().add(SetTelefonoContacto(value));
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
            context.read<EdificacionBloc>().add(SetEmailContacto(value));
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ocupacionController,
          decoration: const InputDecoration(
            labelText: 'Ocupación',
            border: OutlineInputBorder(),
            hintText: 'Propietario, Administrador, etc.',
          ),
          onChanged: (value) {
            context.read<EdificacionBloc>().add(SetOcupacion(value));
          },
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
              onPressed: () {
                _tabController.animateTo(_tabController.index - 1);
              },
              child: const Text('Anterior'),
            ),
          ElevatedButton(
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
    _nombreEdificacionController.dispose();
    _direccionController.dispose();
    _comunaController.dispose();
    _barrioController.dispose();
    _codigoBarrioController.dispose();
    _cbmlController.dispose();
    _matriculaController.dispose();
    _pisosController.dispose();
    _subterraneosController.dispose();
    _yearController.dispose();
    _nombreContactoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _ocupacionController.dispose();
    _mapController?.dispose();
    _tabController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vía Principal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                        value: context.watch<EdificacionBloc>().state.orientacionVia?.isEmpty ?? true 
                            ? null 
                            : context.watch<EdificacionBloc>().state.orientacionVia,
                        items: [
                          const DropdownMenuItem(
                            value: '', 
                            child: Text('Sin orientación', overflow: TextOverflow.ellipsis),
                          ),
                          if (context.watch<EdificacionBloc>().state.tipoVia == 'CL')
                            const DropdownMenuItem(
                              value: 'SUR', 
                              child: Text('SUR', overflow: TextOverflow.ellipsis),
                            )
                          else if (context.watch<EdificacionBloc>().state.tipoVia == 'CR')
                            const DropdownMenuItem(
                              value: 'ESTE', 
                              child: Text('ESTE', overflow: TextOverflow.ellipsis),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cruce',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                        ),
                        value: context.watch<EdificacionBloc>().state.orientacionCruce?.isEmpty ?? true 
                            ? null 
                            : context.watch<EdificacionBloc>().state.orientacionCruce,
                        items: [
                          const DropdownMenuItem(value: '', child: Text('Sin orientación')),
                          if (context.watch<EdificacionBloc>().state.tipoVia == 'CL')
                            const DropdownMenuItem(value: 'SUR', child: Text('SUR'))
                          else if (context.watch<EdificacionBloc>().state.tipoVia == 'CR')
                            const DropdownMenuItem(value: 'ESTE', child: Text('ESTE')),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Número y Complemento',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
