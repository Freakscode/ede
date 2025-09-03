import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import '../../core/network/network_info.dart';
import '../../shared/infrastructure/dio_client.dart';

// Features  
import '../../features/auth/data/repositories_impl/auth_repository_implementation.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/evaluacion/data/repositories_impl/evaluacion_repository_impl.dart';
import '../../features/evaluacion/domain/repositories/evaluacion_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), networkInfo: sl()),
  );

  // Data sources
  // TODO: Register data sources here when moved

  // Repositories - now with correct interfaces and implementations
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<EvaluacionRepository>(
    () => EvaluacionRepositoryImpl(),
  );

  // Use cases
  // TODO: Register use cases here

  // BLoCs
  // BLoCs will be provided in the widget tree as needed
}
