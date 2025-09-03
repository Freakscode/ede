class AppConstants {
  // App info
  static const String appName = 'EDE Final App';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String evaluacionDataKey = 'evaluacion_data';
  
  // Form Constants
  static const int maxPhotosPerEvaluation = 10;
  static const double maxImageSizeMB = 5.0;
}

class AppStrings {
  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancelar';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  
  // Errors
  static const String genericError = 'Ha ocurrido un error inesperado';
  static const String networkError = 'Error de conexión. Verifica tu conexión a internet';
  static const String serverError = 'Error del servidor. Intenta más tarde';
  static const String authError = 'Error de autenticación';
  static const String validationError = 'Error de validación';
  
  // Auth
  static const String loginTitle = 'Iniciar Sesión';
  static const String loginButton = 'Entrar';
  static const String logoutButton = 'Cerrar Sesión';
}

class AppColors {
  // Brand colors would go here
  // static const Color primary = Color(0xFF...);
}
