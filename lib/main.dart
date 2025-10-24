// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'injection_container.dart' as di;
import 'app/core/utils/env.dart';
import 'app/core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Logger.info('Starting app initialization...', 'App');
    await dotenv.load(fileName: Environment.fileName);
    
    // Initialize dependencies
    await di.initializeDependencies();
    
    runApp(const MyApp());
  } catch (e) {
    Logger.error(
      'Error during initialization: $e',
      error: e,
      name: 'App',
    );
    rethrow;
  }
}