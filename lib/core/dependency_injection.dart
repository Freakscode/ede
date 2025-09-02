import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// Data sources
import '../data/datasources/local_database.dart';
import '../data/datasources/remote_api.dart';
import '../data/datasources/secure_storage_service.dart';

// Repositories
import '../data/repositories/evaluacion_repository.dart';
import '../data/repositories/user_repository.dart';

// Use cases
import '../domain/usecases/save_evaluacion_usecase.dart';
import '../domain/usecases/get_evaluaciones_usecase.dart';
import '../domain/usecases/sync_evaluaciones_usecase.dart';
import '../domain/usecases/login_usecase.dart';

// BLoCs
import '../presentation/blocs/evaluacion_global/evaluacion_global_bloc.dart';

final GetIt sl = GetIt.instance; // sl = Service Locator

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<Dio>(
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    )),
  );

  // Database
  sl.registerSingletonAsync<Database>(() async {
    return await LocalDatabase.initDatabase();
  });

  // Wait for async singletons to be ready
  await sl.allReady();

  // Data sources
  sl.registerLazySingleton<LocalDatabase>(() => LocalDatabase(sl<Database>()));
  sl.registerLazySingleton<RemoteApi>(() => RemoteApi(sl<Dio>()));
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Repositories
  sl.registerLazySingleton<EvaluacionRepository>(
    () => EvaluacionRepository(
      localDatabase: sl<LocalDatabase>(),
      remoteApi: sl<RemoteApi>(),
      secureStorage: sl<SecureStorageService>(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(
      remoteApi: sl<RemoteApi>(),
      secureStorage: sl<SecureStorageService>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<SaveEvaluacionUseCase>(
    () => SaveEvaluacionUseCase(sl<EvaluacionRepository>()),
  );

  sl.registerLazySingleton<GetEvaluacionesUseCase>(
    () => GetEvaluacionesUseCase(sl<EvaluacionRepository>()),
  );

  sl.registerLazySingleton<SyncEvaluacionesUseCase>(
    () => SyncEvaluacionesUseCase(sl<EvaluacionRepository>()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<UserRepository>()),
  );

  // BLoCs - Factory instances (new instance each time)
  sl.registerFactory<EvaluacionGlobalBloc>(
    () => EvaluacionGlobalBloc(
      saveEvaluacionUseCase: sl<SaveEvaluacionUseCase>(),
      getEvaluacionesUseCase: sl<GetEvaluacionesUseCase>(),
      syncEvaluacionesUseCase: sl<SyncEvaluacionesUseCase>(),
    ),
  );
}

// Helper method to reset dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
