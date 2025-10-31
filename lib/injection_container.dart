import 'package:caja_herramientas/app/core/database/database_config.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import 'app/core/network/network_info.dart';
import 'app/core/http/app_interceptors.dart';
import 'app/core/utils/env.dart';

// Features - Auth
import 'app/modules/auth/data/repositories_impl/auth_repository_implementation.dart';
import 'app/modules/auth/domain/repositories/auth_repository_interface.dart';
import 'app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'app/modules/auth/data/datasources/auth_remote_data_source.dart';

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

// Risk Threat Analysis
import 'app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/save_risk_analysis_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/load_risk_analysis_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/validate_form_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/calculate_rating_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/calculate_score_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/validate_unqualified_variables_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/use_cases/calculate_global_score_usecase.dart';
import 'app/modules/risk_threat_analysis/domain/repositories/risk_analysis_repository_interface.dart';
import 'app/modules/risk_threat_analysis/data/repositories/risk_analysis_repository_implementation.dart';

// Home Module - Clean Architecture
import 'app/modules/home/domain/repositories/home_repository_interface.dart';
import 'app/modules/home/data/repositories/home_repository_implementation.dart';
import 'app/modules/home/domain/use_cases/get_home_state_usecase.dart';
import 'app/modules/home/domain/use_cases/update_home_state_usecase.dart';
import 'app/modules/home/domain/use_cases/manage_forms_usecase.dart';
import 'app/modules/home/domain/use_cases/manage_tutorial_usecase.dart';
import 'app/modules/home/presentation/bloc/home_bloc.dart';

import 'app/shared/services/form_persistence_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // Initialize Hive
  await Hive.initFlutter();
  
  // Open Hive boxes
  await Hive.openBox(DatabaseConfig.authStorageBox);
  await Hive.openBox(DatabaseConfig.tutorialHomeKey);

  // Data sources
  // Auth Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  
  // HTTP Client con interceptores
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
      ),
    );
    dio.interceptors.add(
      AppInterceptors(authLocalDataSource: sl<AuthLocalDataSource>()),
    );
    return dio;
  });
  
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

  // Services
  sl.registerLazySingleton(() => FormPersistenceService());

  // Repositories - now with correct interfaces and implementations
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImplementation(
      authLocalDataSource: sl(),
      authRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<EvaluacionRepository>(
    () => EvaluacionRepositoryImpl(),
  );

  // Home Repository
  sl.registerLazySingleton<HomeRepositoryInterface>(
    () => HomeRepositoryImplementation(
      prefs: sl(),
      formPersistenceService: sl(),
    ),
  );

  // Risk Threat Analysis Repository
  sl.registerLazySingleton<RiskAnalysisRepositoryInterface>(
    () => RiskAnalysisRepositoryImplementation(prefs: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetHomeStateUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHomeStateUseCase(sl()));
  sl.registerLazySingleton(() => ManageFormsUseCase(sl()));
  sl.registerLazySingleton(() => ManageTutorialUseCase(sl()));
  
  // Risk Threat Analysis Use Cases
  sl.registerLazySingleton(() => SaveRiskAnalysisUseCase(sl()));
  sl.registerLazySingleton(() => LoadRiskAnalysisUseCase(sl()));
  sl.registerLazySingleton(() => ValidateFormUseCase(sl()));
  sl.registerLazySingleton(() => CalculateRatingUseCase(sl()));
  sl.registerLazySingleton(() => CalculateScoreUseCase(sl()));
  sl.registerLazySingleton(() => ValidateUnqualifiedVariablesUseCase());
  sl.registerLazySingleton(() => CalculateGlobalScoreUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => EvaluacionBloc(repository: sl()));
  sl.registerFactory(() => EdificacionBloc());
  sl.registerFactory(() => RiesgosExternosBloc());
  sl.registerFactory(() => NivelDanoBloc());
  sl.registerFactory(() => HabitabilidadBloc());
  sl.registerFactory(() => AccionesBloc());
  sl.registerFactory(() => EvaluacionDanosBloc());
  sl.registerFactory(() => DescripcionEdificacionBloc());
  sl.registerFactory(() => RiskThreatAnalysisBloc(
    saveRiskAnalysisUseCase: sl(),
    loadRiskAnalysisUseCase: sl(),
    validateUnqualifiedVariablesUseCase: sl(),
    calculateGlobalScoreUseCase: sl(),
  ));
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  
  // Home BLoC with Clean Architecture
  sl.registerFactory(() => HomeBloc(
    getHomeStateUseCase: sl(),
    updateHomeStateUseCase: sl(),
    manageFormsUseCase: sl(),
    manageTutorialUseCase: sl(),
  ));
  
  // Note: EvaluacionGlobalBloc is created directly in MultiBlocProvider 
  // since it requires access to other BLoC instances from context
}
