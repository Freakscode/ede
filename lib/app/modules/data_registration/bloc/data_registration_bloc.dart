import 'package:flutter_bloc/flutter_bloc.dart';
import 'events/data_registration_events.dart';
import 'data_registration_state.dart';
import '../models/contact_data.dart';
import '../models/inspection_data.dart';
import '../services/inspection_storage_service.dart';
import '../../../core/validation/validation_messages.dart';
import '../../../core/validation/ui_messages.dart';
import '../../../core/validation/validation_constants.dart';

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

    // Eventos de lógica de formularios
    on<ContactFormSubmit>(_onContactFormSubmit);
    on<InspectionFormSubmit>(_onInspectionFormSubmit);
    on<ContactFormInitialize>(_onContactFormInitialize);
    on<InspectionFormInitialize>(_onInspectionFormInitialize);

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

      if (errors.isNotEmpty) {
        errors.forEach((field, message) {
        });
      }

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
      final inspectionData = InspectionData(
        incidentId: currentState.inspectionIncidentId,
        status: currentState.inspectionStatus ?? '',
        date: currentState.inspectionDate ?? DateTime.now(),
        time: currentState.inspectionTime,
        comment: currentState.inspectionComment,
        injured: currentState.inspectionInjured,
        dead: currentState.inspectionDead,
      );

      final storageService = InspectionStorageService();
      await storageService.saveInspection(inspectionData);

      emit(const CompleteRegistrationSaved(
        message: 'Registro completo guardado correctamente',
      ));
    } catch (e) {
      emit(DataRegistrationError('${UIMessages.saveError}: $e'));
    }
  }

  // === MÉTODOS DE VALIDACIÓN ===

  Map<String, String> _validateContactForm(DataRegistrationData data) {
    final errors = <String, String>{};

    // Validación de nombres
    if (data.contactNames.trim().isEmpty) {
      errors['names'] = ValidationMessages.contactNamesRequired;
    } else {
      final names = data.contactNames.trim();
      if (names.length < ValidationConstants.contactNamesMinLength) {
        errors['names'] = ValidationMessages.contactNamesMinLength;
      } else if (names.length > ValidationConstants.contactNamesMaxLength) {
        errors['names'] = ValidationMessages.contactNamesMaxLength;
      } else if (names.split(' ').length < ValidationConstants.contactNamesMinWords) {
        errors['names'] = ValidationMessages.contactNamesMinWords;
      } else if (!RegExp(ValidationConstants.contactNamesPattern).hasMatch(names)) {
        errors['names'] = ValidationMessages.contactNamesInvalidFormat;
      }
    }

    // Validación de celular
    if (data.contactCellPhone.trim().isEmpty) {
      errors['cellPhone'] = ValidationMessages.contactCellPhoneRequired;
    } else {
      final cellPhone = data.contactCellPhone.trim();
      if (cellPhone.length != ValidationConstants.contactCellPhoneLength) {
        errors['cellPhone'] = ValidationMessages.contactCellPhoneLength;
      } else if (!RegExp(ValidationConstants.contactCellPhonePattern).hasMatch(cellPhone)) {
        errors['cellPhone'] = ValidationMessages.contactCellPhoneDigitsOnly;
      } else if (!cellPhone.startsWith(ValidationConstants.contactCellPhonePrefix)) {
        errors['cellPhone'] = ValidationMessages.contactCellPhonePrefix;
      }
    }

    // Validación de teléfono fijo
    if (data.contactLandline.trim().isEmpty) {
      errors['landline'] = ValidationMessages.contactLandlineRequired;
    } else {
      final landline = data.contactLandline.trim();
      if (landline.length < ValidationConstants.contactLandlineMinLength) {
        errors['landline'] = ValidationMessages.contactLandlineMinLength;
      } else if (landline.length > ValidationConstants.contactLandlineMaxLength) {
        errors['landline'] = ValidationMessages.contactLandlineMaxLength;
      } else if (!RegExp(ValidationConstants.contactLandlinePattern).hasMatch(landline)) {
        errors['landline'] = ValidationMessages.contactLandlineDigitsOnly;
      } else if (!landline.startsWith(RegExp(ValidationConstants.contactLandlineStartPattern))) {
        errors['landline'] = ValidationMessages.contactLandlineInvalidStart;
      }
    }

    // Validación de email
    if (data.contactEmail.trim().isEmpty) {
      errors['email'] = ValidationMessages.contactEmailRequired;
    } else {
      final email = data.contactEmail.trim().toLowerCase();
      final emailRegex = RegExp(ValidationConstants.contactEmailPattern);
      
      if (!emailRegex.hasMatch(email)) {
        errors['email'] = ValidationMessages.contactEmailInvalidFormat;
      } else if (email.length > ValidationConstants.contactEmailMaxLength) {
        errors['email'] = ValidationMessages.contactEmailTooLong;
      } else if (email.contains('..')) {
        errors['email'] = ValidationMessages.contactEmailConsecutiveDots;
      }
    }

    return errors;
  }

  Map<String, String> _validateInspectionForm(DataRegistrationData data) {
    final errors = <String, String>{};

    // Validación de ID de incidente
    if (data.inspectionIncidentId.trim().isEmpty) {
      errors['incidentId'] = ValidationMessages.inspectionIncidentIdRequired;
    } else {
      final incidentId = data.inspectionIncidentId.trim();
      if (!RegExp(ValidationConstants.inspectionIncidentIdPattern).hasMatch(incidentId)) {
        errors['incidentId'] = ValidationMessages.inspectionIncidentIdDigitsOnly;
      } else if (incidentId.length < ValidationConstants.inspectionIncidentIdMinLength) {
        errors['incidentId'] = ValidationMessages.inspectionIncidentIdMinLength;
      } else if (incidentId.length > ValidationConstants.inspectionIncidentIdMaxLength) {
        errors['incidentId'] = ValidationMessages.inspectionIncidentIdMaxLength;
      }
    }

    // Validación de estado
    if (data.inspectionStatus == null || data.inspectionStatus!.isEmpty) {
      errors['status'] = ValidationMessages.inspectionStatusRequired;
    }

    // Validación de fecha
    if (data.inspectionDate == null) {
      errors['date'] = ValidationMessages.inspectionDateRequired;
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final twoYearsAgo = today.subtract(const Duration(days: ValidationConstants.inspectionDateMaxYearsBack));
      final oneMonthFromNow = today.add(const Duration(days: ValidationConstants.inspectionDateMaxDaysForward));
      
      if (data.inspectionDate!.isBefore(twoYearsAgo)) {
        errors['date'] = ValidationMessages.inspectionDateTooOld;
      } else if (data.inspectionDate!.isAfter(oneMonthFromNow)) {
        errors['date'] = ValidationMessages.inspectionDateTooFuture;
      }
    }

    // Validación de hora
    if (data.inspectionTime.isEmpty) {
      errors['time'] = ValidationMessages.inspectionTimeRequired;
    } else {
      final timeRegex = RegExp(ValidationConstants.inspectionTimePattern);
      if (!timeRegex.hasMatch(data.inspectionTime)) {
        errors['time'] = ValidationMessages.inspectionTimeInvalidFormat;
      } else {
        final hour = int.parse(data.inspectionTime.split(':')[0]);
        if (hour < ValidationConstants.inspectionTimeMinHour || hour > ValidationConstants.inspectionTimeMaxHour) {
          errors['time'] = ValidationMessages.inspectionTimeOutOfRange;
        }
      }
    }

    // Validación de comentario - Sin validación (completamente opcional)
    // No se valida el comentario, es completamente opcional

    // Validación de números (lesionados y muertos)
    if (data.inspectionInjured < 0) {
      errors['injured'] = ValidationMessages.inspectionInjuredNegative;
    } else if (data.inspectionInjured > ValidationConstants.inspectionInjuredMaxValue) {
      errors['injured'] = ValidationMessages.inspectionInjuredTooHigh;
    }
    
    if (data.inspectionDead < 0) {
      errors['dead'] = ValidationMessages.inspectionDeadNegative;
    } else if (data.inspectionDead > ValidationConstants.inspectionDeadMaxValue) {
      errors['dead'] = ValidationMessages.inspectionDeadTooHigh;
    }

    // Validación de coherencia entre lesionados y muertos
    if (data.inspectionInjured > 0 && data.inspectionDead > data.inspectionInjured) {
      errors['dead'] = ValidationMessages.inspectionDeadInconsistent;
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

  // === MANEJADORES DE LÓGICA DE FORMULARIOS ===

  /// Maneja el envío del formulario de contacto
  void _onContactFormSubmit(
    ContactFormSubmit event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is! DataRegistrationData) return;
    
    // Disparar validación
    add(const ContactFormValidated());
  }

  /// Maneja el envío del formulario de inspección
  void _onInspectionFormSubmit(
    InspectionFormSubmit event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is! DataRegistrationData) return;
    
    // Disparar validación
    add(const InspectionFormValidated());
  }

  /// Inicializa el formulario de contacto
  void _onContactFormInitialize(
    ContactFormInitialize event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      // El estado ya está inicializado
    }
  }

  /// Inicializa el formulario de inspección
  void _onInspectionFormInitialize(
    InspectionFormInitialize event,
    Emitter<DataRegistrationState> emit,
  ) {
    if (state is DataRegistrationData) {
      // El estado ya está inicializado
    }
  }

}
