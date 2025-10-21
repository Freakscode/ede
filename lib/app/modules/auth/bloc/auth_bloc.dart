import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/auth_repository_interface.dart';
import '../domain/usecases/login_usecase.dart';
import '../models/auth_result.dart';
import '../models/login_request_model.dart';
import 'events/auth_events.dart';
import 'auth_state.dart';

/// BLoC de autenticación
/// Maneja la lógica de negocio relacionada con autenticación
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;

  AuthBloc({
    required AuthRepository authRepository,
    LoginUseCase? loginUseCase,
  }) : _authRepository = authRepository,
       _loginUseCase = loginUseCase ?? LoginUseCase(authRepository),
       super(const AuthInitial()) {
    
    // Registrar manejadores de eventos
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStatusCheckRequested>(_onAuthStatusCheckRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);
    on<AuthPermissionCheckRequested>(_onAuthPermissionCheckRequested);
    
    // Verificar estado de autenticación al inicializar
    add(const AuthStatusCheckRequested());
  }

  /// Manejador para login
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Crear request model
      final loginRequest = LoginRequestModel.fromCredentials(
        cedula: event.cedula,
        password: event.password,
      );

      // Usar caso de uso
      final result = await _loginUseCase.execute(loginRequest);

      if (result.success && result.user != null) {
        emit(AuthAuthenticated(
          user: result.user!,
          message: result.message,
        ));
      } else {
        emit(AuthError(
          message: result.message,
          errorType: result.errorType ?? AuthErrorType.unknown,
        ));
      }
    } catch (e) {
      emit(AuthError(
        message: 'Error inesperado durante el login',
        errorType: AuthErrorType.unknown,
      ));
    }
  }

  /// Manejador para logout
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated(message: 'Sesión cerrada exitosamente'));
    } catch (e) {
      emit(AuthError(
        message: 'Error al cerrar sesión',
        errorType: AuthErrorType.unknown,
      ));
    }
  }

  /// Manejador para verificar estado
  Future<void> _onAuthStatusCheckRequested(
    AuthStatusCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print('=== AuthBloc: Verificando estado de autenticación ===');
      final isLoggedIn = await _authRepository.isLoggedIn();
      print('AuthBloc: isLoggedIn = $isLoggedIn');
      
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        print('AuthBloc: user = $user');
        if (user != null) {
          print('AuthBloc: Usuario encontrado, emitiendo AuthAuthenticated');
          emit(AuthAuthenticated(
            user: user,
            message: 'Usuario autenticado',
          ));
        } else {
          print('AuthBloc: Usuario es null, emitiendo AuthUnauthenticated');
          emit(const AuthUnauthenticated());
        }
      } else {
        print('AuthBloc: No está logueado, emitiendo AuthUnauthenticated');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      print('AuthBloc: Error al verificar estado: $e');
      emit(const AuthUnauthenticated());
    }
  }

  /// Manejador para limpiar errores
  Future<void> _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(
            user: user,
            message: 'Usuario autenticado',
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Manejador para verificar permisos
  Future<void> _onAuthPermissionCheckRequested(
    AuthPermissionCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      final hasPermission = user?.canAccessDagrdFeatures ?? false;
      
      emit(AuthPermissionChecked(
        feature: event.feature,
        hasPermission: hasPermission,
        user: user,
      ));
    } catch (e) {
      emit(AuthPermissionChecked(
        feature: event.feature,
        hasPermission: false,
        user: null,
      ));
    }
  }

  /// Métodos de conveniencia para verificar permisos
  Future<bool> canAccessDagrdFeatures() async {
    final user = await _authRepository.getCurrentUser();
    return user?.canAccessDagrdFeatures ?? false;
  }

  Future<bool> canAccessGeneralFeatures() async {
    final user = await _authRepository.getCurrentUser();
    return user?.canAccessGeneralFeatures ?? false;
  }

  Future<bool> canAccessFeature(String feature) async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) return false;
    
    switch (feature.toLowerCase()) {
      case 'risk_analysis':
      case 'evaluation':
      case 'data_registration':
        return user.canAccessDagrdFeatures;
      case 'view_reports':
      case 'basic_info':
        return user.canAccessGeneralFeatures;
      default:
        return false;
    }
  }

  /// Obtener información del usuario actual
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) return null;
      
      return {
        'loggedIn': true,
        'cedula': user.cedula,
        'nombre': user.nombre,
        'isDagrdUser': user.isDagrdUser,
        'cargo': user.cargo,
        'dependencia': user.dependencia,
        'email': user.email,
        'telefono': user.telefono,
        'canAccessDagrdFeatures': user.canAccessDagrdFeatures,
        'canAccessGeneralFeatures': user.canAccessGeneralFeatures,
      };
    } catch (e) {
      return null;
    }
  }
}
