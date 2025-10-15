import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
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
          _buildDropdownField(
            label: 'Estado *',
            value: _selectedStatus,
            items: _statusOptions,
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
          _buildDateField(),

          const SizedBox(height: 16),

          // Campo Hora
          _buildTimeField(),

          const SizedBox(height: 16),

          // Campo Comentario
          _buildCommentField(),

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

  Widget _buildCommentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comentario *',
          style: TextStyle(
            color: DAGRDColors.azulDAGRD,
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33333, // 16px / 12px = 1.33333 (133.333%)
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingrese un comentario';
            }
            return null;
          },
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Ingrese un comentario adicional de la inspección realizada...',
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC), // var(--Texto-inputs, #CCC)
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42857, // 20px / 14px = 1.42857 (142.857%)
            ),
            filled: true,
            fillColor: DAGRDColors.blancoDAGRD,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.grisMedio, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.grisMedio, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.azulDAGRD, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: DAGRDColors.azulDAGRD,
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33333, // 16px / 12px = 1.33333 (133.333%)
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Seleccione una opción',
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC), // var(--Texto-inputs, #CCC)
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42857, // 20px / 14px = 1.42857 (142.857%)
            ),
            filled: true,
            fillColor: DAGRDColors.blancoDAGRD,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.grisMedio, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.grisMedio, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.azulDAGRD, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: DAGRDColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: DAGRDColors.grisMedio,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha *',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF9E9E9E),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                        : 'dd/mm/aaaa',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? Colors.black
                          : const Color(0xFF9E9E9E),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hora *',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF9E9E9E),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                        : 'hh:mm',
                    style: TextStyle(
                      color: _selectedTime != null
                          ? Colors.black
                          : const Color(0xFF9E9E9E),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
