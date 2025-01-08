// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'config/router/router_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/datasources/local_database_provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/repositories/data_repository.dart';
import 'presentation/blocs/users/users_bloc.dart';
import 'presentation/blocs/users/users_event.dart';
import 'presentation/blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import 'presentation/pages/eval/eval_wrapper.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    developer.log('Starting app initialization...', name: 'App');
    
    // 1. Open local DB
    developer.log('Opening local database...', name: 'App');
    final database = await LocalDatabaseProvider.open();
    
    // 2. Create data sources
    developer.log('Creating data sources...', name: 'App');
    final localDataSource = LocalDataSource(database);
    final remoteDataSource = await RemoteDatasource.create();
    
    // 3. Create repositories
    developer.log('Creating repositories...', name: 'App');
    final authRepository = AuthRepository(
      remoteDatasource: remoteDataSource,
    );

    final dataRepository = DataRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    developer.log('App initialization complete', name: 'App');
    
    runApp(
      MultiBlocProvider(
        providers: globalProviders,
        child: MainApp(
          dataRepository: dataRepository,
          authRepository: authRepository,
        ),
      ),
    );
  } catch (e, stackTrace) {
    developer.log(
      'Failed to initialize app',
      name: 'App',
      error: e,
      stackTrace: stackTrace
    );
    rethrow;
  }
}

class MainApp extends StatelessWidget {
  final DataRepository dataRepository;
  final AuthRepository authRepository;
  
  const MainApp({
    super.key,
    required this.dataRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return EvalWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
          ),
          BlocProvider<UsersBloc>(
            create: (_) => UsersBloc(repository: dataRepository),
          ),
        ],
        child: Builder(
          builder: (context) => MaterialApp.router(
            routerConfig: getAppRouter(context),
          ),
        ),
      ),
    );
  }
}