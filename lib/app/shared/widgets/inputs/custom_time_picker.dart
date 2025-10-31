import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay?) onTimeSelected;
  final String? Function(TimeOfDay?)? validator;
  final TimeOfDay? initialTime;

  const CustomTimePicker({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
    this.validator,
    this.initialTime,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = validator?.call(selectedTime);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ThemeColors.azulDAGRD,
            fontFamily: 'Work Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33333, // 16px / 12px = 1.33333 (133.333%)
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.blancoDAGRD,
              border: Border.all(
                color: errorMessage != null 
                    ? const Color(0xFFE53E3E) // Rojo para error
                    : ThemeColors.grisMedio, 
                width: 1
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: errorMessage != null 
                      ? const Color(0xFFE53E3E) // Rojo para error
                      : ThemeColors.grisMedio,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                        : 'hh:mm',
                    style: TextStyle(
                      color: selectedTime != null
                          ? Colors.black
                          : const Color(0xFFCCCCCC),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: selectedTime != null ? FontWeight.w400 : FontWeight.w500,
                      height: 1.42857, // 20px / 14px = 1.42857 (142.857%)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Mostrar mensaje de error si existe
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorMessage,
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      onTimeSelected(picked);
    }
  }
}
