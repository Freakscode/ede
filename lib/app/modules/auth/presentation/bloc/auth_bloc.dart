import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../data/models/login_request_model.dart';
import 'events/auth_events.dart';
import 'auth_state.dart';

/// BLoC de autenticación
/// Maneja la lógica de negocio relacionada con autenticación
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final LoginUseCase _loginUseCase;

  AuthBloc({
    required IAuthRepository authRepository,
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

  /// Métodos de conveniencia para acceder a información del usuario
  bool canAccessDagrdFeatures() {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return state.user.canAccessDagrdFeatures;
    }
    return false;
  }

  bool canAccessGeneralFeatures() {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return state.user.canAccessGeneralFeatures;
    }
    return false;
  }

  bool canAccessFeature(String feature) {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return state.user.canAccessDagrdFeatures;
    }
    return false;
  }

  String? getUserInfo() {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return '${state.user.nombre} (${state.user.cedula})';
    }
    return null;
  }
}