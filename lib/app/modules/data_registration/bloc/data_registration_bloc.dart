import 'package:flutter_bloc/flutter_bloc.dart';
import 'events/data_registration_events.dart';
import 'data_registration_state.dart';
import '../models/contact_data.dart';
import '../models/inspection_data.dart';
import '../services/inspection_storage_service.dart';

/// BLoC unificado para manejar todo el proceso de registro de datos
class DataRegistrationBloc
    extends Bloc<DataRegistrationEvent, DataRegistrationState> {
  DataRegistrationBloc()
    : super(
        const DataRegistrationData(
          // Datos de contacto iniciales
          contactNames: '',
          contactCellPhone: '',
          contactLandline: '',
          contactEmail: '',
          contactErrors: {},
          isContactValid: false,
          // Datos de inspección iniciales
          inspectionIncidentId: '',
          inspectionStatus: null,
          inspectionDate: null,
          inspectionTime: '',
          inspectionComment: '',
          inspectionInjured: 0,
          inspectionDead: 0,
          inspectionErrors: {},
          isInspectionValid: false,
          // Navegación
          showInspectionForm: false,
          // Form keys
          contactFormKey: null,
          inspectionFormKey: null,
        ),
      ) {
    // Eventos de formulario de contacto
    on<ContactFormNamesChanged>(_onContactNamesChanged);
    on<ContactFormCellPhoneChanged>(_onContactCellPhoneChanged);
    on<ContactFormLandlineChanged>(_onContactLandlineChanged);
    on<ContactFormEmailChanged>(_onContactEmailChanged);
    on<ContactFormValidated>(_onContactFormValidated);

    // Eventos de formulario de inspección
    on<InspectionFormIncidentIdChanged>(_onInspectionIncidentIdChanged);
    on<InspectionFormStatusChanged>(_onInspectionStatusChanged);
    on<InspectionFormDateChanged>(_onInspectionDateChanged);
    on<InspectionFormTimeChanged>(_onInspectionTimeChanged);
    on<InspectionFormCommentChanged>(_onInspectionCommentChanged);
    on<InspectionFormInjuredChanged>(_onInspectionInjuredChanged);
    on<InspectionFormDeadChanged>(_onInspectionDeadChanged);
    on<InspectionFormValidated>(_onInspectionFormValidated);

    // Eventos de navegación
    on<NavigateToInspectionForm>(_onNavigateToInspectionForm);
    on<NavigateToContactForm>(_onNavigateToContactForm);
    on<ResetAllForms>(_onResetAllForms);
    on<SaveCompleteRegistration>(_onSaveCompleteRegistration);

    // Eventos para form keys
    on<SetContactFormKey>(_onSetContactFormKey);
    on<SetInspectionFormKey>(_onSetInspectionFormKey);
  }

  // === MANEJADORES DE FORMULARIO DE CONTACTO ===

  void _onContactNamesChanged(
    ContactFormNamesChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    print('=== _onContactNamesChanged ===');
    print('Nuevo nombre: "${event.names}"');
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        contactNames: event.names,
        contactErrors: _clearContactError('names', currentState.contactErrors),
      );
      emit(newState);
      print('Nombre actualizado en estado');
    } else {
      print('Estado no es DataRegistrationData: ${state.runtimeType}');
    }
  }

  void _onContactCellPhoneChanged(
    ContactFormCellPhoneChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        contactCellPhone: event.cellPhone,
        contactErrors: _clearContactError(
          'cellPhone',
          currentState.contactErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onContactLandlineChanged(
    ContactFormLandlineChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        contactLandline: event.landline,
        contactErrors: _clearContactError(
          'landline',
          currentState.contactErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onContactEmailChanged(
    ContactFormEmailChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        contactEmail: event.email,
        contactErrors: _clearContactError('email', currentState.contactErrors),
      );
      emit(newState);
    }
  }

  void _onContactFormValidated(
    ContactFormValidated event,
    Emitter<DataRegistrationState> emit,
  ) {
    print('=== _onContactFormValidated ===');
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;

      print('Datos actuales:');
      print('- Nombres: "${currentState.contactNames}"');
      print('- Celular: "${currentState.contactCellPhone}"');
      print('- Fijo: "${currentState.contactLandline}"');
      print('- Email: "${currentState.contactEmail}"');
      
      final errors = _validateContactForm(currentState);
      final isValid = errors.isEmpty;

      print('Errores encontrados: $errors');
      print('¿Formulario válido?: $isValid');

      final newState = currentState.copyWith(
        contactErrors: errors,
        isContactValid: isValid,
      );
      emit(newState);

      if (isValid) {
        print('Formulario válido, navegando...');
        emit(newState.copyWith(showInspectionForm: true));
      } else {
        print('Formulario inválido, no navegando');
      }
    } else {
      print('Estado no es DataRegistrationData: ${state.runtimeType}');
    }
  }

  // === MANEJADORES DE FORMULARIO DE INSPECCIÓN ===

  void _onInspectionIncidentIdChanged(
    InspectionFormIncidentIdChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionIncidentId: event.incidentId,
        inspectionErrors: _clearInspectionError(
          'incidentId',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionStatusChanged(
    InspectionFormStatusChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionStatus: event.status,
        inspectionErrors: _clearInspectionError(
          'status',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionDateChanged(
    InspectionFormDateChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionDate: event.date,
        inspectionErrors: _clearInspectionError(
          'date',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionTimeChanged(
    InspectionFormTimeChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionTime: event.time,
        inspectionErrors: _clearInspectionError(
          'time',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionCommentChanged(
    InspectionFormCommentChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionComment: event.comment,
        inspectionErrors: _clearInspectionError(
          'comment',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionInjuredChanged(
    InspectionFormInjuredChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionInjured: event.injured,
        inspectionErrors: _clearInspectionError(
          'injured',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionDeadChanged(
    InspectionFormDeadChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        inspectionDead: event.dead,
        inspectionErrors: _clearInspectionError(
          'dead',
          currentState.inspectionErrors,
        ),
      );
      emit(newState);
    }
  }

  void _onInspectionFormValidated(
    InspectionFormValidated event,
    Emitter<DataRegistrationState> emit,
  ) {
    print('=== _onInspectionFormValidated ===');
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      print('Validando formulario de inspección...');
      
      final errors = _validateInspectionForm(currentState);
      final isValid = errors.isEmpty;

      print('Errores encontrados: $errors');
      print('¿Formulario válido?: $isValid');

      final newState = currentState.copyWith(
        inspectionErrors: errors,
        isInspectionValid: isValid,
      );
      emit(newState);

      // Si el formulario es válido, guardar automáticamente
      if (isValid) {
        print('Formulario válido, iniciando guardado...');
        add(const SaveCompleteRegistration());
      } else {
        print('Formulario inválido, no guardando');
      }
    } else {
      print('Estado no es DataRegistrationData: ${state.runtimeType}');
    }
  }

  // === MANEJADORES DE NAVEGACIÓN ===

  void _onNavigateToInspectionForm(
    NavigateToInspectionForm event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      emit(currentState.copyWith(showInspectionForm: true));
    }
  }

  void _onNavigateToContactForm(
    NavigateToContactForm event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      emit(currentState.copyWith(showInspectionForm: false));
    }
  }

  void _onResetAllForms(
    ResetAllForms event,
    Emitter<DataRegistrationState> emit,
  ) {
    emit(
      const DataRegistrationData(
        contactNames: '',
        contactCellPhone: '',
        contactLandline: '',
        contactEmail: '',
        contactErrors: {},
        isContactValid: false,
        inspectionIncidentId: '',
        inspectionStatus: null,
        inspectionDate: null,
        inspectionTime: '',
        inspectionComment: '',
        inspectionInjured: 0,
        inspectionDead: 0,
        inspectionErrors: {},
        isInspectionValid: false,
        showInspectionForm: false,
      ),
    );
  }

  void _onSaveCompleteRegistration(
    SaveCompleteRegistration event,
    Emitter<DataRegistrationState> emit,
  ) async {
    print('=== _onSaveCompleteRegistration ===');
    emit(const DataRegistrationLoading());
    print('Estado cambiado a DataRegistrationLoading');

    try {
      if (state is DataRegistrationData) {
        final currentState = state as DataRegistrationData;
        print('Guardando datos de inspección...');

        // Simular guardado
        await Future.delayed(const Duration(milliseconds: 500));

        // Crear los objetos de datos
        final contactData = ContactData(
          names: currentState.contactNames,
          cellPhone: currentState.contactCellPhone,
          landline: currentState.contactLandline,
          email: currentState.contactEmail,
        );

        final inspectionData = InspectionData(
          incidentId: currentState.inspectionIncidentId,
          status: currentState.inspectionStatus ?? '',
          date: currentState.inspectionDate ?? DateTime.now(),
          time: currentState.inspectionTime,
          comment: currentState.inspectionComment,
          injured: currentState.inspectionInjured,
          dead: currentState.inspectionDead,
        );

        // Guardar en memoria usando el servicio
        final storageService = InspectionStorageService();
        await storageService.saveInspection(inspectionData);

        // Aquí podrías guardar también los datos de contacto si tienes un servicio para eso
        print('Contacto guardado: ${contactData.toJson()}');
        print('Inspección guardada: ${inspectionData.toJson()}');

        print('Emitiendo CompleteRegistrationSaved...');
        emit(
          const CompleteRegistrationSaved(
            message: 'Registro completo guardado correctamente',
          ),
        );
        print('Estado cambiado a CompleteRegistrationSaved');
      } else {
        print('Estado no es DataRegistrationData: ${state.runtimeType}');
      }
    } catch (e) {
      print('Error al guardar: $e');
      emit(DataRegistrationError('Error al guardar los datos: $e'));
    }
  }

  // === MÉTODOS DE VALIDACIÓN ===

  Map<String, String> _validateContactForm(DataRegistrationData data) {
    final errors = <String, String>{};

    if (data.contactNames.trim().isEmpty) {
      errors['names'] = 'Por favor ingrese sus nombres';
    }

    if (data.contactCellPhone.trim().isEmpty) {
      errors['cellPhone'] = 'Por favor ingrese su número de celular';
    } else if (data.contactCellPhone.length < 10) {
      final remaining = 10 - data.contactCellPhone.length;
      errors['cellPhone'] = 'Faltan $remaining dígitos (${data.contactCellPhone.length}/10)';
    }

    if (data.contactLandline.trim().isEmpty) {
      errors['landline'] = 'Por favor ingrese su número fijo';
    }

    if (data.contactEmail.trim().isEmpty) {
      errors['email'] = 'Por favor ingrese su correo electrónico';
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(data.contactEmail)) {
      errors['email'] = 'Por favor ingrese un correo electrónico válido';
    }

    return errors;
  }

  Map<String, String> _validateInspectionForm(DataRegistrationData data) {
    final errors = <String, String>{};

    if (data.inspectionIncidentId.trim().isEmpty) {
      errors['incidentId'] = 'Por favor ingrese el ID del incidente';
    }

    if (data.inspectionStatus == null || data.inspectionStatus!.isEmpty) {
      errors['status'] = 'Por favor seleccione un estado';
    }

    if (data.inspectionDate == null) {
      errors['date'] = 'Por favor seleccione una fecha';
    }

    if (data.inspectionTime.isEmpty) {
      errors['time'] = 'Por favor seleccione una hora';
    }

    if (data.inspectionComment.trim().isEmpty) {
      errors['comment'] = 'Por favor ingrese un comentario';
    }

    return errors;
  }

  // === MÉTODOS AUXILIARES ===

  Map<String, String> _clearContactError(
    String field,
    Map<String, String> errors,
  ) {
    final newErrors = Map<String, String>.from(errors);
    newErrors.remove(field);
    return newErrors;
  }

  Map<String, String> _clearInspectionError(
    String field,
    Map<String, String> errors,
  ) {
    final newErrors = Map<String, String>.from(errors);
    newErrors.remove(field);
    return newErrors;
  }

  // === MÉTODOS DE ACCESO ===

  ContactData? getCurrentContactData() {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      return ContactData(
        names: currentState.contactNames,
        cellPhone: currentState.contactCellPhone,
        landline: currentState.contactLandline,
        email: currentState.contactEmail,
      );
    }
    return null;
  }

  InspectionData? getCurrentInspectionData() {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      return InspectionData(
        incidentId: currentState.inspectionIncidentId,
        status: currentState.inspectionStatus ?? '',
        date: currentState.inspectionDate ?? DateTime.now(),
        time: currentState.inspectionTime,
        comment: currentState.inspectionComment,
        injured: currentState.inspectionInjured,
        dead: currentState.inspectionDead,
      );
    }
    return null;
  }

  // === MANEJADORES DE FORM KEYS ===

  void _onSetContactFormKey(
    SetContactFormKey event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      emit(currentState.copyWith(contactFormKey: event.formKey));
    }
  }

  void _onSetInspectionFormKey(
    SetInspectionFormKey event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      emit(currentState.copyWith(inspectionFormKey: event.formKey));
    }
  }
}
