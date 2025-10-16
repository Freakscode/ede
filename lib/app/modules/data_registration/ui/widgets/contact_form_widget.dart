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
  void initState() {
    super.initState();
    // Inicializar controladores con valores del estado inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<DataRegistrationBloc>();
      final state = bloc.state;
      if (state is DataRegistrationData) {
        _namesController.text = state.contactNames;
        _cellPhoneController.text = state.contactCellPhone;
        _landlineController.text = state.contactLandline;
        _emailController.text = state.contactEmail;
        print('=== CONTROLADORES INICIALIZADOS ===');
        print('Nombres: "${state.contactNames}"');
        print('Celular: "${state.contactCellPhone}"');
        print('Fijo: "${state.contactLandline}"');
        print('Email: "${state.contactEmail}"');
        print('==================================');
      }
    });
  }

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
        print('=== BLOCLISTENER EJECUTADO ===');
        print('Nuevo estado: ${state.runtimeType}');
        print('==============================');
        
        // Actualizar controladores cuando el estado cambie
        if (state is DataRegistrationData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bool updated = false;
            if (_namesController.text != state.contactNames) {
              _namesController.text = state.contactNames;
              updated = true;
            }
            if (_cellPhoneController.text != state.contactCellPhone) {
              _cellPhoneController.text = state.contactCellPhone;
              updated = true;
            }
            if (_landlineController.text != state.contactLandline) {
              _landlineController.text = state.contactLandline;
              updated = true;
            }
            if (_emailController.text != state.contactEmail) {
              _emailController.text = state.contactEmail;
              updated = true;
            }
            if (updated) {
              print('=== CONTROLADORES ACTUALIZADOS ===');
              print('Nombres: "${state.contactNames}"');
              print('Celular: "${state.contactCellPhone}"');
              print('Fijo: "${state.contactLandline}"');
              print('Email: "${state.contactEmail}"');
              print('==================================');
            }
          });
        }
        
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
        
        // Forzar actualización de la UI cuando hay errores
        if (state is DataRegistrationData && state.contactErrors.isNotEmpty) {
          print('=== FORZANDO ACTUALIZACIÓN DE UI ===');
          print('Errores en estado: ${state.contactErrors}');
          print('====================================');
          
          // Forzar reconstrucción del widget
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {});
            }
          });
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
                    print('=== BOTÓN SIGUIENTE PRESIONADO ===');
                    print('Estado actual: ${state.runtimeType}');
                    print('Formulario válido: ${widget.formKey.currentState?.validate()}');
                    print('==================================');
                    
                    // Siempre guardar el formulario primero
                    widget.formKey.currentState!.save();
                    
                    // Imprimir los datos de contacto antes de enviar
                    final bloc = context.read<DataRegistrationBloc>();
                    final currentState = bloc.state;
                    
                    if (currentState is DataRegistrationData) {
                      print('=== DATOS DEL FORMULARIO DE CONTACTO ===');
                      print('Nombres: ${currentState.contactNames}');
                      print('Número de celular: ${currentState.contactCellPhone}');
                      print('Número de teléfono fijo: ${currentState.contactLandline}');
                      print('Correo electrónico: ${currentState.contactEmail}');
                      print('Contacto válido: ${currentState.isContactValid}');
                      print('Errores: ${currentState.contactErrors}');
                      print('========================================');
                    }
                    
                    // Siempre disparar la validación del BLoC
                    print('=== ENVIANDO ContactFormValidated ===');
                    bloc.add(const ContactFormValidated());
                    print('=== EVENTO ENVIADO ===');
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _namesController,
          label: 'Nombres *',
          hintText: 'Ingrese sus nombres',
          validator: (value) => null, // No usar validator de Flutter
          onChanged: (value) {
            context.read<DataRegistrationBloc>().add(ContactFormNamesChanged(value));
          },
          onSaved: (value) {
            if (value != null) {
              context.read<DataRegistrationBloc>().add(ContactFormNamesChanged(value));
            }
          },
        ),
        // Mostrar error del bloc
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCellPhoneField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['cellPhone'];
    
    // Generar helper text con contador de dígitos
    String? helperText;
    final currentLength = _cellPhoneController.text.length;
    if (currentLength > 0 && currentLength < 10) {
      final remaining = 10 - currentLength;
      helperText = 'Faltan $remaining dígitos';
    } else if (currentLength == 10) {
      helperText = 'Número completo';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _cellPhoneController,
          label: 'Número de celular *',
          hintText: 'Ingrese su número de celular',
          keyboardType: TextInputType.phone,
          validator: (value) => null, // No usar validator de Flutter
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
        ),
        // Mostrar error del bloc
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLandlineField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['landline'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _landlineController,
          label: 'Número de teléfono fijo *',
          hintText: 'Ingrese su número fijo',
          keyboardType: TextInputType.phone,
          validator: (value) => null, // No usar validator de Flutter
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
        ),
        // Mostrar error del bloc
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, DataRegistrationState state) {
    final currentData = state is DataRegistrationData ? state : null;
    final error = currentData?.contactErrors['email'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _emailController,
          label: 'Correo electrónico *',
          hintText: 'Ingrese su correo electrónico',
          keyboardType: TextInputType.emailAddress,
          validator: (value) => null, // No usar validator de Flutter
          onChanged: (value) {
            context.read<DataRegistrationBloc>().add(ContactFormEmailChanged(value));
          },
          onSaved: (value) {
            if (value != null) {
              context.read<DataRegistrationBloc>().add(ContactFormEmailChanged(value));
            }
          },
        ),
        // Mostrar error del bloc
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontFamily: 'Work Sans',
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
