import '../entities/evaluacion_entity.dart';
import '../repositories/repositories.dart';

class SaveEvaluacionUseCase {
  final EvaluacionRepository repository;

  SaveEvaluacionUseCase(this.repository);

  Future<void> call(EvaluacionEntity evaluacion) async {
    await repository.saveEvaluacion(evaluacion);
  }
}

class GetEvaluacionesUseCase {
  final EvaluacionRepository repository;

  GetEvaluacionesUseCase(this.repository);

  Future<List<EvaluacionEntity>> call() async {
    return await repository.getAllEvaluaciones();
  }
}

class SyncEvaluacionesUseCase {
  final SyncRepository repository;

  SyncEvaluacionesUseCase(this.repository);

  Future<void> call() async {
    await repository.syncAllData();
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
