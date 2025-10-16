import 'package:flutter_bloc/flutter_bloc.dart';
import 'events/contact_form_events.dart';
import 'contact_form_state.dart';
import '../models/contact_data.dart';

/// BLoC para manejar el formulario de contacto
class ContactFormBloc extends Bloc<ContactFormEvent, ContactFormState> {
  ContactFormBloc() : super(const ContactFormData(
    names: '',
    cellPhone: '',
    landline: '',
    email: '',
    isValid: false,
  )) {
    on<ContactFormNamesChanged>(_onNamesChanged);
    on<ContactFormCellPhoneChanged>(_onCellPhoneChanged);
    on<ContactFormLandlineChanged>(_onLandlineChanged);
    on<ContactFormEmailChanged>(_onEmailChanged);
    on<ContactFormValidated>(_onFormValidated);
    on<ContactFormReset>(_onFormReset);
    on<ContactFormSaveRequested>(_onFormSaved);
  }

  void _onNamesChanged(
    ContactFormNamesChanged event,
    Emitter<ContactFormState> emit,
  ) {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      final newState = currentState.copyWith(
        names: event.names,
        errors: _clearError('names', currentState.errors),
      );
      emit(newState);
    }
  }

  void _onCellPhoneChanged(
    ContactFormCellPhoneChanged event,
    Emitter<ContactFormState> emit,
  ) {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      final newState = currentState.copyWith(
        cellPhone: event.cellPhone,
        errors: _clearError('cellPhone', currentState.errors),
      );
      emit(newState);
    }
  }

  void _onLandlineChanged(
    ContactFormLandlineChanged event,
    Emitter<ContactFormState> emit,
  ) {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      final newState = currentState.copyWith(
        landline: event.landline,
        errors: _clearError('landline', currentState.errors),
      );
      emit(newState);
    }
  }

  void _onEmailChanged(
    ContactFormEmailChanged event,
    Emitter<ContactFormState> emit,
  ) {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      final newState = currentState.copyWith(
        email: event.email,
        errors: _clearError('email', currentState.errors),
      );
      emit(newState);
    }
  }

  void _onFormValidated(
    ContactFormValidated event,
    Emitter<ContactFormState> emit,
  ) {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      final errors = _validateForm(currentState);
      final isValid = errors.isEmpty;
      
      final newState = currentState.copyWith(
        errors: errors,
        isValid: isValid,
      );
      emit(newState);
      
      // Si el formulario es válido, guardar automáticamente
      if (isValid) {
        add(ContactFormSaveRequested());
      }
    }
  }

  void _onFormReset(
    ContactFormReset event,
    Emitter<ContactFormState> emit,
  ) {
    emit(const ContactFormData(
      names: '',
      cellPhone: '',
      landline: '',
      email: '',
      isValid: false,
    ));
  }

  void _onFormSaved(
    ContactFormSaveRequested event,
    Emitter<ContactFormState> emit,
  ) async {
    emit(const ContactFormLoading());
    
    try {
      if (state is ContactFormData) {
        final currentState = state as ContactFormData;
        
        // Simular guardado
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Crear el objeto de datos
        final contactData = ContactData(
          names: currentState.names,
          cellPhone: currentState.cellPhone,
          landline: currentState.landline,
          email: currentState.email,
        );
        
        // Aquí podrías guardar en base de datos, API, etc.
        print('Contacto guardado: ${contactData.toJson()}');
        
        emit(const ContactFormSaved('Datos de contacto guardados correctamente'));
      }
    } catch (e) {
      emit(ContactFormError('Error al guardar los datos: $e'));
    }
  }

  /// Validar el formulario completo
  Map<String, String> _validateForm(ContactFormData data) {
    final errors = <String, String>{};

    // Validar nombres
    if (data.names.trim().isEmpty) {
      errors['names'] = 'Por favor ingrese sus nombres';
    }

    // Validar celular
    if (data.cellPhone.trim().isEmpty) {
      errors['cellPhone'] = 'Por favor ingrese su número de celular';
    } else if (data.cellPhone.length < 10) {
      errors['cellPhone'] = 'El número de celular debe tener al menos 10 dígitos';
    }

    // Validar teléfono fijo
    if (data.landline.trim().isEmpty) {
      errors['landline'] = 'Por favor ingrese su número fijo';
    }

    // Validar email
    if (data.email.trim().isEmpty) {
      errors['email'] = 'Por favor ingrese su correo electrónico';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(data.email)) {
      errors['email'] = 'Por favor ingrese un correo electrónico válido';
    }

    return errors;
  }

  /// Limpiar error específico
  Map<String, String> _clearError(String field, Map<String, String> errors) {
    final newErrors = Map<String, String>.from(errors);
    newErrors.remove(field);
    return newErrors;
  }

  /// Obtener los datos actuales del formulario
  ContactData? getCurrentData() {
    if (state is ContactFormData) {
      final currentState = state as ContactFormData;
      return ContactData(
        names: currentState.names,
        cellPhone: currentState.cellPhone,
        landline: currentState.landline,
        email: currentState.email,
      );
    }
    return null;
  }
}
