import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = validator?.call(selectedDate);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF706F6F), // GrisDAGRD
            fontFamily: 'Work Sans',
            fontSize: 13.549,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            height: 18.066 / 13.549, // 133.333%
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.only(top: 6, right: 10, bottom: 6, left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: errorMessage != null 
                    ? const Color(0xFFE53E3E) // Rojo para error
                    : const Color(0xFFD1D5DB), // Bordes #D1D5DB
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.calendar_today,
                    color: errorMessage != null 
                        ? const Color(0xFFE53E3E) // Rojo para error
                        : const Color(0xFFEFEFEF), // #EFEFEF
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                        : 'dd/mm/aaaa',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.black
                          : const Color(0xFFCCCCCC), // #CCC
                      fontFamily: 'Work Sans',
                      fontSize: selectedDate != null ? 14 : 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      height: selectedDate != null ? null : 1.0, // normal for placeholder
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }
}
