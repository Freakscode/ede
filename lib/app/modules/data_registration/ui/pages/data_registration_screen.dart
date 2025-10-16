import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import '../widgets/contact_form_widget.dart';
import '../widgets/inspection_form_widget.dart';
import '../../bloc/data_registration_bloc.dart';
import '../../bloc/events/data_registration_events.dart';
import '../../bloc/data_registration_state.dart';

class DataRegistrationScreen extends StatefulWidget {
  const DataRegistrationScreen({super.key});

  @override
  State<DataRegistrationScreen> createState() => _DataRegistrationScreenState();
}

class _DataRegistrationScreenState extends State<DataRegistrationScreen> {
  late final GlobalKey<FormState> _contactFormKey;
  late final GlobalKey<FormState> _inspectionFormKey;

  @override
  void initState() {
    super.initState();
    _contactFormKey = GlobalKey<FormState>();
    _inspectionFormKey = GlobalKey<FormState>();
    
    // Resetear el formulario una sola vez al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataRegistrationBloc>().add(const ResetAllForms());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataRegistrationBloc, DataRegistrationState>(
      builder: (context, state) {
        final showInspectionForm = state is DataRegistrationData ? state.showInspectionForm : false;

        return Scaffold(
          appBar: CustomAppBar(
            showBack: true,
            showInfo: true,
            showProfile: true,
            onBack: showInspectionForm ? _handleBackPressed : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 31),
            child: showInspectionForm
                ? InspectionFormWidget(formKey: _inspectionFormKey)
                : ContactFormWidget(formKey: _contactFormKey),
          ),
        );
      },
    );
  }

  void _handleBackPressed() {
    context.read<DataRegistrationBloc>().add(const NavigateToContactForm());
  }
}