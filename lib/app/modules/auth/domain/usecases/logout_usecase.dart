import 'package:dartz/dartz.dart';
import 'package:caja_herramientas/app/core/usecases/usecase.dart';
import 'package:caja_herramientas/app/core/error/failures.dart';
import '../repositories/auth_repository_interface.dart';

/// Caso de uso para logout
/// No requiere parámetros, solo ejecuta la acción de logout
class LogoutUseCase implements UseCase<void, NoParams> {
  final IAuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      // Delegar al repositorio
      await _authRepository.logout();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al cerrar sesión: ${e.toString()}'));
    }
  }
}

