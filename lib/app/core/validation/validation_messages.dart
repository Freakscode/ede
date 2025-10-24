/// Mensajes de validación centralizados para toda la aplicación
/// 
/// Este archivo contiene todos los mensajes de error de validación
/// para mantener consistencia y facilitar la localización.
class ValidationMessages {
  // === MENSAJES DE CONTACTO ===
  
  static const String contactNamesRequired = 'Los nombres son obligatorios';
  static const String contactNamesMinLength = 'Los nombres deben tener al menos 2 caracteres';
  static const String contactNamesMaxLength = 'Los nombres no pueden tener más de 100 caracteres';
  static const String contactNamesMinWords = 'Debe ingresar al menos nombre y apellido';
  static const String contactNamesInvalidFormat = 'Los nombres solo pueden contener letras y espacios';
  
  static const String contactCellPhoneRequired = 'El número de celular es obligatorio';
  static const String contactCellPhoneLength = 'El número de celular debe tener exactamente 10 dígitos';
  static const String contactCellPhoneDigitsOnly = 'El número de celular debe contener solo dígitos';
  static const String contactCellPhonePrefix = 'El número de celular debe comenzar con 3';
  
  static const String contactLandlineRequired = 'El número de teléfono fijo es obligatorio';
  static const String contactLandlineMinLength = 'El número fijo debe tener al menos 7 dígitos';
  static const String contactLandlineMaxLength = 'El número fijo no puede tener más de 10 dígitos';
  static const String contactLandlineDigitsOnly = 'El número fijo debe contener solo dígitos';
  static const String contactLandlineInvalidStart = 'El número fijo no puede comenzar con 0';
  
  static const String contactEmailRequired = 'El correo electrónico es obligatorio';
  static const String contactEmailInvalidFormat = 'Formato de correo electrónico inválido';
  static const String contactEmailTooLong = 'El correo electrónico es demasiado largo';
  static const String contactEmailConsecutiveDots = 'El correo electrónico no puede contener puntos consecutivos';
  
  // === MENSAJES DE INSPECCIÓN ===
  
  static const String inspectionIncidentIdRequired = 'El ID del incidente es obligatorio';
  static const String inspectionIncidentIdDigitsOnly = 'El ID del incidente debe contener solo números';
  static const String inspectionIncidentIdMinLength = 'El ID del incidente debe tener al menos 1 dígito';
  static const String inspectionIncidentIdMaxLength = 'El ID del incidente no puede tener más de 10 dígitos';
  
  static const String inspectionStatusRequired = 'Debe seleccionar un estado de la inspección';
  
  static const String inspectionDateRequired = 'La fecha de inspección es obligatoria';
  static const String inspectionDateTooOld = 'La fecha no puede ser anterior a hace 2 años';
  static const String inspectionDateTooFuture = 'La fecha no puede ser posterior a un mes desde hoy';
  
  static const String inspectionTimeRequired = 'La hora de inspección es obligatoria';
  static const String inspectionTimeInvalidFormat = 'Formato de hora inválido. Use HH:MM (ej: 14:30)';
  static const String inspectionTimeOutOfRange = 'La hora debe estar entre las 06:00 y 22:00';
  
  static const String inspectionCommentRequired = 'El comentario de la inspección es obligatorio';
  static const String inspectionCommentMinLength = 'El comentario debe tener al menos 10 caracteres';
  static const String inspectionCommentMaxLength = 'El comentario no puede tener más de 500 caracteres';
  static const String inspectionCommentMinWords = 'El comentario debe tener al menos 3 palabras';
  
  static const String inspectionInjuredNegative = 'El número de lesionados no puede ser negativo';
  static const String inspectionInjuredTooHigh = 'El número de lesionados no puede ser mayor a 1000';
  
  static const String inspectionDeadNegative = 'El número de muertos no puede ser negativo';
  static const String inspectionDeadTooHigh = 'El número de muertos no puede ser mayor a 100';
  static const String inspectionDeadInconsistent = 'El número de muertos no puede ser mayor al de lesionados';
  
  // === MENSAJES GENÉRICOS ===
  
  static const String fieldRequired = 'Este campo es obligatorio';
  static const String invalidFormat = 'Formato inválido';
  static const String valueTooShort = 'El valor es demasiado corto';
  static const String valueTooLong = 'El valor es demasiado largo';
  static const String valueOutOfRange = 'El valor está fuera del rango permitido';
  static const String invalidCharacters = 'Caracteres inválidos';
  
  // === MENSAJES DE ÉXITO ===
  
  static const String contactSaved = 'Datos de contacto guardados correctamente';
  static const String inspectionSaved = 'Datos de inspección guardados correctamente';
  static const String registrationComplete = 'Registro completo guardado correctamente';
  
  // === MENSAJES DE ERROR GENÉRICO ===
  
  static const String saveError = 'Error al guardar los datos';
  static const String validationError = 'Error de validación';
  static const String networkError = 'Error de conexión';
  static const String unknownError = 'Error desconocido';
}
