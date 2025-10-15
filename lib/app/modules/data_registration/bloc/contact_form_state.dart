import 'package:equatable/equatable.dart';

/// Estados del formulario de contacto
abstract class ContactFormState extends Equatable {
  const ContactFormState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial del formulario
class ContactFormInitial extends ContactFormState {
  const ContactFormInitial();
}

/// Estado de carga
class ContactFormLoading extends ContactFormState {
  const ContactFormLoading();
}

/// Estado con datos del formulario
class ContactFormData extends ContactFormState {
  final String names;
  final String cellPhone;
  final String landline;
  final String email;
  final bool isValid;
  final Map<String, String> errors;

  const ContactFormData({
    required this.names,
    required this.cellPhone,
    required this.landline,
    required this.email,
    required this.isValid,
    this.errors = const {},
  });

  ContactFormData copyWith({
    String? names,
    String? cellPhone,
    String? landline,
    String? email,
    bool? isValid,
    Map<String, String>? errors,
  }) {
    return ContactFormData(
      names: names ?? this.names,
      cellPhone: cellPhone ?? this.cellPhone,
      landline: landline ?? this.landline,
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [names, cellPhone, landline, email, isValid, errors];
}

/// Estado de éxito al guardar
class ContactFormSaved extends ContactFormState {
  final String message;

  const ContactFormSaved(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado de error
class ContactFormError extends ContactFormState {
  final String message;

  const ContactFormError(this.message);

  @override
  List<Object?> get props => [message];
}
