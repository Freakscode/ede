// ignore_for_file: unused_import, unused_element, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/form/evaluacion/evaluacion_bloc.dart';
import '../../../blocs/form/evaluacion/evaluacion_event.dart';
import '../../../blocs/form/evaluacion/evaluacion_state.dart';
import '../../../widgets/navigation_fab_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EvaluacionWizardPage extends StatefulWidget {
  const EvaluacionWizardPage({super.key});

  @override
  State<EvaluacionWizardPage> createState() => _EvaluacionWizardPageState();
}

class _EvaluacionWizardPageState extends State<EvaluacionWizardPage> {
  String? _selectedEvento;
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _idGrupoController = TextEditingController();
  final _dependenciaController = TextEditingController();
  final _pageController = PageController();
  late DateTime _fechaInspeccion;
  late TimeOfDay _horaInspeccion;
  String? _firmaPath;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<EvaluacionBloc>().add(EvaluacionStarted());
    // Tomar fecha y hora actual
    _fechaInspeccion = DateTime.now();
    _horaInspeccion = TimeOfDay.fromDateTime(_fechaInspeccion);
    
    // Cargar datos guardados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<EvaluacionBloc>().state;
      
      // Inicializar con datos del BLoC si existen
      if (state.nombreEvaluador != null) _nombreController.text = state.nombreEvaluador!;
      if (state.idGrupo != null) _idGrupoController.text = state.idGrupo!;
      if (state.dependenciaEntidad != null) _dependenciaController.text = state.dependenciaEntidad!;
      if (state.firmaPath != null) _firmaPath = state.firmaPath;
      if (state.eventoSeleccionado != null) _selectedEvento = state.eventoSeleccionado;
      
