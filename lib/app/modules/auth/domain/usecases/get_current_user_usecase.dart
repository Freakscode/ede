import 'package:dartz/dartz.dart';
import 'package:caja_herramientas/app/core/usecases/usecase.dart';
import 'package:caja_herramientas/app/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

/// Caso de uso para obtener el usuario actual
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final IAuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    try {
      final user = await _authRepository.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Error al obtener usuario: ${e.toString()}'));
    }
  }
}

