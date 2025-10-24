abstract class DataRegistrationEvent {
  const DataRegistrationEvent();
}

// Eventos para el formulario de contacto
class ContactFormNamesChanged extends DataRegistrationEvent {
  final String names;
  const ContactFormNamesChanged(this.names);
}

class ContactFormCellPhoneChanged extends DataRegistrationEvent {
  final String cellPhone;
  const ContactFormCellPhoneChanged(this.cellPhone);
}

class ContactFormLandlineChanged extends DataRegistrationEvent {
  final String landline;
  const ContactFormLandlineChanged(this.landline);
}

class ContactFormEmailChanged extends DataRegistrationEvent {
  final String email;
  const ContactFormEmailChanged(this.email);
}

class ContactFormValidated extends DataRegistrationEvent {
  const ContactFormValidated();
}

// Eventos para el formulario de inspección
class InspectionFormIncidentIdChanged extends DataRegistrationEvent {
  final String incidentId;
  const InspectionFormIncidentIdChanged(this.incidentId);
}

class InspectionFormStatusChanged extends DataRegistrationEvent {
  final String? status;
  const InspectionFormStatusChanged(this.status);
}

class InspectionFormDateChanged extends DataRegistrationEvent {
  final DateTime? date;
  const InspectionFormDateChanged(this.date);
}

class InspectionFormTimeChanged extends DataRegistrationEvent {
  final String time;
  const InspectionFormTimeChanged(this.time);
}

class InspectionFormCommentChanged extends DataRegistrationEvent {
  final String comment;
  const InspectionFormCommentChanged(this.comment);
}

class InspectionFormInjuredChanged extends DataRegistrationEvent {
  final int injured;
  const InspectionFormInjuredChanged(this.injured);
}

class InspectionFormDeadChanged extends DataRegistrationEvent {
  final int dead;
  const InspectionFormDeadChanged(this.dead);
}

class InspectionFormValidated extends DataRegistrationEvent {
  const InspectionFormValidated();
}

// Eventos de navegación y control
class NavigateToInspectionForm extends DataRegistrationEvent {
  const NavigateToInspectionForm();
}

class NavigateToContactForm extends DataRegistrationEvent {
  const NavigateToContactForm();
}

class ResetAllForms extends DataRegistrationEvent {
  const ResetAllForms();
}

class SaveCompleteRegistration extends DataRegistrationEvent {
  const SaveCompleteRegistration();
}

// Eventos para lógica de formularios
class ContactFormSubmit extends DataRegistrationEvent {
  const ContactFormSubmit();
}

class InspectionFormSubmit extends DataRegistrationEvent {
  const InspectionFormSubmit();
}

class ContactFormInitialize extends DataRegistrationEvent {
  const ContactFormInitialize();
}

class InspectionFormInitialize extends DataRegistrationEvent {
  const InspectionFormInitialize();
}

