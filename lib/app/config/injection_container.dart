import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import '../core/network/network_info.dart';

// Features - Auth
import '../modules/auth/data/repositories_impl/auth_repository_implementation.dart';
import '../modules/auth/domain/repositories/auth_repository.dart';
import '../modules/auth/presentation/bloc/auth_bloc.dart';

// Features - Evaluacion
import '../modules/evaluacion/data/repositories_impl/evaluacion_repository_impl.dart';
import '../modules/evaluacion/domain/repositories/evaluacion_repository.dart';
import '../modules/evaluacion/presentation/bloc/form/evaluacion/evaluacion_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/nivelDano/nivel_dano_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/habitabilidad/habitabilidad_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/acciones/acciones_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../modules/evaluacion/presentation/bloc/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';

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
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => EvaluacionBloc(repository: sl()));
  sl.registerFactory(() => EdificacionBloc());
  sl.registerFactory(() => RiesgosExternosBloc());
  sl.registerFactory(() => NivelDanoBloc());
  sl.registerFactory(() => HabitabilidadBloc());
  sl.registerFactory(() => AccionesBloc());
  sl.registerFactory(() => EvaluacionDanosBloc());
  sl.registerFactory(() => DescripcionEdificacionBloc());
  
  // Note: EvaluacionGlobalBloc is created directly in MultiBlocProvider 
  // since it requires access to other BLoC instances from context
}
