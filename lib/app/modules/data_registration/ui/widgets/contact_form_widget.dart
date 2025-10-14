import 'package:flutter/material.dart';

class ContactFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onNextPressed;

  const ContactFormWidget({
    super.key,
    required this.formKey,
    required this.onNextPressed,
  });

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final _namesController = TextEditingController();
  final _cellPhoneController = TextEditingController();
  final _landlineController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _namesController.dispose();
    _cellPhoneController.dispose();
    _landlineController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Center(
            child: Text(
              'Registro de datos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF232B48), // var(--AzulDAGRD, #232B48)
                fontFamily: 'Work Sans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.16667, // 28px / 24px = 1.16667 (116.667%)
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Subtítulo
          Center(
            child: const Text(
              'Contacto que reporta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Campo Nombres
          _buildTextField(
            controller: _namesController,
            label: 'Nombres *',
            hintText: 'Ingrese sus nombres',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingrese sus nombres';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Número de celular
          _buildTextField(
            controller: _cellPhoneController,
            label: 'Número de celular *',
            hintText: 'Ingrese su número de celular',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingrese su número de celular';
              }
              if (value.length < 10) {
                return 'El número de celular debe tener al menos 10 dígitos';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Número de teléfono fijo
          _buildTextField(
            controller: _landlineController,
            label: 'Número de teléfono fijo *',
            hintText: 'Ingrese su número fijo',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingrese su número fijo';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo Correo electrónico
          _buildTextField(
            controller: _emailController,
            label: 'Correo electrónico *',
            hintText: 'Ingrese su correo electrónico',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Por favor ingrese un correo electrónico válido';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Botón Siguiente
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.onNextPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF232B48),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Siguiente',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 24 / 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF232B48), // var(--AzulDAGRD, #232B48)
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
          validator: validator,
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
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF232B48), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
