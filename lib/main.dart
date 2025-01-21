// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'config/router/router_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/evaluacion_repository.dart';
import 'data/datasources/local_database_provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/repositories/data_repository.dart';
import 'presentation/blocs/users/users_bloc.dart';
import 'presentation/blocs/users/users_event.dart';
import 'presentation/blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import 'presentation/pages/eval/eval_wrapper.dart';
import 'core/providers.dart';
import 'config/theme/app_theme.dart';
import 'presentation/blocs/evaluacion/evaluacion_bloc.dart';
import 'presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import 'presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    developer.log('Starting app initialization...', name: 'App');
    
    // Inicializar SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Inicializar Dio
    final dio = Dio();
    
    // Crear repositorios
    final evaluacionRepository = EvaluacionRepository(
      prefs: prefs,
      dio: dio,
      baseUrl: 'https://api.example.com', // Reemplazar con la URL real
    );

    final remoteDataSource = await RemoteDatasource.create();
    final authRepository = AuthRepository(
      remoteDatasource: remoteDataSource,
    );

    runApp(MyApp(
      evaluacionRepository: evaluacionRepository,
      authRepository: authRepository,
    ));
  } catch (e) {
    developer.log('Error during initialization: $e', name: 'App', error: e);
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final EvaluacionRepository evaluacionRepository;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.evaluacionRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: evaluacionRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          ...getGlobalProviders(evaluacionRepository, authRepository),
          BlocProvider<RiesgosExternosBloc>(
            create: (context) => RiesgosExternosBloc(),
          ),
          BlocProvider<EvaluacionDanosBloc>(
            create: (context) => EvaluacionDanosBloc(),
          ),
          BlocProvider<NivelDanoBloc>(
            create: (context) => NivelDanoBloc(),
          ),
        ],
        child: Builder(
          builder: (context) => MaterialApp.router(
            title: 'EDE App',
            theme: AppTheme.theme,
            routerConfig: getAppRouter(context),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}