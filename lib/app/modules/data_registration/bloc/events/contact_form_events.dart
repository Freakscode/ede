import 'package:equatable/equatable.dart';

/// Eventos del formulario de contacto
abstract class ContactFormEvent extends Equatable {
  const ContactFormEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para actualizar el campo de nombres
class ContactFormNamesChanged extends ContactFormEvent {
  final String names;

  const ContactFormNamesChanged(this.names);

  @override
  List<Object?> get props => [names];
}

/// Evento para actualizar el campo de celular
class ContactFormCellPhoneChanged extends ContactFormEvent {
  final String cellPhone;

  const ContactFormCellPhoneChanged(this.cellPhone);

  @override
  List<Object?> get props => [cellPhone];
}

/// Evento para actualizar el campo de teléfono fijo
class ContactFormLandlineChanged extends ContactFormEvent {
  final String landline;

  const ContactFormLandlineChanged(this.landline);

  @override
  List<Object?> get props => [landline];
}

/// Evento para actualizar el campo de email
class ContactFormEmailChanged extends ContactFormEvent {
  final String email;

  const ContactFormEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Evento para validar el formulario
class ContactFormValidated extends ContactFormEvent {
  const ContactFormValidated();
}

/// Evento para resetear el formulario
class ContactFormReset extends ContactFormEvent {
  const ContactFormReset();
}

/// Evento para guardar el formulario
class ContactFormSaveRequested extends ContactFormEvent {
  const ContactFormSaveRequested();
}
