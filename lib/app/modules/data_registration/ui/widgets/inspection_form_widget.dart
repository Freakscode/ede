import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_dropdown_field.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_date_picker.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_time_picker.dart';
import 'package:caja_herramientas/app/shared/widgets/text/section_title.dart';

class InspectionFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const InspectionFormWidget({super.key, required this.formKey});

  @override
  State<InspectionFormWidget> createState() => _InspectionFormWidgetState();
}

class _InspectionFormWidgetState extends State<InspectionFormWidget> {
  final _statusController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _commentController = TextEditingController();
  final _injuredController = TextEditingController();
  final _deadController = TextEditingController();

  String? _selectedStatus;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _statusOptions = [
    'En proceso',
    'Completada',
    'Cancelada',
    'Pendiente',
  ];

  @override
  void dispose() {
    _statusController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _commentController.dispose();
    _injuredController.dispose();
    _deadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          // Campo Estado
          CustomDropdownField<String>(
            label: 'Estado *',
            value: _selectedStatus,
            items: _statusOptions,
            itemBuilder: (item) => item,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor seleccione un estado';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Fecha
          CustomDatePicker(
            label: 'Fecha *',
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            validator: (date) {
              if (date == null) {
                return 'Por favor seleccione una fecha';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Hora
          CustomTimePicker(
            label: 'Hora *',
            selectedTime: _selectedTime,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
            validator: (time) {
              if (time == null) {
                return 'Por favor seleccione una hora';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Comentario
          CustomTextField(
            controller: _commentController,
            label: 'Comentario *',
            hintText: 'Ingrese un comentario adicional de la inspección realizada...',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingrese un comentario';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Número de lesionados
          CustomTextField(
            controller: _injuredController,
            label: 'Número de lesionados',
            hintText: 'Ingrese número de lesionados',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final number = int.tryParse(value);
                if (number == null || number < 0) {
                  return 'Por favor ingrese un número válido';
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Número de muertos
          CustomTextField(
            controller: _deadController,
            label: 'Número de muertos',
            hintText: 'Ingrese número de muertos',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final number = int.tryParse(value);
                if (number == null || number < 0) {
                  return 'Por favor ingrese un número válido';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

}
