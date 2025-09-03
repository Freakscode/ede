import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
import '../../shared/infrastructure/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  Logger.info('Setting up dependency injection...');

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: getIt<Connectivity>()),
  );

  // Infrastructure
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      dio: getIt<Dio>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Features will be registered here
  await _setupAuthFeature();
  await _setupEvaluacionFeature();
  await _setupUsersFeature();
  await _setupHabitabilidadFeature();

  Logger.info('Dependency injection setup completed');
}

Future<void> _setupAuthFeature() async {
  // Auth feature dependencies will be registered here
  // This will be implemented when we move the auth files
}

Future<void> _setupEvaluacionFeature() async {
  // Evaluacion feature dependencies will be registered here
}

Future<void> _setupUsersFeature() async {
  // Users feature dependencies will be registered here
}

Future<void> _setupHabitabilidadFeature() async {
  // Habitabilidad feature dependencies will be registered here
}
