import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
import 'package:caja_herramientas/app/shared/widgets/text/section_title.dart';

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
           // Título y subtítulo
           const SectionTitle(
             title: 'Registro de datos',
             subtitle: 'Contacto que reporta',
           ),

           const SizedBox(height: 20),

           // Campo Nombres
           CustomTextField(
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
           CustomTextField(
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
           CustomTextField(
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
           CustomTextField(
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
           CustomElevatedButton(
             text: 'Siguiente',
             onPressed: widget.onNextPressed,
             backgroundColor: DAGRDColors.azulDAGRD,
             textColor: DAGRDColors.blancoDAGRD,
             fontSize: 14,
             fontWeight: FontWeight.w500,
             borderRadius: 4,
           ),
        ],
      ),
    );
  }

}
