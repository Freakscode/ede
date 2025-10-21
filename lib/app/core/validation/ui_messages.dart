/// Mensajes de UI centralizados para toda la aplicación
/// 
/// Este archivo contiene mensajes de éxito, error y información
/// para la interfaz de usuario.
class UIMessages {
  // === MENSAJES DE ÉXITO ===
  
  static const String registrationCompleteSuccess = 'Registro completado exitosamente';
  static const String contactDataSaved = 'Datos de contacto guardados';
  static const String inspectionDataSaved = 'Datos de inspección guardados';
  static const String formValidated = 'Formulario validado correctamente';
  
  // === MENSAJES DE ERROR ===
  
  static const String saveError = 'Error al guardar los datos';
  static const String validationError = 'Error de validación en el formulario';
  static const String networkError = 'Error de conexión. Verifique su internet';
  static const String unknownError = 'Error desconocido. Intente nuevamente';
  static const String formIncomplete = 'Por favor complete todos los campos requeridos';
  
  // === MENSAJES DE INFORMACIÓN ===
  
  static const String loadingData = 'Cargando datos...';
  static const String savingData = 'Guardando datos...';
  static const String validatingForm = 'Validando formulario...';
  static const String processingRequest = 'Procesando solicitud...';
  
  // === MENSAJES DE NAVEGACIÓN ===
  
  static const String navigatingToHome = 'Navegando al inicio...';
  static const String creatingNewForm = 'Creando nuevo formulario...';
  static const String formReset = 'Formulario reiniciado';
  
  // === MENSAJES DE CONFIRMACIÓN ===
  
  static const String confirmSave = '¿Está seguro de que desea guardar estos datos?';
  static const String confirmReset = '¿Está seguro de que desea reiniciar el formulario?';
  static const String confirmExit = '¿Está seguro de que desea salir sin guardar?';
  
  // === MENSAJES DE AYUDA ===
  
  static const String helpContactForm = 'Complete todos los campos de contacto para continuar';
  static const String helpInspectionForm = 'Complete todos los campos de inspección para finalizar';
  static const String helpRequiredFields = 'Los campos marcados con * son obligatorios';
  
  // === MENSAJES DE ESTADO ===
  
  static const String formReady = 'Formulario listo para enviar';
  static const String formInvalid = 'Formulario con errores de validación';
  static const String formValid = 'Formulario válido';
  static const String formSaving = 'Guardando formulario...';
  static const String formSaved = 'Formulario guardado';
}
