import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

// Data sources
import '../data/datasources/local_database.dart';
import '../data/datasources/remote_api.dart';
import '../data/datasources/secure_storage_service.dart';

// Repositories
import '../domain/repositories/repositories.dart';
import '../data/repositories/evaluacion_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/sync_repository_impl.dart';

// Use cases
import '../domain/usecases/usecases.dart';

final GetIt sl = GetIt.instance; // sl = Service Locator

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await LocalDatabase.initDatabase();
  
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<Database>(database);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  sl.registerLazySingleton<LocalDatabase>(
    () => LocalDatabase(sl<Database>())
  );
  
  sl.registerLazySingleton<RemoteApi>(
    () => RemoteApi(client: sl<http.Client>())
  );
  
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteApi: sl<RemoteApi>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<EvaluacionRepository>(
    () => EvaluacionRepositoryImpl(
      localDatabase: sl<LocalDatabase>(),
      remoteApi: sl<RemoteApi>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      localDatabase: sl<LocalDatabase>(),
      remoteApi: sl<RemoteApi>(),
      authRepository: sl<AuthRepository>(),
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
    () => SyncEvaluacionesUseCase(sl<SyncRepository>()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );

  // Note: EvaluacionGlobalBloc requires many BLoC dependencies
  // It should be created manually in the UI layer with all required BLoCs
}

// Helper method to reset dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
