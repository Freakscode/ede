import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_expandable_dropdown.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_date_picker.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_time_picker.dart';
import 'package:caja_herramientas/app/shared/widgets/text/section_title.dart';
import 'package:caja_herramientas/app/shared/widgets/info/warning_info_widget.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_bloc.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/events/data_registration_events.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_state.dart';
import 'package:go_router/go_router.dart';

class InspectionFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const InspectionFormWidget({super.key, required this.formKey});

  @override
  State<InspectionFormWidget> createState() => _InspectionFormWidgetState();
}

class _InspectionFormWidgetState extends State<InspectionFormWidget> {
  final _incidentIdController = TextEditingController();
  final _commentController = TextEditingController();
  final _injuredController = TextEditingController();
  final _deadController = TextEditingController();

  final List<String> _statusOptions = [
    'En proceso',
    'Completada',
    'Cancelada',
    'Pendiente',
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar formulario en el bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataRegistrationBloc>().add(const InspectionFormInitialize());
    });
  }

  @override
  void dispose() {
    _incidentIdController.dispose();
    _commentController.dispose();
    _injuredController.dispose();
    _deadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataRegistrationBloc, DataRegistrationState>(
      listener: (context, state) {
        if (state is CompleteRegistrationSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Navegar al home con navigationData para mostrar RiskEventsScreen
          print('=== NAVEGANDO AL HOME PARA CREAR NUEVO FORMULARIO ===');
          print('NavigationData: {showRiskEvents: true, resetForNewForm: true}');
          context.go('/home', extra: {
            'showRiskEvents': true,
            'resetForNewForm': true,
          });
          print('=== NAVEGACIÓN EJECUTADA ===');
        } else if (state is DataRegistrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
          return Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y subtítulo
                const SectionTitle(
                  title: 'Registro de datos',
                  subtitle: 'Inspección por riesgo',
                ),

                const SizedBox(height: 20),

                // Campo Id Incidente
                _buildIncidentIdField(context, state),

                const SizedBox(height: 16),

                // Campo Estado
                _buildStatusField(context, state),

                const SizedBox(height: 16),

                // Campo Fecha
                _buildDateField(context, state),

                const SizedBox(height: 16),

                // Campo Hora
                _buildTimeField(context, state),

                const SizedBox(height: 16),

                // Campo Comentario
                _buildCommentField(context, state),

                const SizedBox(height: 16),

                // Campo Número de lesionados
                _buildInjuredField(context, state),

                const SizedBox(height: 16),

                // Campo Número de muertos
                _buildDeadField(context, state),

                const SizedBox(height: 24),

                // Widget de advertencia
                const WarningInfoWidget(
                  title: 'Información',
                  message:
                      'Antes de iniciar la evaluación del riesgo, tenga en cuenta que los resultados son únicamente de carácter orientativo. El DAGRD no asume responsabilidad alguna sobre su uso o interpretación',
                ),

                const SizedBox(height: 24),

                // Botón Finalizar
                CustomElevatedButton(
                  text: 'Finalizar',
                  onPressed: _canSubmit(state) ? _handleSubmit : null,
                  isLoading: state is DataRegistrationLoading,
                ),
              ],
            ),
          );
      },
    );
  }

  Widget _buildIncidentIdField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['incidentId'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _incidentIdController.text != currentData.inspectionIncidentId) {
      _incidentIdController.text = currentData.inspectionIncidentId;
    }
    
    return CustomTextField(
      controller: _incidentIdController,
      label: 'Id Incidente *',
      hintText: 'Ingrese el ID del incidente',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => error,
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(InspectionFormIncidentIdChanged(value));
      },
    );
  }

  Widget _buildStatusField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['status'];
    
    print('=== REBUILDING STATUS FIELD ===');
    print('Estado actual: ${currentData?.inspectionStatus}');
    print('Error: $error');
    print('================================');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomExpandableDropdown<String>(
          key: ValueKey('status_${currentData?.inspectionStatus}_${error ?? 'no_error'}'), // Key único para forzar rebuild
          label: 'Estado *',
          value: currentData?.inspectionStatus,
          items: _statusOptions,
          itemBuilder: (item) => item,
          onChanged: (value) {
            print('=== CAMBIO DE ESTADO ===');
            print('Nuevo estado seleccionado: $value');
            print('======================');
            context.read<DataRegistrationBloc>().add(InspectionFormStatusChanged(value));
          },
          hintText: 'Seleccione un estado',
        ),
        // Mostrar error por separado
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['date'];
    
    return CustomDatePicker(
      label: 'Fecha *',
      selectedDate: currentData?.inspectionDate,
      onDateSelected: (date) {
        context.read<DataRegistrationBloc>().add(InspectionFormDateChanged(date));
      },
      validator: (date) => error,
    );
  }

  Widget _buildTimeField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['time'];
    
    return CustomTimePicker(
      label: 'Hora *',
      selectedTime: currentData?.inspectionTime.isNotEmpty == true 
          ? TimeOfDay.fromDateTime(DateTime.parse('2023-01-01 ${currentData!.inspectionTime}:00'))
          : null,
      onTimeSelected: (time) {
        if (time != null) {
          final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          context.read<DataRegistrationBloc>().add(InspectionFormTimeChanged(timeString));
        }
      },
      validator: (time) => error,
    );
  }

  Widget _buildCommentField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['comment'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _commentController.text != currentData.inspectionComment) {
      _commentController.text = currentData.inspectionComment;
    }
    
    return CustomTextField(
      controller: _commentController,
      label: 'Comentario',
      hintText: 'Ingrese un comentario adicional de la inspección realizada...',
      maxLines: 4,
      validator: (value) => error,
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(InspectionFormCommentChanged(value));
      },
    );
  }

  Widget _buildInjuredField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['injured'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _injuredController.text != currentData.inspectionInjured.toString()) {
      _injuredController.text = currentData.inspectionInjured.toString();
    }
    
    return CustomTextField(
      controller: _injuredController,
      label: 'Número de lesionados',
      hintText: 'Ingrese número de lesionados',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => error,
      onChanged: (value) {
        final injured = int.tryParse(value) ?? 0;
        context.read<DataRegistrationBloc>().add(InspectionFormInjuredChanged(injured));
      },
    );
  }

  Widget _buildDeadField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.inspectionErrors['dead'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _deadController.text != currentData.inspectionDead.toString()) {
      _deadController.text = currentData.inspectionDead.toString();
    }
    
    return CustomTextField(
      controller: _deadController,
      label: 'Número de muertos',
      hintText: 'Ingrese número de muertos',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => error,
      onChanged: (value) {
        final dead = int.tryParse(value) ?? 0;
        context.read<DataRegistrationBloc>().add(InspectionFormDeadChanged(dead));
      },
    );
  }

  // === MÉTODOS AUXILIARES OPTIMIZADOS ===

  /// Verifica si el formulario puede ser enviado
  bool _canSubmit(DataRegistrationState state) {
    return state is! DataRegistrationLoading;
  }

  /// Maneja el envío del formulario de manera optimizada
  void _handleSubmit() {
    final formState = widget.formKey.currentState;
    
    // Siempre guardar el formulario primero
    formState?.save();
    
    // Disparar evento de envío en el bloc (lógica separada)
    context.read<DataRegistrationBloc>().add(const InspectionFormSubmit());
  }
}