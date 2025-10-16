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

  }

  // === MANEJADORES DE FORMULARIO DE CONTACTO ===

  void _onContactNamesChanged(
    ContactFormNamesChanged event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      final newState = currentState.copyWith(
        contactNames: event.names,
        contactErrors: _clearContactError('names', currentState.contactErrors),
      );
      emit(newState);
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
    if (state is DataRegistrationData) {
      final currentState = state as DataRegistrationData;
      
      final errors = _validateContactForm(currentState);
      final isValid = errors.isEmpty;

      print('=== VALIDACIÓN FORMULARIO DE CONTACTO ===');
      print('Errores encontrados: $errors');
      print('Es válido: $isValid');
      if (errors.isNotEmpty) {
        print('=== DETALLE DE ERRORES DE CONTACTO ===');
        errors.forEach((field, message) {
          print('$field: $message');
        });
        print('======================================');
      }
      print('========================================');

      final newState = currentState.copyWith(
        contactErrors: errors,
        isContactValid: isValid,
      );
      emit(newState);

      if (isValid) {
        emit(newState.copyWith(showInspectionForm: true));
      }
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
      print('=== PROCESANDO CAMBIO DE ESTADO ===');
      print('Estado anterior: ${currentState.inspectionStatus}');
      print('Nuevo estado: ${event.status}');
      print('==================================');
      
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
    if (state is! DataRegistrationData) return;
    
    final currentState = state as DataRegistrationData;
    final errors = _validateInspectionForm(currentState);
    final isValid = errors.isEmpty;

    print('=== VALIDACIÓN COMPLETADA ===');
    print('Errores encontrados: $errors');
    print('Es válido: $isValid');
    if (errors.isNotEmpty) {
      print('=== DETALLE DE ERRORES ===');
      errors.forEach((field, message) {
        print('$field: $message');
      });
      print('==========================');
    }
    print('============================');

    emit(currentState.copyWith(
      inspectionErrors: errors,
      isInspectionValid: isValid,
    ));

    // Guardar automáticamente si es válido
    if (isValid) {
      add(const SaveCompleteRegistration());
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
    // Emitir estado inicial limpio, asegurando que no quede en loading
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
    if (state is! DataRegistrationData) return;
    
    // Guardar el estado antes de emitir loading
    final currentState = state as DataRegistrationData;
    emit(const DataRegistrationLoading());

    try {
      
      // Crear y guardar datos de inspección
      print('=== CREANDO InspectionData ===');
      print('incidentId: ${currentState.inspectionIncidentId} (${currentState.inspectionIncidentId.runtimeType})');
      print('status: ${currentState.inspectionStatus} (${currentState.inspectionStatus.runtimeType})');
      print('date: ${currentState.inspectionDate} (${currentState.inspectionDate.runtimeType})');
      print('time: ${currentState.inspectionTime} (${currentState.inspectionTime.runtimeType})');
      print('comment: ${currentState.inspectionComment} (${currentState.inspectionComment.runtimeType})');
      print('injured: ${currentState.inspectionInjured} (${currentState.inspectionInjured.runtimeType})');
      print('dead: ${currentState.inspectionDead} (${currentState.inspectionDead.runtimeType})');
      
      final inspectionData = InspectionData(
        incidentId: currentState.inspectionIncidentId,
        status: currentState.inspectionStatus ?? '',
        date: currentState.inspectionDate ?? DateTime.now(),
        time: currentState.inspectionTime,
        comment: currentState.inspectionComment,
        injured: currentState.inspectionInjured,
        dead: currentState.inspectionDead,
      );
      
      print('InspectionData creado exitosamente: $inspectionData');
      print('===============================');

      final storageService = InspectionStorageService();
      await storageService.saveInspection(inspectionData);

      print('=== DATOS COMPLETOS GUARDADOS EN STORAGE ===');
      print('--- DATOS DE CONTACTO ---');
      print('Nombres: ${currentState.contactNames}');
      print('Celular: ${currentState.contactCellPhone}');
      print('Teléfono fijo: ${currentState.contactLandline}');
      print('Email: ${currentState.contactEmail}');
      print('--- DATOS DE INSPECCIÓN ---');
      print('InspectionData guardado: $inspectionData');
      print('==========================================');

      emit(const CompleteRegistrationSaved(
        message: 'Registro completo guardado correctamente',
      ));
    } catch (e) {
      print('=== ERROR EN GUARDADO ===');
      print('Error: $e');
      print('Tipo de error: ${e.runtimeType}');
      print('Stack trace: ${StackTrace.current}');
      print('========================');
      emit(DataRegistrationError('Error al guardar los datos: $e'));
    }
  }

  // === MÉTODOS DE VALIDACIÓN ===

  Map<String, String> _validateContactForm(DataRegistrationData data) {
    final errors = <String, String>{};

    // Validación de nombres
    if (data.contactNames.trim().isEmpty) {
      errors['names'] = 'Por favor ingrese sus nombres';
    } else if (data.contactNames.trim().length < 2) {
      errors['names'] = 'Los nombres deben tener al menos 2 caracteres';
    }

    // Validación de celular
    if (data.contactCellPhone.trim().isEmpty) {
      errors['cellPhone'] = 'Por favor ingrese su número de celular';
    } else if (data.contactCellPhone.length != 10) {
      errors['cellPhone'] = 'El número de celular debe tener exactamente 10 dígitos';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(data.contactCellPhone)) {
      errors['cellPhone'] = 'El número de celular debe contener solo dígitos';
    }

    // Validación de teléfono fijo
    if (data.contactLandline.trim().isEmpty) {
      errors['landline'] = 'Por favor ingrese su número fijo';
    } else if (data.contactLandline.length < 7) {
      errors['landline'] = 'El número fijo debe tener al menos 7 dígitos';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(data.contactLandline)) {
      errors['landline'] = 'El número fijo debe contener solo dígitos';
    }

    // Validación de email
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

    // Validación de ID de incidente
    if (data.inspectionIncidentId.trim().isEmpty) {
      errors['incidentId'] = 'Por favor ingrese el ID del incidente';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(data.inspectionIncidentId.trim())) {
      errors['incidentId'] = 'El ID del incidente debe contener solo números';
    }

    // Validación de estado
    if (data.inspectionStatus == null || data.inspectionStatus!.isEmpty) {
      errors['status'] = 'Por favor seleccione un estado';
    }

    // Validación de fecha
    if (data.inspectionDate == null) {
      errors['date'] = 'Por favor seleccione una fecha';
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (data.inspectionDate!.isBefore(today.subtract(const Duration(days: 365)))) {
        errors['date'] = 'La fecha no puede ser anterior a hace un año';
      } else if (data.inspectionDate!.isAfter(today)) {
        errors['date'] = 'La fecha no puede ser futura';
      }
    }

    // Validación de hora
    if (data.inspectionTime.isEmpty) {
      errors['time'] = 'Por favor seleccione una hora';
    } else if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(data.inspectionTime)) {
      errors['time'] = 'Formato de hora inválido (HH:MM)';
    }

    // Validación de comentario
    if (data.inspectionComment.trim().isEmpty) {
      errors['comment'] = 'Por favor ingrese un comentario';
    } else if (data.inspectionComment.trim().length < 10) {
      errors['comment'] = 'El comentario debe tener al menos 10 caracteres';
    }

    // Validación de números (lesionados y muertos)
    if (data.inspectionInjured < 0) {
      errors['injured'] = 'El número de lesionados no puede ser negativo';
    }
    if (data.inspectionDead < 0) {
      errors['dead'] = 'El número de muertos no puede ser negativo';
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

}
