import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import '../widgets/contact_form_widget.dart';
import '../widgets/inspection_form_widget.dart';
import '../../bloc/data_registration_bloc.dart';
import '../../bloc/events/data_registration_events.dart';
import '../../bloc/data_registration_state.dart';

class DataRegistrationScreen extends StatelessWidget {
  const DataRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataRegistrationBloc, DataRegistrationState>(
      builder: (context, state) {
        print('=== DataRegistrationScreen rebuild ===');
        print('Estado: ${state.runtimeType}');
        
        // Obtener las form keys del estado del BLoC
        final contactFormKey = state is DataRegistrationData ? state.contactFormKey : null;
        final inspectionFormKey = state is DataRegistrationData ? state.inspectionFormKey : null;
        final showInspectionForm = state is DataRegistrationData ? state.showInspectionForm : false;
        
        print('showInspectionForm: $showInspectionForm');
        print('contactFormKey: $contactFormKey');
        print('inspectionFormKey: $inspectionFormKey');

        // Crear las form keys si no existen
        final effectiveContactFormKey = contactFormKey ?? GlobalKey<FormState>();
        final effectiveInspectionFormKey = inspectionFormKey ?? GlobalKey<FormState>();

        // Establecer las form keys en el BLoC si no están establecidas
        if (contactFormKey == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DataRegistrationBloc>().add(SetContactFormKey(effectiveContactFormKey));
          });
        }
        if (inspectionFormKey == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DataRegistrationBloc>().add(SetInspectionFormKey(effectiveInspectionFormKey));
          });
        }

        return Scaffold(
          appBar: CustomAppBar(
            showBack: true,
            showInfo: true,
            showProfile: true,
            onBack: showInspectionForm ? () => _handleBackPressed(context) : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 31),
            child: showInspectionForm
                ? InspectionFormWidget(
                    formKey: effectiveInspectionFormKey,
                  )
                : ContactFormWidget(
                    formKey: effectiveContactFormKey,
                  ),
          ),
        );
      },
    );
  }

  void _handleBackPressed(BuildContext context) {
    // Volver al formulario de contacto
    context.read<DataRegistrationBloc>().add(const NavigateToContactForm());
  }
}