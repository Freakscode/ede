// ignore_for_file: unused_import, unused_element, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/form/evaluacion/evaluacion_bloc.dart';
import '../../bloc/form/evaluacion/evaluacion_event.dart';
import '../../bloc/form/evaluacion/evaluacion_state.dart';
import '../../widgets/navigation_fab_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class EvaluacionWizardPage extends StatefulWidget {
  const EvaluacionWizardPage({super.key});

  @override
  State<EvaluacionWizardPage> createState() => _EvaluacionWizardPageState();
}

class _EvaluacionWizardPageState extends State<EvaluacionWizardPage> with SingleTickerProviderStateMixin {
  String? _selectedEvento;
  String? _otroEventoDescripcion;
  final _otroEventoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _idGrupoController = TextEditingController();
  final _dependenciaController = TextEditingController();
  final _idEventoController = TextEditingController();
  final _pageController = PageController();
  late DateTime _fechaInspeccion;
  late TimeOfDay _horaInspeccion;
  String? _firmaPath;
  int _currentPage = 0;
  late TabController _tabController;
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentPage = _tabController.index;
      });
    });
    
    // Inicializar fecha y hora
    _fechaInspeccion = DateTime.now();
    _horaInspeccion = TimeOfDay.fromDateTime(_fechaInspeccion);
    
    // Iniciar la evaluación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<EvaluacionBloc>();
      bloc.add(EvaluacionStarted());
      
      // Cargar datos guardados
      final state = bloc.state;
      if (state.nombreEvaluador != null) _nombreController.text = state.nombreEvaluador!;
      if (state.idGrupo != null) _idGrupoController.text = state.idGrupo!;
      if (state.dependenciaEntidad != null) _dependenciaController.text = state.dependenciaEntidad!;
      if (state.firmaPath != null) _firmaPath = state.firmaPath;
      if (state.eventoSeleccionado != null) _selectedEvento = state.eventoSeleccionado;
      if (state.descripcionOtro != null) _otroEventoController.text = state.descripcionOtro!;
      
      // Guardar fecha y hora inicial si no existe
      if (state.fechaInspeccion == null || state.horaInspeccion == null) {
        bloc.add(SetEvaluacionData(
          fechaInspeccion: _fechaInspeccion,
          horaInspeccion: _horaInspeccion,
        ));
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _idGrupoController.dispose();
    _dependenciaController.dispose();
    _idEventoController.dispose();
    _otroEventoController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluacionBloc, EvaluacionState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Identificación de la Evaluación'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.person_outline),
                  text: 'Datos del Evaluador',
                ),
                Tab(
                  icon: Icon(Icons.event_note),
                  text: 'Evento',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDatosEvaluadorTab(theme, state),
              _buildSeleccionEventoTab(theme),
            ],
          ),
          bottomNavigationBar: _buildNavigationButtons(theme),
          floatingActionButton: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                bottom: 80,
                child: FloatingActionButton.small(
                  heroTag: 'help_button',
                  onPressed: () => _showHelp(context),
                  child: const Icon(Icons.help_outline),
                ),
              ),
              const NavigationFabMenu(currentRoute: '/id_evaluacion'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatosEvaluadorTab(ThemeData theme, EvaluacionState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha y Hora de Inspección',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectFecha(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_fechaInspeccion.day.toString().padLeft(2, '0')}/${_fechaInspeccion.month.toString().padLeft(2, '0')}/${_fechaInspeccion.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectHora(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _horaInspeccion.format(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Evaluador',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Evaluador *',
                        hintText: 'Ingrese su nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<EvaluacionBloc>().add(
                          SetEvaluacionData(nombreEvaluador: value),
                        );
                      },
                      validator: (value) => _validateField(value, 'nombre'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _idGrupoController,
                      decoration: const InputDecoration(
                        labelText: 'ID del Grupo *',
                        hintText: 'Ingrese el ID de su grupo',
                        prefixIcon: Icon(Icons.group_outlined),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<EvaluacionBloc>().add(
                          SetEvaluacionData(idGrupo: value),
                        );
                      },
                      validator: (value) => _validateField(value, 'ID de grupo'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dependenciaController,
                      decoration: const InputDecoration(
                        labelText: 'Dependencia/Entidad *',
                        hintText: 'Ingrese su dependencia o entidad',
                        prefixIcon: Icon(Icons.business_outlined),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<EvaluacionBloc>().add(
                          SetEvaluacionData(dependenciaEntidad: value),
                        );
                      },
                      validator: (value) => _validateField(value, 'dependencia'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _idEventoController,
                      decoration: const InputDecoration(
                        labelText: 'ID Evento *',
                        hintText: 'Ingrese el ID del evento',
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<EvaluacionBloc>().add(
                          SetEvaluacionData(idEvento: value),
                        );
                      },
                      validator: (value) => _validateField(value, 'ID evento'),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Firma Digital',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Formatos admitidos: JPG, PNG y PDF',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: _firmaPath != null
                                  ? Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(_firmaPath!),
                                            height: 120,
                                            width: double.infinity,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton.icon(
                                          onPressed: _pickFirma,
                                          icon: const Icon(Icons.edit),
                                          label: const Text('Cambiar firma'),
                                        ),
                                      ],
                                    )
                                  : OutlinedButton.icon(
                                      onPressed: _pickFirma,
                                      icon: const Icon(Icons.upload_file),
                                      label: const Text('Subir Firma'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showValidationErrors && (_nombreController.text.isEmpty || 
                _idGrupoController.text.isEmpty || 
                _dependenciaController.text.isEmpty))
              Card(
                color: theme.colorScheme.errorContainer.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Información Importante',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                        const SizedBox(height: 8),
                      Text(
                        'Los campos marcados con * son necesarios para generar el reporte final. '
                        'Puedes continuar ahora, pero asegúrate de completarlos antes de finalizar la evaluación.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeleccionEventoTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccione el Tipo de Evento',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              _buildEventoCard(context, 'SISMO', 'assets/icons/svg/Sismo.svg'),
              _buildEventoCard(context, 'INUNDACIÓN', 'assets/icons/svg/Inundacion.svg'),
              _buildEventoCard(context, 'DESLIZAMIENTO', 'assets/icons/svg/Deslizamiento.svg'),
              _buildEventoCard(context, 'VIENTO', 'assets/icons/svg/Viento.svg'),
              _buildEventoCard(context, 'INCENDIO', 'assets/icons/svg/Incendio.svg'),
              _buildEventoCard(context, 'EXPLOSIÓN', 'assets/icons/svg/Explosion.svg'),
              _buildEventoCard(context, 'ESTRUCTURAL', 'assets/icons/svg/Estructural.svg'),
              _buildEventoCard(context, 'OTRO', 'assets/icons/svg/Otro.svg'),
            ],
          ),
          if (_selectedEvento == 'OTRO') ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Especifique el Tipo de Evento',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _otroEventoController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción del Evento *',
                        hintText: 'Ingrese el tipo de evento',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (value) {
                        if (_selectedEvento == 'OTRO' && (value?.isEmpty ?? true)) {
                          return 'Por favor, especifique el tipo de evento';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Actualizar solo el estado local inmediatamente
                        setState(() {
                          _otroEventoDescripcion = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _tabController.animateTo(_currentPage - 1),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Anterior'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    if (_selectedEvento != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/id_edificacion'),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Continuar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (_currentPage == 0)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showValidationErrors = true;
                    });
                    // Permitir avanzar sin validación
                    _tabController.animateTo(_currentPage + 1);
                    
                    // Mostrar advertencia si hay campos vacíos
                    if (_formKey.currentState?.validate() ?? false) {
                      return;
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.info_outline, color: theme.colorScheme.onError),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Hay campos pendientes por completar. Podrás continuar, pero recuerda que son necesarios para generar el reporte final.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: theme.colorScheme.error,
                        duration: const Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Entendido',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Siguiente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentPage == 0
                  ? '• Complete todos los campos del formulario\n'
                    '• La firma puede ser una imagen o un PDF\n'
                    '• Puede editar la fecha y hora haciendo clic en los campos'
                  : '• Seleccione el tipo de evento que ocasionó los daños\n'
                    '• Solo puede seleccionar un tipo de evento\n'
                    '• Una vez seleccionado, puede continuar a la siguiente sección',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
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
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (_selectedEvento == titulo) {
            _selectedEvento = null;
            if (titulo == 'OTRO') {
              _otroEventoController.clear();
              _otroEventoDescripcion = null;
            }
          } else {
            _selectedEvento = titulo;
          }
        });
        
        // Actualizar el bloc con el nuevo estado
        context.read<EvaluacionBloc>().add(SetEvaluacionData(
          eventoSeleccionado: _selectedEvento,
          descripcionOtro: _selectedEvento == 'OTRO' ? _otroEventoDescripcion : null,
        ));
      },
      child: Container(
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isSelected 
                ? theme.colorScheme.secondary 
                : const Color(0xFFFAD502),
            width: isSelected ? 2.5 : 2,
          ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: TextStyle(
                color: isSelected ? Colors.white : theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
        ),
      ),
    );
  }

  String? _validateField(String? value, String fieldName) {
    // Solo mostrar el indicador visual de requerido, sin bloquear
    if (!_showValidationErrors) return null;
    if (value?.isEmpty ?? true) {
      return 'Campo pendiente por completar';
    }
    return null;
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
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1000,
    );
    
    if (image != null) {
      setState(() {
        _firmaPath = image.path;
      });
      // Actualizar el BLoC con la nueva firma y guardarla como default
      context.read<EvaluacionBloc>().add(SignatureUpdated(image.path));
    }
  }
}