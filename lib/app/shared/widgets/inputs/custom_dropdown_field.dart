import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T) itemBuilder;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemBuilder(item),
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
}
