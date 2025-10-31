import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/usecases/usecase.dart';
import 'package:caja_herramientas/app/core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_auth_status_usecase.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/entities/login_params.dart';
import 'events/auth_events.dart';
import 'auth_state.dart';

/// BLoC de autenticación
/// Maneja la lógica de negocio relacionada con autenticación
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStatusUseCase _getAuthStatusUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetAuthStatusUseCase getAuthStatusUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _getAuthStatusUseCase = getAuthStatusUseCase,
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

  /// Manejador para login usando Either
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Crear LoginParams (entidad de dominio)
    final loginParams = LoginParams.fromCredentials(
      cedula: event.cedula,
      password: event.password,
    );

    // Usar caso de uso con Either
    final result = await _loginUseCase.call(loginParams);
    
    // Fold para manejar Left (error) o Right (éxito)
    result.fold(
      (failure) {
        emit(AuthError(
          message: failure.message,
          errorType: _mapFailureToAuthErrorType(failure),
        ));
      },
      (authResult) {
        if (authResult.success && authResult.user != null) {
          emit(AuthAuthenticated(
            user: authResult.user!,
            message: authResult.message,
          ));
        } else {
          emit(AuthError(
            message: authResult.message,
            errorType: authResult.errorType ?? AuthErrorType.unknown,
          ));
        }
      },
    );
  }

  /// Mapear Failure a AuthErrorType
  AuthErrorType _mapFailureToAuthErrorType(Failure failure) {
    if (failure is NetworkFailure) return AuthErrorType.networkError;
    if (failure is ServerFailure) return AuthErrorType.serverError;
    if (failure is AuthFailure) return AuthErrorType.invalidCredentials;
    return AuthErrorType.unknown;
  }

  /// Manejador para logout usando Either
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Usar caso de uso con Either
    final result = await _logoutUseCase.call(NoParams());
    
    // Fold para manejar Left (error) o Right (éxito)
    result.fold(
      (failure) {
        emit(AuthError(
          message: failure.message,
          errorType: AuthErrorType.unknown,
        ));
      },
      (_) {
        emit(const AuthUnauthenticated(message: 'Sesión cerrada exitosamente'));
      },
    );
  }

  /// Manejador para verificar estado
  Future<void> _onAuthStatusCheckRequested(
    AuthStatusCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getAuthStatusUseCase.call(NoParams());
    
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (authStatus) {
        if (authStatus.isLoggedIn && authStatus.user != null) {
          emit(AuthAuthenticated(
            user: authStatus.user!,
            message: 'Usuario autenticado',
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Manejador para limpiar errores
  Future<void> _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getAuthStatusUseCase.call(NoParams());
    
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (authStatus) {
        if (authStatus.isLoggedIn && authStatus.user != null) {
          emit(AuthAuthenticated(
            user: authStatus.user!,
            message: 'Usuario autenticado',
          ));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Manejador para verificar permisos
  Future<void> _onAuthPermissionCheckRequested(
    AuthPermissionCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase.call(NoParams());
    
    result.fold(
      (_) => emit(AuthPermissionChecked(
        feature: event.feature,
        hasPermission: false,
        user: null,
      )),
      (user) {
        final hasPermission = user?.canAccessDagrdFeatures ?? false;
        emit(AuthPermissionChecked(
          feature: event.feature,
          hasPermission: hasPermission,
          user: user,
        ));
      },
    );
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