import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

// Data Sources
import '../data/datasources/local_database.dart';
import '../data/datasources/remote_api.dart';

// Repositories
import '../domain/repositories/repositories.dart';
import '../data/repositories/evaluacion_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/sync_repository_impl.dart';

// Use Cases
import '../domain/usecases/usecases.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await LocalDatabase.initDatabase();
  
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  serviceLocator.registerSingleton<Database>(database);
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());

  // Data Sources
  serviceLocator.registerLazySingleton<LocalDatabase>(
    () => LocalDatabase(serviceLocator<Database>())
  );
  
  serviceLocator.registerLazySingleton<RemoteApi>(
    () => RemoteApi(client: serviceLocator<http.Client>())
  );

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteApi: serviceLocator<RemoteApi>(),
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  serviceLocator.registerLazySingleton<EvaluacionRepository>(
    () => EvaluacionRepositoryImpl(
      localDatabase: serviceLocator<LocalDatabase>(),
      remoteApi: serviceLocator<RemoteApi>(),
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      localDatabase: serviceLocator<LocalDatabase>(),
      remoteApi: serviceLocator<RemoteApi>(),
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<SaveEvaluacionUseCase>(
    () => SaveEvaluacionUseCase(serviceLocator<EvaluacionRepository>()),
  );

  serviceLocator.registerLazySingleton<GetEvaluacionesUseCase>(
    () => GetEvaluacionesUseCase(serviceLocator<EvaluacionRepository>()),
  );

  serviceLocator.registerLazySingleton<SyncEvaluacionesUseCase>(
    () => SyncEvaluacionesUseCase(serviceLocator<SyncRepository>()),
  );

  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator<AuthRepository>()),
  );
}