      // Si no hay fecha/hora guardada, guardar la actual
      if (state.fechaInspeccion == null || state.horaInspeccion == null) {
        context.read<EvaluacionBloc>().add(SetEvaluacionData(
          fechaInspeccion: _fechaInspeccion,
          horaInspeccion: _horaInspeccion,
        ));
      }
    });

    // Agregar listeners para los cambios en los campos
    _nombreController.addListener(_onNombreChanged);
    _idGrupoController.addListener(_onIdGrupoChanged);
    _dependenciaController.addListener(_onDependenciaChanged);
  }

  @override
  void dispose() {
    _nombreController.removeListener(_onNombreChanged);
    _idGrupoController.removeListener(_onIdGrupoChanged);
    _dependenciaController.removeListener(_onDependenciaChanged);
    _nombreController.dispose();
    _idGrupoController.dispose();
    _dependenciaController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNombreChanged() {
    context.read<EvaluacionBloc>().add(SetEvaluacionData(
      nombreEvaluador: _nombreController.text,
    ));
  }

  void _onIdGrupoChanged() {
    context.read<EvaluacionBloc>().add(SetEvaluacionData(
      idGrupo: _idGrupoController.text,
    ));
  }

  void _onDependenciaChanged() {
    context.read<EvaluacionBloc>().add(SetEvaluacionData(
      dependenciaEntidad: _dependenciaController.text,
    ));
  }

  void _nextPage() {
    if (_formKey.currentState?.validate() ?? false) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInspeccion ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaInspeccion) {
      setState(() {
        _fechaInspeccion = picked;
      });
    }
  }

  Future<void> _selectHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaInspeccion ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _horaInspeccion) {
      setState(() {
        _horaInspeccion = picked;
      });
    }
  }

  Future<void> _pickFirma() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _firmaPath = image.path;
      });
      // Actualizar el BLoC con la nueva firma y guardarla como default
      context.read<EvaluacionBloc>().add(SignatureUpdated(image.path));
    }
  }

  void _showNavigationMenu(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Navegación',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildNavigationItem(context, 'id_evaluacion', '1. Identificación de la Evaluación', Icons.assignment),
                    _buildNavigationItem(context, 'id_edificacion', '2. Identificación de la Edificación', Icons.business),
                    _buildNavigationItem(context, 'descripcion_edificacion', '3. Descripción de la Edificación', Icons.description),
                    _buildNavigationItem(context, 'riesgos_externos', '4. Riesgos Externos', Icons.warning),
                    _buildNavigationItem(context, 'evaluacion_danos', '5. Evaluación de Daños', Icons.build),
                    _buildNavigationItem(context, 'nivel_dano', '6. Nivel de Daño', Icons.assessment),
                    _buildNavigationItem(context, 'habitabilidad', '7. Habitabilidad', Icons.home),
                    _buildNavigationItem(context, 'acciones', '8. Acciones Recomendadas', Icons.recommend),
                    _buildNavigationItem(context, 'resumen', 'Resumen', Icons.summarize),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(BuildContext context, String route, String title, IconData icon) {
    final theme = Theme.of(context);
    final bool isSelected = route == 'id_evaluacion';
    
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.secondary.withAlpha(26),
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          context.go('/$route');
        }
      },
    );
  }

  void _handleSignatureUpdate(String firmaPath) {
    context.read<EvaluacionBloc>().add(SignatureUpdated(firmaPath));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<EvaluacionBloc, EvaluacionState>(
      listenWhen: (previous, current) {
        return (current.nombreEvaluador != null && current.nombreEvaluador != _nombreController.text) ||
               (current.idGrupo != null && current.idGrupo != _idGrupoController.text) ||
               (current.dependenciaEntidad != null && current.dependenciaEntidad != _dependenciaController.text) ||
               (current.firmaPath != null && current.firmaPath != _firmaPath) ||
               current.eventoSeleccionado != _selectedEvento;
      },
      listener: (context, state) {
        if (state.nombreEvaluador != null && _nombreController.text.isEmpty) {
          _nombreController.text = state.nombreEvaluador!;
        }
        if (state.idGrupo != null && _idGrupoController.text.isEmpty) {
          _idGrupoController.text = state.idGrupo!;
        }
        if (state.dependenciaEntidad != null && _dependenciaController.text.isEmpty) {
          _dependenciaController.text = state.dependenciaEntidad!;
        }
        if (state.firmaPath != null && _firmaPath == null) {
          setState(() {
            _firmaPath = state.firmaPath;
          });
        }
        if (state.eventoSeleccionado != _selectedEvento) {
          setState(() {
            _selectedEvento = state.eventoSeleccionado;
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => _showNavigationMenu(context),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'IDENTIFICACIÓN\nDE EVALUACIÓN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.person_outline, color: Colors.white),
                        onPressed: () {
                          // Manejar perfil
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildDatosEvaluador(theme),
              _buildSeleccionEvento(theme),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('ANTERIOR'),
                  ),
                ),
              if (_currentPage == 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('SIGUIENTE'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosEvaluador(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DATOS DEL EVALUADOR',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            // Fecha y Hora (solo mostrar, no editable)
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha de Inspección',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabled: false,
                    ),
                    child: Text(
                      '${_fechaInspeccion.day.toString().padLeft(2, '0')}/${_fechaInspeccion.month.toString().padLeft(2, '0')}/${_fechaInspeccion.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Hora',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabled: false,
                    ),
                    child: Text(
                      '${_horaInspeccion.hour.toString().padLeft(2, '0')}:${_horaInspeccion.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Evaluador',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del evaluador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _idGrupoController,
              decoration: InputDecoration(
                labelText: 'ID del Grupo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.group),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID del grupo';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dependenciaController,
              decoration: InputDecoration(
                labelText: 'Dependencia/Entidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.business),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la dependencia o entidad';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Firma (Archivos admitidos: JPG, PNG y PDF)',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickFirma,
                  icon: const Icon(Icons.upload),
                  label: const Text('SUBIR FIRMA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (_firmaPath != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text('PREVISUALIZACIÓN'),
                        const SizedBox(height: 8),
                        Image.file(
                          File(_firmaPath!),
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeleccionEvento(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              _buildEventoCard(
                context,
                'INUNDACIÓN',
                'assets/icons/svg/Inundacion.svg',
              ),
              _buildEventoCard(
                context,
                'DESLIZAMIENTO',
                'assets/icons/svg/Deslizamiento.svg',
              ),
              _buildEventoCard(
                context,
                'SISMO',
                'assets/icons/svg/Sismo.svg',
              ),
              _buildEventoCard(
                context,
                'VIENTO',
                'assets/icons/svg/Viento.svg',
              ),
              _buildEventoCard(
                context,
                'INCENDIO',
                'assets/icons/svg/Incendio.svg',
              ),
              _buildEventoCard(
                context,
                'EXPLOSIÓN',
                'assets/icons/svg/Explosion.svg',
              ),
              _buildEventoCard(
                context,
                'ESTRUCTURAL',
                'assets/icons/svg/Estructural.svg',
              ),
              _buildEventoCard(
                context,
                'OTRO',
                'assets/icons/svg/Otro.svg',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventoCard(
    BuildContext context,
    String titulo,
    String iconPath,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedEvento == titulo;
    
    final int alpha = titulo == 'ESTRUCTURAL' ? 153 : 255;
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFAD502),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedEvento = _selectedEvento == titulo ? null : titulo;
          });
          context.read<EvaluacionBloc>().add(SetEvaluacionData(
            eventoSeleccionado: _selectedEvento == titulo ? titulo : null,
          ));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      (isSelected ? Colors.white : theme.primaryColor).withAlpha(alpha),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: TextStyle(
                  color: (isSelected ? Colors.white : theme.primaryColor).withAlpha(alpha),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}