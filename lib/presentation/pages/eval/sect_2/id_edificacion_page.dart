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
import '../../../widgets/map_location_picker.dart';

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
  late TextEditingController _nombreEdificacionController;
  late TextEditingController _direccionController;
  late TextEditingController _codigoBarrioController;
  late TextEditingController _cbmlController;
  late TextEditingController _ocupacionController;
  late TextEditingController _latitudController;
  late TextEditingController _longitudController;
  late TextEditingController _tipoViaController;
  late TextEditingController _numeroViaController;
  late TextEditingController _apendiceViaController;
  late TextEditingController _orientacionViaController;
  late TextEditingController _numeroCruceController;
  late TextEditingController _apendiceCruceController;
  late TextEditingController _orientacionCruceController;
  late TextEditingController _numeroController;
  late TextEditingController _complementoController;
  late TextEditingController _departamentoController;
  late TextEditingController _municipioController;
  late TextEditingController _comunaController;
  late TextEditingController _nombreContactoController;
  late TextEditingController _telefonoContactoController;
  late TextEditingController _emailContactoController;

  TipoIdentificacion _tipoIdentificacion = TipoIdentificacion.medellin;
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;

  // Debouncers para los campos de texto
  Timer? _nombreEdificacionDebouncer;
  Timer? _direccionDebouncer;
  Timer? _codigoBarrioDebouncer;
  Timer? _cbmlDebouncer;
  Timer? _ocupacionDebouncer;
  Timer? _latitudDebouncer;
  Timer? _longitudDebouncer;
  Timer? _tipoViaDebouncer;
  Timer? _numeroViaDebouncer;
  Timer? _apendiceViaDebouncer;
  Timer? _orientacionViaDebouncer;
  Timer? _numeroCruceDebouncer;
  Timer? _apendiceCruceDebouncer;
  Timer? _orientacionCruceDebouncer;
  Timer? _numeroDebouncer;
  Timer? _complementoDebouncer;
  Timer? _departamentoDebouncer;
  Timer? _municipioDebouncer;
  Timer? _nombreContactoDebouncer;
  Timer? _telefonoContactoDebouncer;
  Timer? _emailContactoDebouncer;

  String? _selectedDepartamento;
  String? _selectedMunicipio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    _nombreEdificacionController = TextEditingController();
    _direccionController = TextEditingController();
    _codigoBarrioController = TextEditingController();
    _cbmlController = TextEditingController();
    _ocupacionController = TextEditingController();
    _latitudController = TextEditingController();
    _longitudController = TextEditingController();
    _tipoViaController = TextEditingController();
    _numeroViaController = TextEditingController();
    _apendiceViaController = TextEditingController();
    _orientacionViaController = TextEditingController();
    _numeroCruceController = TextEditingController();
    _apendiceCruceController = TextEditingController();
    _orientacionCruceController = TextEditingController();
    _numeroController = TextEditingController();
    _complementoController = TextEditingController();
    _departamentoController = TextEditingController();
    _municipioController = TextEditingController();
    _comunaController = TextEditingController();
    _nombreContactoController = TextEditingController();
    _telefonoContactoController = TextEditingController();
    _emailContactoController = TextEditingController();

    // Agregar listeners para actualizar el estado cuando cambien los valores
    _nombreEdificacionController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetNombreEdificacion(_nombreEdificacionController.text),
      );
    });

    _tipoViaController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetTipoVia(_tipoViaController.text),
      );
    });

    _numeroViaController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetNumeroVia(_numeroViaController.text),
      );
    });

    _apendiceViaController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetApendiceVia(_apendiceViaController.text),
      );
    });

    _orientacionViaController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetOrientacionVia(_orientacionViaController.text, context),
      );
    });

    _numeroCruceController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetNumeroCruce(_numeroCruceController.text),
      );
    });

    _apendiceCruceController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetApendiceCruce(_apendiceCruceController.text),
      );
    });

    _orientacionCruceController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetOrientacionCruce(_orientacionCruceController.text, context),
      );
    });

    _numeroController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetNumero(_numeroController.text),
      );
    });

    _complementoController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetComplemento(_complementoController.text),
      );
    });

    _departamentoController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetDepartamento(_departamentoController.text),
      );
    });

    _municipioController.addListener(() {
      context.read<EdificacionBloc>().add(
        SetMunicipio(_municipioController.text, context),
      );
    });

    // Agregar listeners para las coordenadas
    _latitudController.addListener(() {
      if (_latitudController.text.isNotEmpty) {
        context.read<EdificacionBloc>().add(
          SetLatitud(_latitudController.text),
        );
      }
    });

    _longitudController.addListener(() {
      if (_longitudController.text.isNotEmpty) {
        context.read<EdificacionBloc>().add(
          SetLongitud(_longitudController.text),
        );
      }
    });

    // Cargar datos del estado inmediatamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EdificacionBloc>().state;
      
      setState(() {
        _selectedDepartamento = state.departamento ?? 'Antioquia';
        if (_selectedDepartamento != null) {
          final departamento = departamentosColombia.firstWhere(
            (d) => d.nombre == _selectedDepartamento,
            orElse: () => departamentosColombia.first,
          );
          _selectedMunicipio = state.municipio ?? departamento.municipios.first;
        }
      });

      // Cargar el resto de los datos
      _loadDataFromState();

      // Si los valores por defecto fueron usados, actualizar el bloc
      if (state.departamento == null || state.municipio == null) {
        context.read<EdificacionBloc>()
          ..add(SetDepartamento(_selectedDepartamento!))
          ..add(SetMunicipio(_selectedMunicipio!, context));
      }
    });
  }

  void _loadDataFromState() {
    final state = context.read<EdificacionBloc>().state;
    if (state.nombreEdificacion != null && state.nombreEdificacion!.isNotEmpty) {
      _nombreEdificacionController.text = state.nombreEdificacion!;
    }
    if (state.direccion != null && state.direccion!.isNotEmpty) {
      _direccionController.text = state.direccion!;
    }
    if (state.tipoVia != null && state.tipoVia!.isNotEmpty) {
      _tipoViaController.text = state.tipoVia!;
    }
    if (state.numeroVia != null && state.numeroVia!.isNotEmpty) {
      _numeroViaController.text = state.numeroVia!;
    }
    if (state.apendiceVia != null && state.apendiceVia!.isNotEmpty) {
      _apendiceViaController.text = state.apendiceVia!;
    }
    if (state.orientacionVia != null && state.orientacionVia!.isNotEmpty) {
      _orientacionViaController.text = state.orientacionVia!;
    }
    if (state.numeroCruce != null && state.numeroCruce!.isNotEmpty) {
      _numeroCruceController.text = state.numeroCruce!;
    }
    if (state.apendiceCruce != null && state.apendiceCruce!.isNotEmpty) {
      _apendiceCruceController.text = state.apendiceCruce!;
    }
    if (state.orientacionCruce != null && state.orientacionCruce!.isNotEmpty) {
      _orientacionCruceController.text = state.orientacionCruce!;
    }
    if (state.numero != null && state.numero!.isNotEmpty) {
      _numeroController.text = state.numero!;
    }
    if (state.complemento != null && state.complemento!.isNotEmpty) {
      _complementoController.text = state.complemento!;
    }
    if (state.departamento != null && state.departamento!.isNotEmpty) {
      _departamentoController.text = state.departamento!;
    }
    if (state.municipio != null && state.municipio!.isNotEmpty) {
      _municipioController.text = state.municipio!;
    }
    if (state.comuna != null && state.comuna!.isNotEmpty) {
      _comunaController.text = state.comuna!;
    }
    if (state.nombreContacto != null && state.nombreContacto!.isNotEmpty) {
      _nombreContactoController.text = state.nombreContacto!;
    }
    if (state.telefonoContacto != null && state.telefonoContacto!.isNotEmpty) {
      _telefonoContactoController.text = state.telefonoContacto!;
    }
    if (state.emailContacto != null && state.emailContacto!.isNotEmpty) {
      _emailContactoController.text = state.emailContacto!;
    }
    if (state.ocupacion != null && state.ocupacion!.isNotEmpty) {
      _ocupacionController.text = state.ocupacion!;
    }
    if (state.latitud != null && state.latitud!.isNotEmpty) {
      _latitudController.text = state.latitud!;
    }
    if (state.longitud != null && state.longitud!.isNotEmpty) {
      _longitudController.text = state.longitud!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EdificacionBloc, EdificacionState>(
      listener: (context, state) {
        _loadDataFromState();
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
                      child: _buildContacto(),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      final departamento = departamentosColombia.firstWhere(
                        (d) => d.nombre == value,
                      );
                      _selectedMunicipio = departamento.municipios.first;
                      _comunaController.clear(); // Limpiar comuna al cambiar departamento
                    });
                    // Actualizar el bloc
                    context.read<EdificacionBloc>()
                      ..add(SetDepartamento(value))
                      ..add(SetMunicipio(_selectedMunicipio!, context));
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
                      _comunaController.clear(); // Limpiar comuna al cambiar municipio
                    });
                    // Actualizar el bloc
                    context.read<EdificacionBloc>().add(SetMunicipio(value, context));
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
        if (_selectedDepartamento == 'Antioquia' && _selectedMunicipio == 'Medellín')
          DropdownButtonFormField<String>(
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
                setState(() {
                  _comunaController.text = value;
                });
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
        else
          TextFormField(
            controller: _comunaController,
            decoration: const InputDecoration(
              labelText: 'Comuna o Corregimiento',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (_municipioDebouncer?.isActive ?? false) _municipioDebouncer?.cancel();
              _municipioDebouncer = Timer(const Duration(milliseconds: 500), () {
                if (mounted) {
                  context.read<EdificacionBloc>().add(SetComuna(value));
                }
              });
            },
          ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _codigoBarrioController,
          label: 'Barrio',
          debouncer: _codigoBarrioDebouncer,
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
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.domain,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Identificación Catastral',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cbmlController,
                  decoration: InputDecoration(
                    labelText: _tipoIdentificacion == TipoIdentificacion.medellin
                        ? 'Código Catastral (11 dígitos)'
                        : 'Código Catastral (19 dígitos)',
                    border: const OutlineInputBorder(),
                    helperText: _tipoIdentificacion == TipoIdentificacion.medellin
                        ? 'Ingrese los 11 dígitos del código catastral'
                        : 'Ingrese los 19 dígitos del código catastral',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: _tipoIdentificacion == TipoIdentificacion.medellin ? 11 : 19,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                    if (_tipoIdentificacion == TipoIdentificacion.medellin && value!.length != 11) {
                      return 'El código debe tener 11 dígitos';
                    }
                    if (_tipoIdentificacion == TipoIdentificacion.areaMetropolitana && value!.length != 19) {
                      return 'El código debe tener 19 dígitos';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ubicación en el Mapa',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Seleccionar Ubicación'),
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          body: SafeArea(
                            child: MapLocationPicker(
                              initialLatitude: double.tryParse(_latitudController.text),
                              initialLongitude: double.tryParse(_longitudController.text),
                              onLocationSelected: (lat, long) {
                                // Actualizar los controladores después de la navegación
                                Navigator.pop(context);
                                setState(() {
                                  _latitudController.text = lat.toStringAsFixed(4);
                                  _longitudController.text = long.toStringAsFixed(4);
                                });
                                // Actualizar el bloc después de actualizar los controladores
                                context.read<EdificacionBloc>()
                                  ..add(SetLatitud(lat.toString()))
                                  ..add(SetLongitud(long.toString()));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: SizedBox(
                      height: 200,
                      child: MapLocationPicker(
                        initialLatitude: double.tryParse(_latitudController.text),
                        initialLongitude: double.tryParse(_longitudController.text),
                        onLocationSelected: (lat, long) {
                          // Actualizar los controladores después de la navegación
                          Navigator.pop(context);
                          setState(() {
                            _latitudController.text = lat.toStringAsFixed(4);
                            _longitudController.text = long.toStringAsFixed(4);
                          });
                          // Actualizar el bloc después de actualizar los controladores
                          context.read<EdificacionBloc>()
                            ..add(SetLatitud(lat.toString()))
                            ..add(SetLongitud(long.toString()));
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Seleccionar Ubicación'),
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            body: SafeArea(
                              child: MapLocationPicker(
                                initialLatitude: double.tryParse(_latitudController.text),
                                initialLongitude: double.tryParse(_longitudController.text),
                                onLocationSelected: (lat, long) {
                                  // Actualizar los controladores después de la navegación
                                  Navigator.pop(context);
                                  setState(() {
                                    _latitudController.text = lat.toStringAsFixed(4);
                                    _longitudController.text = long.toStringAsFixed(4);
                                  });
                                  // Actualizar el bloc después de actualizar los controladores
                                  context.read<EdificacionBloc>()
                                    ..add(SetLatitud(lat.toString()))
                                    ..add(SetLongitud(long.toString()));
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Abrir mapa en pantalla completa'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContacto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Persona de contacto',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nombre
                _buildTextField(
                  controller: _nombreContactoController,
                  label: 'Nombre',
                  debouncer: _nombreContactoDebouncer,
                  onChanged: (value) => context.read<EdificacionBloc>().add(SetNombreContacto(value)),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Teléfono
                _buildTextField(
                  controller: _telefonoContactoController,
                  label: 'Teléfono',
                  debouncer: _telefonoContactoDebouncer,
                  onChanged: (value) => context.read<EdificacionBloc>().add(SetTelefonoContacto(value)),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email
                _buildTextField(
                  controller: _emailContactoController,
                  label: 'E-mail',
                  debouncer: _emailContactoDebouncer,
                  onChanged: (value) => context.read<EdificacionBloc>().add(SetEmailContacto(value, context)),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Tipo de ocupante
                Text(
                  'Tipo de ocupante:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16.0,
                  children: [
                    ChoiceChip(
                      label: const Text('Propietario'),
                      selected: _ocupacionController.text == 'Propietario',
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color: _ocupacionController.text == 'Propietario'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: _ocupacionController.text == 'Propietario'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _ocupacionController.text = 'Propietario';
                          });
                          context.read<EdificacionBloc>().add(SetOcupacion('Propietario'));
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Inquilino'),
                      selected: _ocupacionController.text == 'Inquilino',
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color: _ocupacionController.text == 'Inquilino'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: _ocupacionController.text == 'Inquilino'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _ocupacionController.text = 'Inquilino';
                          });
                          context.read<EdificacionBloc>().add(SetOcupacion('Inquilino'));
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Otro'),
                      selected: _ocupacionController.text != 'Propietario' && 
                               _ocupacionController.text != 'Inquilino' &&
                               _ocupacionController.text.isNotEmpty,
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color: (_ocupacionController.text != 'Propietario' && 
                               _ocupacionController.text != 'Inquilino' &&
                               _ocupacionController.text.isNotEmpty)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: (_ocupacionController.text != 'Propietario' && 
                                   _ocupacionController.text != 'Inquilino' &&
                                   _ocupacionController.text.isNotEmpty)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final otroController = TextEditingController(
                                text: _ocupacionController.text != 'Propietario' && 
                                     _ocupacionController.text != 'Inquilino'
                                    ? _ocupacionController.text
                                    : ''
                              );
                              return AlertDialog(
                                title: const Text('Especifique'),
                                content: TextField(
                                  controller: otroController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de ocupante',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (otroController.text.isNotEmpty) {
                                        setState(() {
                                          _ocupacionController.text = otroController.text;
                                        });
                                        context.read<EdificacionBloc>().add(SetOcupacion(otroController.text));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
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
    _codigoBarrioDebouncer?.cancel();
    _cbmlDebouncer?.cancel();
    _ocupacionDebouncer?.cancel();
    _latitudDebouncer?.cancel();
    _longitudDebouncer?.cancel();
    _tipoViaDebouncer?.cancel();
    _numeroViaDebouncer?.cancel();
    _apendiceViaDebouncer?.cancel();
    _orientacionViaDebouncer?.cancel();
    _numeroCruceDebouncer?.cancel();
    _apendiceCruceDebouncer?.cancel();
    _orientacionCruceDebouncer?.cancel();
    _numeroDebouncer?.cancel();
    _complementoDebouncer?.cancel();
    _departamentoDebouncer?.cancel();
    _municipioDebouncer?.cancel();
    _nombreContactoDebouncer?.cancel();
    _telefonoContactoDebouncer?.cancel();
    _emailContactoDebouncer?.cancel();

    _nombreEdificacionController.dispose();
    _direccionController.dispose();
    _codigoBarrioController.dispose();
    _cbmlController.dispose();
    _ocupacionController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _tipoViaController.dispose();
    _numeroViaController.dispose();
    _apendiceViaController.dispose();
    _orientacionViaController.dispose();
    _numeroCruceController.dispose();
    _apendiceCruceController.dispose();
    _orientacionCruceController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _departamentoController.dispose();
    _municipioController.dispose();
    _comunaController.dispose();
    _nombreContactoController.dispose();
    _telefonoContactoController.dispose();
    _emailContactoController.dispose();
    
    _tabController.dispose();
    super.dispose();
  }

  void _debounce(Timer? timer, VoidCallback callback) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), callback);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Timer? debouncer,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
      onChanged: (value) {
        if (onChanged != null) {
          if (debouncer?.isActive ?? false) debouncer?.cancel();
          debouncer = Timer(const Duration(milliseconds: 500), () {
            if (mounted) {
              onChanged(value);
            }
          });
        }
      },
    );
  }

  Widget _buildDireccionEstructurada(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vista previa de la dirección con estilo mejorado
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: DireccionPreview(),
          ),
        ),
        const SizedBox(height: 24),
        
        // Vía Principal
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_road,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vía Principal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tipo de Vía
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Vía',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
                  items: ['CL', 'CR', 'CQ', 'TV', 'DG']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == 'CL' ? 'Calle (CL)' :
                              e == 'CR' ? 'Carrera (CR)' :
                              e == 'CQ' ? 'Circular (CQ)' :
                              e == 'TV' ? 'Transversal (TV)' :
                              'Diagonal (DG)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: _tipoViaController.text.isEmpty ? null : _tipoViaController.text,
                  onChanged: (value) {
                    if (value != null) {
                      _tipoViaController.text = value;
                      context.read<EdificacionBloc>().add(SetTipoVia(value));
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Número de Vía
                TextFormField(
                  controller: _numeroViaController,
                  decoration: InputDecoration(
                    labelText: 'Número de Vía',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (_numeroViaDebouncer?.isActive ?? false) _numeroViaDebouncer?.cancel();
                    _numeroViaDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetNumeroVia(value));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Apéndice de Vía
                TextFormField(
                  controller: _apendiceViaController,
                  decoration: InputDecoration(
                    labelText: 'Apéndice de Vía',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    hintText: 'Ej: A, B, BIS',
                  ),
                  onChanged: (value) {
                    if (_apendiceViaDebouncer?.isActive ?? false) _apendiceViaDebouncer?.cancel();
                    _apendiceViaDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetApendiceVia(value));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Orientación de Vía
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Orientación de Vía',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  items: ['NORTE', 'SUR', 'ESTE', 'OESTE']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: _orientacionViaController.text.isEmpty ? null : _orientacionViaController.text,
                  onChanged: (value) {
                    if (value != null) {
                      _orientacionViaController.text = value;
                      context.read<EdificacionBloc>().add(SetOrientacionVia(value, context));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Cruce
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.route,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cruce',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Número de Cruce
                TextFormField(
                  controller: _numeroCruceController,
                  decoration: InputDecoration(
                    labelText: 'Número de Cruce',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (_numeroCruceDebouncer?.isActive ?? false) _numeroCruceDebouncer?.cancel();
                    _numeroCruceDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetNumeroCruce(value));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Apéndice de Cruce
                TextFormField(
                  controller: _apendiceCruceController,
                  decoration: InputDecoration(
                    labelText: 'Apéndice de Cruce',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    hintText: 'Ej: A, B, BIS',
                  ),
                  onChanged: (value) {
                    if (_apendiceCruceDebouncer?.isActive ?? false) _apendiceCruceDebouncer?.cancel();
                    _apendiceCruceDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetApendiceCruce(value));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Orientación de Cruce
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Orientación de Cruce',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  items: ['NORTE', 'SUR', 'ESTE', 'OESTE']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: _orientacionCruceController.text.isEmpty ? null : _orientacionCruceController.text,
                  onChanged: (value) {
                    if (value != null) {
                      _orientacionCruceController.text = value;
                      context.read<EdificacionBloc>().add(SetOrientacionCruce(value, context));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Número y Complemento
        Card(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Número y Complemento',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Número
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (_numeroDebouncer?.isActive ?? false) _numeroDebouncer?.cancel();
                    _numeroDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetNumero(value));
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Complemento
                TextFormField(
                  controller: _complementoController,
                  decoration: InputDecoration(
                    labelText: 'Complemento',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    hintText: 'Ej: Torre 1, Apto 201',
                  ),
                  onChanged: (value) {
                    if (_complementoDebouncer?.isActive ?? false) _complementoDebouncer?.cancel();
                    _complementoDebouncer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        context.read<EdificacionBloc>().add(SetComplemento(value));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaracteristicasEdificacion(BuildContext context) {
    return const Column(
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

