import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:caja_herramientas/app/shared/widgets/inputs/custom_text_field.dart';
import 'package:caja_herramientas/app/shared/widgets/text/section_title.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_bloc.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/events/data_registration_events.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_state.dart';

class ContactFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ContactFormWidget({
    super.key,
    required this.formKey,
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
    return BlocListener<DataRegistrationBloc, DataRegistrationState>(
      listener: (context, state) {
        if (state is DataRegistrationData && state.showInspectionForm) {
          // Mostrar mensaje de éxito cuando navega al formulario de inspección
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datos de contacto guardados correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is DataRegistrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<DataRegistrationBloc, DataRegistrationState>(
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
                  onPressed: state is DataRegistrationLoading ? null : () {
                    // Primero validar el formulario Flutter
                    if (widget.formKey.currentState!.validate()) {
                      widget.formKey.currentState!.save();
                      // Luego disparar la validación del BLoC
                      context.read<DataRegistrationBloc>().add(const ContactFormValidated());
                    }
                  },
                  backgroundColor: DAGRDColors.azulDAGRD,
                  textColor: DAGRDColors.blancoDAGRD,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  borderRadius: 4,
                  isLoading: state is DataRegistrationLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNamesField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['names'];
    
    // Actualizar el controlador si el estado cambió (solo si es diferente para evitar loops)
    if (currentData != null && _namesController.text != currentData.contactNames) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_namesController.text != currentData.contactNames) {
          _namesController.text = currentData.contactNames;
        }
      });
    }
    
    return CustomTextField(
      controller: _namesController,
      label: 'Nombres *',
      hintText: 'Ingrese sus nombres',
      validator: (value) => error,
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(ContactFormNamesChanged(value));
      },
      onSaved: (value) {
        if (value != null) {
          context.read<DataRegistrationBloc>().add(ContactFormNamesChanged(value));
        }
      },
    );
  }

  Widget _buildCellPhoneField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['cellPhone'];
    
    // Actualizar el controlador si el estado cambió (solo si es diferente para evitar loops)
    if (currentData != null && _cellPhoneController.text != currentData.contactCellPhone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_cellPhoneController.text != currentData.contactCellPhone) {
          _cellPhoneController.text = currentData.contactCellPhone;
        }
      });
    }
    
    // Generar helper text con contador de dígitos
    String? helperText;
    final currentLength = _cellPhoneController.text.length;
    if (currentLength > 0 && currentLength < 10) {
      final remaining = 10 - currentLength;
      helperText = 'Faltan $remaining dígitos';
    } else if (currentLength == 10) {
      helperText = 'Número completo';
    }
    
    return CustomTextField(
      controller: _cellPhoneController,
      label: 'Número de celular *',
      hintText: 'Ingrese su número de celular',
      keyboardType: TextInputType.phone,
      validator: (value) => error,
      helperText: helperText,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(ContactFormCellPhoneChanged(value));
      },
      onSaved: (value) {
        if (value != null) {
          context.read<DataRegistrationBloc>().add(ContactFormCellPhoneChanged(value));
        }
      },
    );
  }

  Widget _buildLandlineField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['landline'];
    
    // Actualizar el controlador si el estado cambió (solo si es diferente para evitar loops)
    if (currentData != null && _landlineController.text != currentData.contactLandline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_landlineController.text != currentData.contactLandline) {
          _landlineController.text = currentData.contactLandline;
        }
      });
    }
    
    return CustomTextField(
      controller: _landlineController,
      label: 'Número de teléfono fijo *',
      hintText: 'Ingrese su número fijo',
      keyboardType: TextInputType.phone,
      validator: (value) => error,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(ContactFormLandlineChanged(value));
      },
      onSaved: (value) {
        if (value != null) {
          context.read<DataRegistrationBloc>().add(ContactFormLandlineChanged(value));
        }
      },
    );
  }

  Widget _buildEmailField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['email'];
    
    // Actualizar el controlador si el estado cambió (solo si es diferente para evitar loops)
    if (currentData != null && _emailController.text != currentData.contactEmail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_emailController.text != currentData.contactEmail) {
          _emailController.text = currentData.contactEmail;
        }
      });
    }
    
    return CustomTextField(
      controller: _emailController,
      label: 'Correo electrónico *',
      hintText: 'Ingrese su correo electrónico',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => error,
      onChanged: (value) {
        context.read<DataRegistrationBloc>().add(ContactFormEmailChanged(value));
      },
      onSaved: (value) {
        if (value != null) {
          context.read<DataRegistrationBloc>().add(ContactFormEmailChanged(value));
        }
      },
    );
  }
}
