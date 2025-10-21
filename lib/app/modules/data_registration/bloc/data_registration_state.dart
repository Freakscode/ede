abstract class DataRegistrationState {
  const DataRegistrationState();
}

class DataRegistrationInitial extends DataRegistrationState {
  const DataRegistrationInitial();
}

class DataRegistrationLoading extends DataRegistrationState {
  const DataRegistrationLoading();
}

class DataRegistrationData extends DataRegistrationState {
  // Datos del formulario de contacto
  final String contactNames;
  final String contactCellPhone;
  final String contactLandline;
  final String contactEmail;
  final Map<String, String> contactErrors;
  final bool isContactValid;

  // Datos del formulario de inspección
  final String inspectionIncidentId;
  final String? inspectionStatus;
  final DateTime? inspectionDate;
  final String inspectionTime;
  final String inspectionComment;
  final int inspectionInjured;
  final int inspectionDead;
  final Map<String, String> inspectionErrors;
  final bool isInspectionValid;

  // Estado de navegación
  final bool showInspectionForm;

  const DataRegistrationData({
    // Datos de contacto
    required this.contactNames,
    required this.contactCellPhone,
    required this.contactLandline,
    required this.contactEmail,
    required this.contactErrors,
    required this.isContactValid,
    // Datos de inspección
    required this.inspectionIncidentId,
    required this.inspectionStatus,
    required this.inspectionDate,
    required this.inspectionTime,
    required this.inspectionComment,
    required this.inspectionInjured,
    required this.inspectionDead,
    required this.inspectionErrors,
    required this.isInspectionValid,
    // Navegación
    required this.showInspectionForm,
  });

  DataRegistrationData copyWith({
    // Datos de contacto
    String? contactNames,
    String? contactCellPhone,
    String? contactLandline,
    String? contactEmail,
    Map<String, String>? contactErrors,
    bool? isContactValid,
    // Datos de inspección
    String? inspectionIncidentId,
    String? inspectionStatus,
    DateTime? inspectionDate,
    String? inspectionTime,
    String? inspectionComment,
    int? inspectionInjured,
    int? inspectionDead,
    Map<String, String>? inspectionErrors,
    bool? isInspectionValid,
    // Navegación
    bool? showInspectionForm,
  }) {
    return DataRegistrationData(
      // Datos de contacto
      contactNames: contactNames ?? this.contactNames,
      contactCellPhone: contactCellPhone ?? this.contactCellPhone,
      contactLandline: contactLandline ?? this.contactLandline,
      contactEmail: contactEmail ?? this.contactEmail,
      contactErrors: contactErrors ?? this.contactErrors,
      isContactValid: isContactValid ?? this.isContactValid,
      // Datos de inspección
      inspectionIncidentId: inspectionIncidentId ?? this.inspectionIncidentId,
      inspectionStatus: inspectionStatus ?? this.inspectionStatus,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      inspectionTime: inspectionTime ?? this.inspectionTime,
      inspectionComment: inspectionComment ?? this.inspectionComment,
      inspectionInjured: inspectionInjured ?? this.inspectionInjured,
      inspectionDead: inspectionDead ?? this.inspectionDead,
      inspectionErrors: inspectionErrors ?? this.inspectionErrors,
      isInspectionValid: isInspectionValid ?? this.isInspectionValid,
      // Navegación
      showInspectionForm: showInspectionForm ?? this.showInspectionForm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataRegistrationData &&
        other.contactNames == contactNames &&
        other.contactCellPhone == contactCellPhone &&
        other.contactLandline == contactLandline &&
        other.contactEmail == contactEmail &&
        other.contactErrors.toString() == contactErrors.toString() &&
        other.isContactValid == isContactValid &&
        other.inspectionIncidentId == inspectionIncidentId &&
        other.inspectionStatus == inspectionStatus &&
        other.inspectionDate == inspectionDate &&
        other.inspectionTime == inspectionTime &&
        other.inspectionComment == inspectionComment &&
        other.inspectionInjured == inspectionInjured &&
        other.inspectionDead == inspectionDead &&
        other.inspectionErrors.toString() == inspectionErrors.toString() &&
        other.isInspectionValid == isInspectionValid &&
        other.showInspectionForm == showInspectionForm;
  }

  @override
  int get hashCode {
    return contactNames.hashCode ^
        contactCellPhone.hashCode ^
        contactLandline.hashCode ^
        contactEmail.hashCode ^
        contactErrors.hashCode ^
        isContactValid.hashCode ^
        inspectionIncidentId.hashCode ^
        inspectionStatus.hashCode ^
        inspectionDate.hashCode ^
        inspectionTime.hashCode ^
        inspectionComment.hashCode ^
        inspectionInjured.hashCode ^
        inspectionDead.hashCode ^
        inspectionErrors.hashCode ^
        isInspectionValid.hashCode ^
        showInspectionForm.hashCode;
  }
}

class ContactFormSaved extends DataRegistrationState {
  final String message;
  const ContactFormSaved({this.message = 'Datos de contacto guardados correctamente'});
}

class InspectionFormSaved extends DataRegistrationState {
  final String message;
  const InspectionFormSaved({this.message = 'Formulario de inspección guardado correctamente'});
}

class CompleteRegistrationSaved extends DataRegistrationState {
  final String message;
  const CompleteRegistrationSaved({this.message = 'Registro completo guardado correctamente'});
}

class DataRegistrationError extends DataRegistrationState {
  final String message;
  const DataRegistrationError(this.message);
}
