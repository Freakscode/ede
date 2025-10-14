import 'package:flutter_bloc/flutter_bloc.dart';
import '../interfaces/auth_interface.dart';
import '../services/auth_service.dart';
import '../models/auth_result.dart';
import 'events/auth_events.dart';
import 'auth_state.dart';

/// BLoC de autenticación
/// Maneja la lógica de negocio relacionada con autenticación
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthInterface _authService;

  AuthBloc({
    AuthInterface? authService,
  }) : _authService = authService ?? AuthService(),
       super(const AuthInitial()) {
    
    // Registrar manejadores de eventos
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStatusCheckRequested>(_onAuthStatusCheckRequested);
    on<AuthErrorCleared>(_onAuthErrorCleared);
    on<AuthPermissionCheckRequested>(_onAuthPermissionCheckRequested);
  }

  /// Manejador para login
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await _authService.login(event.cedula, event.password);

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
      await _authService.logout();
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
    if (_authService.isLoggedIn && _authService.currentUser != null) {
      emit(AuthAuthenticated(
        user: _authService.currentUser!,
        message: 'Usuario autenticado',
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Manejador para limpiar errores
  void _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    if (_authService.isLoggedIn && _authService.currentUser != null) {
      emit(AuthAuthenticated(
        user: _authService.currentUser!,
        message: 'Usuario autenticado',
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Manejador para verificar permisos
  void _onAuthPermissionCheckRequested(
    AuthPermissionCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    final hasPermission = _authService.canAccessFeature(event.feature);
    
    emit(AuthPermissionChecked(
      feature: event.feature,
      hasPermission: hasPermission,
      user: _authService.currentUser,
    ));
  }

  /// Métodos de conveniencia para verificar permisos
  bool canAccessDagrdFeatures() {
    return _authService.canAccessDagrdFeatures();
  }

  bool canAccessGeneralFeatures() {
    return _authService.canAccessGeneralFeatures();
  }

  bool canAccessFeature(String feature) {
    return _authService.canAccessFeature(feature);
  }

  /// Obtener información del usuario actual
  Map<String, dynamic>? getUserInfo() {
    return _authService.isLoggedIn ? _authService.getUserInfo() : null;
  }
}
