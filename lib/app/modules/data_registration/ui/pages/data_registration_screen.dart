import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import '../widgets/contact_form_widget.dart';
import '../widgets/inspection_form_widget.dart';

class DataRegistrationScreen extends StatefulWidget {
  const DataRegistrationScreen({super.key});

  @override
  State<DataRegistrationScreen> createState() => _DataRegistrationScreenState();
}

class _DataRegistrationScreenState extends State<DataRegistrationScreen> {
  final _contactFormKey = GlobalKey<FormState>();
  final _inspectionFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        showBack: true,
        showInfo: true,
        showProfile: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Form
            ContactFormWidget(
              formKey: _contactFormKey,
              onNextPressed: _handleNextPressed,
            ),
            
            const SizedBox(height: 20),
            
            // Inspection Form
            InspectionFormWidget(
              formKey: _inspectionFormKey,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextPressed() {
    // Validar formulario de contacto
    if (_contactFormKey.currentState!.validate()) {
      _contactFormKey.currentState!.save();
      
      // Mostrar snackbar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos de contacto guardados correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Aquí puedes agregar lógica adicional después de guardar el contacto
      // Por ejemplo, habilitar el formulario de inspección o navegar a otra pantalla
    }
  }
}
