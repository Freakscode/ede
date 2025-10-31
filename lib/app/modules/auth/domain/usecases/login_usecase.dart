import 'package:dartz/dartz.dart';
import 'package:caja_herramientas/app/core/usecases/usecase.dart';
import 'package:caja_herramientas/app/core/error/failures.dart';
import '../entities/auth_result_entity.dart';
import '../entities/login_params.dart';
import '../repositories/auth_repository_interface.dart';

/// Caso de uso para login con Either para manejo de errores
class LoginUseCase implements UseCase<AuthResultEntity, LoginParams> {
  final IAuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<Either<Failure, AuthResultEntity>> call(LoginParams params) async {
    // Validaciones de negocio
    if (params.email.isEmpty) {
      return Left(ValidationFailure('El email es requerido'));
    }

    if (params.password.isEmpty) {
      return Left(ValidationFailure('La contraseña es requerida'));
    }

    if (!params.hasValidEmailFormat) {
      return Left(ValidationFailure('El formato del email no es válido'));
    }

    try {
      // Delegar al repositorio
      final result = await _authRepository.login(params);
      
      // Convertir resultado a Either
      if (result.isSuccess) {
        return Right(result);
      } else {
        // Mapear AuthErrorType a Failure
        switch (result.errorType) {
          case AuthErrorType.networkError:
            return Left(NetworkFailure(result.message));
          case AuthErrorType.serverError:
            return Left(ServerFailure(result.message));
          case AuthErrorType.invalidCredentials:
            return Left(AuthFailure(result.message));
          default:
            return Left(ValidationFailure(result.message));
        }
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }

  /// Método legacy para compatibilidad
  @Deprecated('Usar call() con Either')
  Future<AuthResultEntity> execute(LoginParams loginParams) async {
    final either = await call(loginParams);
    return either.fold(
      (failure) => AuthResultEntity.failure(
        message: failure.message,
        errorType: _failureToAuthErrorType(failure),
      ),
      (result) => result,
    );
  }

  /// Ejecutar login con credenciales directas
  Future<Either<Failure, AuthResultEntity>> executeWithCredentials({
    required String email,
    required String password,
  }) async {
    final loginParams = LoginParams.fromCredentials(
      email: email,
      password: password,
    );
    return await call(loginParams);
  }

  /// Convertir Failure a AuthErrorType
  AuthErrorType _failureToAuthErrorType(Failure failure) {
    if (failure is NetworkFailure) return AuthErrorType.networkError;
    if (failure is ServerFailure) return AuthErrorType.serverError;
    if (failure is AuthFailure) return AuthErrorType.invalidCredentials;
    return AuthErrorType.unknown;
  }
}