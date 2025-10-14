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
  bool _showInspectionForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        showInfo: true,
        showProfile: true,
        onBack: _showInspectionForm ? _handleBackPressed : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 31),
        child: _showInspectionForm
            ? InspectionFormWidget(
                formKey: _inspectionFormKey,
              )
            : ContactFormWidget(
                formKey: _contactFormKey,
                onNextPressed: _handleNextPressed,
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
      
      // Mostrar el formulario de inspección
      setState(() {
        _showInspectionForm = true;
      });
    }
  }

  void _handleBackPressed() {
    // Volver al formulario de contacto
    setState(() {
      _showInspectionForm = false;
    });
  }
}
