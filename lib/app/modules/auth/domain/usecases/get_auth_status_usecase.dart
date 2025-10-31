import 'package:dartz/dartz.dart';
import 'package:caja_herramientas/app/core/usecases/usecase.dart';
import 'package:caja_herramientas/app/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

/// Parámetros para el caso de uso de estado de autenticación
class AuthStatusParams {
  final bool isLoggedIn;
  final UserEntity? user;

  const AuthStatusParams({
    required this.isLoggedIn,
    this.user,
  });
}

/// Caso de uso para obtener el estado de autenticación
class GetAuthStatusUseCase implements UseCase<AuthStatusParams, NoParams> {
  final IAuthRepository _authRepository;

  GetAuthStatusUseCase(this._authRepository);

  @override
  Future<Either<Failure, AuthStatusParams>> call(NoParams params) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      UserEntity? user;
      
      if (isLoggedIn) {
        user = await _authRepository.getCurrentUser();
      }
      
      return Right(AuthStatusParams(
        isLoggedIn: isLoggedIn,
        user: user,
      ));
    } catch (e) {
      return Left(CacheFailure('Error al verificar estado de autenticación: ${e.toString()}'));
    }
  }
}

