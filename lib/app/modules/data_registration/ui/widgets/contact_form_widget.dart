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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Registro de datos',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Work Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtítulo
            const Text(
              'Contacto que reporta',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
            color: Colors.black,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF232B48), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }
}
