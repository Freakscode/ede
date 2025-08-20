// ignore_for_file: unused_import

import 'package:ede_final_app/env/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/form/evaluacion/evaluacion_bloc.dart' as form;
import 'presentation/blocs/evaluacion/evaluacion_bloc.dart';
import 'presentation/blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import 'presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import 'presentation/blocs/form/acciones/acciones_bloc.dart';
import 'presentation/blocs/evaluacion_global/evaluacion_global_bloc.dart';
import 'config/router/router_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/evaluacion_repository.dart';
import 'data/datasources/local_database_provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/repositories/data_repository.dart';
import 'presentation/blocs/users/users_bloc.dart';
import 'presentation/blocs/users/users_event.dart';
import 'presentation/pages/eval/eval_wrapper.dart';
import 'core/providers.dart';
import 'config/theme/app_theme.dart';
import 'presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    developer.log('Starting app initialization...', name: 'App');
    await dotenv.load(fileName: Environment.fileName);
    
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
          BlocProvider<form.EvaluacionBloc>(
            create: (context) => form.EvaluacionBloc(repository: evaluacionRepository),
          ),
          BlocProvider<EdificacionBloc>(
            create: (context) => EdificacionBloc(),
          ),
          BlocProvider<DescripcionEdificacionBloc>(
            create: (context) => DescripcionEdificacionBloc(),
          ),
          BlocProvider<RiesgosExternosBloc>(
            create: (context) => RiesgosExternosBloc(),
          ),
          BlocProvider<EvaluacionDanosBloc>(
            create: (context) => EvaluacionDanosBloc(),
          ),
          BlocProvider<NivelDanoBloc>(
            create: (context) => NivelDanoBloc(),
          ),
          BlocProvider<HabitabilidadBloc>(
            create: (context) => HabitabilidadBloc(),
          ),
          BlocProvider<AccionesBloc>(
            create: (context) => AccionesBloc(),
          ),
          BlocProvider<EvaluacionGlobalBloc>(
            create: (context) => EvaluacionGlobalBloc(
              evaluacionBloc: context.read<form.EvaluacionBloc>(),
              idEdificacionBloc: context.read<EdificacionBloc>(),
              riesgosExternosBloc: context.read<RiesgosExternosBloc>(),
              evaluacionDanosBloc: context.read<EvaluacionDanosBloc>(),
              nivelDanoBloc: context.read<NivelDanoBloc>(),
              habitabilidadBloc: context.read<HabitabilidadBloc>(),
              accionesBloc: context.read<AccionesBloc>(),
              descripcionEdificacionBloc: context.read<DescripcionEdificacionBloc>(),
            ),
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