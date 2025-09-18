import 'package:caja_herramientas/app/core/database/database_config.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import 'app/core/network/network_info.dart';

// Features - Auth
import 'app/modules/auth/data/repositories_impl/auth_repository_implementation.dart';
import 'app/modules/auth/domain/repositories/auth_repository.dart';

// Features - Evaluacion
import 'app/modules/evaluacion/data/repositories_impl/evaluacion_repository_impl.dart';
import 'app/modules/evaluacion/domain/repositories/evaluacion_repository.dart';
import 'app/modules/evaluacion/presentation/bloc/form/evaluacion/evaluacion_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/nivelDano/nivel_dano_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/habitabilidad/habitabilidad_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/acciones/acciones_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'app/modules/evaluacion/presentation/bloc/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';

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

  // BLoCs
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

  await Hive.initFlutter();

  await Hive.openBox(DatabaseConfig.tutorialHomeKey);




}
