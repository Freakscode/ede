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


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Open the local DB
    final database = await LocalDatabaseProvider.open();

    // 2. Create data sources with retry
    final localDataSource = LocalDataSource(database);
    final remoteDataSource = await RemoteDatasource.create();

    // 3. Create repositories
    final authRepository = AuthRepository(
      remoteDatasource: remoteDataSource,
    );

    final dataRepository = DataRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    // 4. Run app
    runApp(
      MainApp(
        dataRepository: dataRepository,
        authRepository: authRepository,
      ),
    );
  } catch (e) {
    developer.log('Failed to initialize app: $e', error: e);
    // Handle startup errors appropriately
    rethrow;
  }
}

class MainApp extends StatelessWidget {
  final DataRepository dataRepository;
  final AuthRepository authRepository;
  const MainApp({super.key,
    required this.dataRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authBloc = AuthBloc(
          authRepository: authRepository,
        );
        // Check auth state on app start
        authBloc.add(AppStarted());
        return authBloc;
      },
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: getAppRouter(context),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}