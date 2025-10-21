/// Constantes de validación centralizadas para toda la aplicación
/// 
/// Este archivo contiene todas las constantes utilizadas en las validaciones
/// para mantener consistencia y facilitar el mantenimiento.
class ValidationConstants {
  // === LONGITUDES DE CONTACTO ===
  
  static const int contactNamesMinLength = 2;
  static const int contactNamesMaxLength = 100;
  static const int contactNamesMinWords = 2;
  
  static const int contactCellPhoneLength = 10;
  static const String contactCellPhonePrefix = '3';
  
  static const int contactLandlineMinLength = 7;
  static const int contactLandlineMaxLength = 10;
  
  static const int contactEmailMaxLength = 254;
  
  // === LONGITUDES DE INSPECCIÓN ===
  
  static const int inspectionIncidentIdMinLength = 1;
  static const int inspectionIncidentIdMaxLength = 10;
  
  static const int inspectionCommentMinLength = 10;
  static const int inspectionCommentMaxLength = 500;
  static const int inspectionCommentMinWords = 3;
  
  static const int inspectionInjuredMaxValue = 1000;
  static const int inspectionDeadMaxValue = 100;
  
  // === RANGOS DE FECHA Y HORA ===
  
  static const int inspectionDateMaxYearsBack = 730; // 2 años en días
  static const int inspectionDateMaxDaysForward = 30; // 1 mes en días
  
  static const int inspectionTimeMinHour = 6;
  static const int inspectionTimeMaxHour = 22;
  
  // === REGEX PATTERNS ===
  
  static const String contactNamesPattern = r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$';
  static const String contactCellPhonePattern = r'^[0-9]{10}$';
  static const String contactLandlinePattern = r'^[0-9]+$';
  static const String contactLandlineStartPattern = r'^[1-9]';
  static const String contactEmailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  static const String inspectionIncidentIdPattern = r'^[0-9]+$';
  static const String inspectionTimePattern = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';
  
  // === VALORES POR DEFECTO ===
  
  static const String defaultInspectionTime = '08:00';
  static const int defaultInspectionInjured = 0;
  static const int defaultInspectionDead = 0;
  
  // === CONFIGURACIÓN DE UI ===
  
  static const int maxValidationRetries = 3;
  static const Duration validationTimeout = Duration(seconds: 5);
  static const Duration saveTimeout = Duration(seconds: 10);
}
