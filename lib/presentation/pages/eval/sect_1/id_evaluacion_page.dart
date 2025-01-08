// ignore_for_file: unused_import, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import '../../../blocs/form/identificacionEvaluacion/id_evaluacion_event.dart';
import '../../../blocs/form/identificacionEvaluacion/id_evaluacion_state.dart';
import 'evento_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/navigation_fab_menu.dart';

class EvaluacionWizardPage extends StatefulWidget {
  const EvaluacionWizardPage({super.key});

  @override
  State<EvaluacionWizardPage> createState() => _EvaluacionWizardPageState();
}

class _EvaluacionWizardPageState extends State<EvaluacionWizardPage> {
  int _currentStep = 0;
  final _dependenciaController = TextEditingController();
  final _idGrupoController = TextEditingController();
  final _idEventoController = TextEditingController();
  String? _firmaPath;

  @override
  void initState() {
    super.initState();
    // Cargar datos temporales del bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EvaluacionBloc>().state;
      _loadDataFromState(state);
    });
  }

  void _loadDataFromState(EvaluacionState state) {
    if (state.idGrupo != null) {
      _idGrupoController.text = state.idGrupo!;
    }
    if (state.dependenciaEntidad != null) {
      _dependenciaController.text = state.dependenciaEntidad!;
    }
    if (state.idEvento != null) {
      _idEventoController.text = state.idEvento!;
    }
    setState(() {
      _firmaPath = state.firma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificación de la Evaluación'),
        actions: [
          // Indicador de campos completos
          BlocBuilder<EvaluacionBloc, EvaluacionState>(
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
        currentRoute: '/id_evaluacion',
      ),
      body: BlocBuilder<EvaluacionBloc, EvaluacionState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 100,
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  onStepTapped: (step) {
                    setState(() => _currentStep = step);
                  },
                  controlsBuilder: (context, details) {
                    return Container();
                  },
                  steps: [
                    Step(
                      title: const Text('Datos'),
                      content: Container(),
                      isActive: _currentStep >= 0,
                      state: _validateFirstSection(state) 
                          ? StepState.complete 
                          : (_currentStep == 0 ? StepState.editing : StepState.indexed),
                    ),
                    Step(
                      title: const Text('Evento'),
                      content: Container(),
                      isActive: _currentStep >= 1,
                      state: _validateSecondSection(state)
                          ? StepState.complete
                          : (_currentStep == 1 ? StepState.editing : StepState.indexed),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _currentStep == 0 
                    ? _buildDatosGenerales(context, state) 
                    : _buildEvento(context, state),
                ),
              ),
              _buildNavigationButtons(context, state),
            ],
          );
        },
      ),
    );
  }

  bool _canMoveToStep(int step, EvaluacionState state) {
    // Permitir navegación libre entre secciones
    return true;
  }

  Widget _buildDatosGenerales(BuildContext context, EvaluacionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ID Evento
        TextField(
          controller: _idEventoController,
          decoration: const InputDecoration(
            labelText: 'ID Evento',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<EvaluacionBloc>().add(SetIdEvento(value));
          },
        ),
        const SizedBox(height: 16),

        // ID Grupo
        TextField(
          controller: _idGrupoController,
          decoration: const InputDecoration(
            labelText: 'ID Grupo',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<EvaluacionBloc>().add(SetIdGrupo(value));
          },
        ),
        const SizedBox(height: 16),

        // Dependencia
        TextField(
          controller: _dependenciaController,
          decoration: const InputDecoration(
            labelText: 'Dependencia/Entidad',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<EvaluacionBloc>().add(SetDependencia(value));
          },
        ),
        const SizedBox(height: 16),

        // Firma
        const Text('Firma del evaluador:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _firmaPath != null
                    ? Image.file(File(_firmaPath!), fit: BoxFit.contain)
                    : const Center(child: Text('No se ha seleccionado firma')),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _seleccionarFirma,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir'),
                ),
                if (_firmaPath != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _eliminarFirma,
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _seleccionarFirma() async {
    try {
      // Solicitar permisos para Android 13 y superior
      final status = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();
      
      if (status.isGranted || storageStatus.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? imagen = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        
        if (imagen != null) {
          final String nombreArchivo = 'firma_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final String rutaDestino = await _guardarImagenLocal(imagen, nombreArchivo);
          
          setState(() {
            _firmaPath = rutaDestino;
          });
          context.read<EvaluacionBloc>().add(SetFirma(rutaDestino));
        }
      } else if (status.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
        // Si los permisos fueron denegados permanentemente, dirigir al usuario a la configuración
        await openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se requieren permisos para acceder a la galería'),
            action: SnackBarAction(
              label: 'Configuración',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar la imagen: $e')),
      );
    }
  }

  Future<String> _guardarImagenLocal(XFile imagen, String nombreArchivo) async {
    try {
      // Obtener el directorio de documentos de la aplicación
      final Directory directorio = await getApplicationDocumentsDirectory();
      final String rutaDirectorio = directorio.path;
      
      // Crear directorio para firmas si no existe
      final Directory directorioFirmas = Directory('$rutaDirectorio/firmas');
      if (!await directorioFirmas.exists()) {
        await directorioFirmas.create(recursive: true);
      }
      
      // Copiar la imagen al directorio de la aplicación
      final String rutaDestino = '${directorioFirmas.path}/$nombreArchivo';
      await imagen.saveTo(rutaDestino);
      
      return rutaDestino;
    } catch (e) {
      throw Exception('Error al guardar la imagen: $e');
    }
  }

  void _eliminarFirma() {
    setState(() {
      _firmaPath = null;
    });
    context.read<EvaluacionBloc>().add(SetFirma(''));
  }

  Widget _buildEvento(BuildContext context, EvaluacionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona el tipo de evento:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: TipoEvento.values.map((evento) {
            final bool isSelected = state.eventoSeleccionado == evento;
            
            return EventoButton(
              evento: evento,
              isSelected: isSelected,
              onPressed: () {
                context.read<EvaluacionBloc>().add(SetEvento(evento));
              },
            );
          }).toList(),
        ),
        if (state.eventoSeleccionado == TipoEvento.otro) ...[
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Especifique el tipo de evento',
              border: OutlineInputBorder(),
              hintText: 'Describa el tipo de evento',
            ),
            onChanged: (value) {
              context.read<EvaluacionBloc>()
                  .add(SetEvento(TipoEvento.otro, descripcionOtro: value));
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context, EvaluacionState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton(
              onPressed: () {
                setState(() => _currentStep--);
              },
              child: const Text('Anterior'),
            ),
          ElevatedButton(
            onPressed: () {
              if (_currentStep < 1) {
                setState(() => _currentStep++);
              } else {
                // Validar todos los campos requeridos antes de continuar
                if (_validateAllFields(state)) {
                  // Guardar datos y navegar a la siguiente sección
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos guardados exitosamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Navegar a la página de identificación de edificación
                  context.go('/id_edificacion');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Por favor complete todos los campos requeridos'),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'Revisar',
                        onPressed: () {
                          if (!_validateFirstSection(state)) {
                            setState(() => _currentStep = 0);
                          }
                        },
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(_currentStep < 1 ? 'Siguiente' : 'Continuar'),
          ),
        ],
      ),
    );
  }

  bool _validateFirstSection(EvaluacionState state) {
    return _idGrupoController.text.isNotEmpty &&
           _dependenciaController.text.isNotEmpty &&
           state.firma != null;
  }

  bool _validateSecondSection(EvaluacionState state) {
    return state.eventoSeleccionado != null &&
           (state.eventoSeleccionado != TipoEvento.otro || 
            (state.descripcionOtro?.isNotEmpty ?? false));
  }

  bool _validateAllFields(EvaluacionState state) {
    return _validateFirstSection(state) && _validateSecondSection(state);
  }

  @override
  void dispose() {
    // No limpiar el estado del bloc al hacer dispose
    _dependenciaController.dispose();
    _idGrupoController.dispose();
    _idEventoController.dispose();
    super.dispose();
  }
}