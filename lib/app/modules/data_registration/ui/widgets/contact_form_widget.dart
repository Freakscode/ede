import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
import 'package:caja_herramientas/app/shared/widgets/text/section_title.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/contact_form_bloc.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/events/contact_form_events.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/contact_form_state.dart';

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
    return BlocListener<ContactFormBloc, ContactFormState>(
      listener: (context, state) {
        if (state is ContactFormSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          widget.onNextPressed();
        } else if (state is ContactFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<ContactFormBloc, ContactFormState>(
        builder: (context, state) {
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
                _buildNamesField(context, state),

                const SizedBox(height: 16),

                // Campo Número de celular
                _buildCellPhoneField(context, state),

                const SizedBox(height: 16),

                // Campo Número de teléfono fijo
                _buildLandlineField(context, state),

                const SizedBox(height: 16),

                // Campo Correo electrónico
                _buildEmailField(context, state),

                const SizedBox(height: 24),

                // Botón Siguiente
                CustomElevatedButton(
                  text: 'Siguiente',
                  onPressed: state is ContactFormLoading ? null : () {
                    // Primero validar el formulario Flutter
                    if (widget.formKey.currentState!.validate()) {
                      widget.formKey.currentState!.save();
                      // Luego disparar la validación del BLoC
                      context.read<ContactFormBloc>().add(ContactFormValidated());
                    }
                  },
                  backgroundColor: DAGRDColors.azulDAGRD,
                  textColor: DAGRDColors.blancoDAGRD,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  borderRadius: 4,
                  isLoading: state is ContactFormLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNamesField(BuildContext context, ContactFormState state) {
    final currentData = state is ContactFormData ? state : null;
    final error = currentData?.errors['names'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _namesController.text != currentData.names) {
      _namesController.text = currentData.names;
    }
    
    return CustomTextField(
      controller: _namesController,
      label: 'Nombres *',
      hintText: 'Ingrese sus nombres',
      validator: (value) => error,
      onChanged: (value) {
        context.read<ContactFormBloc>().add(ContactFormNamesChanged(value));
      },
    );
  }

  Widget _buildCellPhoneField(BuildContext context, ContactFormState state) {
    final currentData = state is ContactFormData ? state : null;
    final error = currentData?.errors['cellPhone'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _cellPhoneController.text != currentData.cellPhone) {
      _cellPhoneController.text = currentData.cellPhone;
    }
    
    return CustomTextField(
      controller: _cellPhoneController,
      label: 'Número de celular *',
      hintText: 'Ingrese su número de celular',
      keyboardType: TextInputType.phone,
      validator: (value) => error,
      onChanged: (value) {
        context.read<ContactFormBloc>().add(ContactFormCellPhoneChanged(value));
      },
    );
  }

  Widget _buildLandlineField(BuildContext context, ContactFormState state) {
    final currentData = state is ContactFormData ? state : null;
    final error = currentData?.errors['landline'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _landlineController.text != currentData.landline) {
      _landlineController.text = currentData.landline;
    }
    
    return CustomTextField(
      controller: _landlineController,
      label: 'Número de teléfono fijo *',
      hintText: 'Ingrese su número fijo',
      keyboardType: TextInputType.phone,
      validator: (value) => error,
      onChanged: (value) {
        context.read<ContactFormBloc>().add(ContactFormLandlineChanged(value));
      },
    );
  }

  Widget _buildEmailField(BuildContext context, ContactFormState state) {
    final currentData = state is ContactFormData ? state : null;
    final error = currentData?.errors['email'];
    
    // Actualizar el controlador si el estado cambió
    if (currentData != null && _emailController.text != currentData.email) {
      _emailController.text = currentData.email;
    }
    
    return CustomTextField(
      controller: _emailController,
      label: 'Correo electrónico *',
      hintText: 'Ingrese su correo electrónico',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => error,
      onChanged: (value) {
        context.read<ContactFormBloc>().add(ContactFormEmailChanged(value));
      },
    );
  }
}
