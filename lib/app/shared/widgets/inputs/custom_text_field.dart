import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onSaved,
    this.maxLines = 1,
    this.inputFormatters,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = validator?.call(controller.text);
    
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => null, // No usar validator de Flutter
          obscureText: obscureText,
          onChanged: onChanged,
          onSaved: onSaved,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC), // var(--Texto-inputs, #CCC)
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42857, // 20px / 14px = 1.42857 (142.857%)
            ),
            filled: true,
            fillColor: ThemeColors.blancoDAGRD,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorMessage != null 
                    ? const Color(0xFFE53E3E) // Rojo para error
                    : ThemeColors.grisMedio, 
                width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorMessage != null 
                    ? const Color(0xFFE53E3E) // Rojo para error
                    : ThemeColors.grisMedio, 
                width: 1
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorMessage != null 
                    ? const Color(0xFFE53E3E) // Rojo para error
                    : ThemeColors.azulDAGRD, 
                width: 2
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
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
        
        // Helper text (contador de dígitos)
        if (helperText != null && errorMessage == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              helperText!,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
