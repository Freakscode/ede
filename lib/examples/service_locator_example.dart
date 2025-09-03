// // Ejemplo de uso del Service Locator para inyección de dependencias

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'core/service_locator.dart';
// // import 'domain/repositories/repositories.dart';
// // import 'domain/usecases/usecases.dart';
// // import 'env/environment.dart';

// // Ejemplo de cómo inicializar el Service Locator en main.dart:

// /* 
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     // Cargar variables de entorno
//     await dotenv.load(fileName: Environment.fileName);
    
//     // Inicializar Service Locator
//     await setupServiceLocator();
    
//     runApp(MyApp());
//   } catch (e) {
//     print('Error during initialization: $e');
//     rethrow;
//   }
// }
// */

// // Ejemplo de cómo usar las dependencias en un Widget o BLoC:

// class EvaluacionService {
//   final SaveEvaluacionUseCase _saveEvaluacionUseCase;
//   final GetEvaluacionesUseCase _getEvaluacionesUseCase;
//   final SyncEvaluacionesUseCase _syncEvaluacionesUseCase;

//   EvaluacionService()
//       : _saveEvaluacionUseCase = serviceLocator<SaveEvaluacionUseCase>(),
//         _getEvaluacionesUseCase = serviceLocator<GetEvaluacionesUseCase>(),
//         _syncEvaluacionesUseCase = serviceLocator<SyncEvaluacionesUseCase>();

//   // Métodos de ejemplo
//   Future<void> saveEvaluacion(/* parametros */) async {
//     // await _saveEvaluacionUseCase.call(evaluacion);
//   }

//   Future<void> loadEvaluaciones() async {
//     // final evaluaciones = await _getEvaluacionesUseCase.call();
//   }

//   Future<void> syncData() async {
//     // await _syncEvaluacionesUseCase.call();
//   }
// }

// // Ejemplo de uso en un BLoC:

// class ExampleBloc {
//   final AuthRepository _authRepository;
//   final EvaluacionRepository _evaluacionRepository;

//   ExampleBloc()
//       : _authRepository = serviceLocator<AuthRepository>(),
//         _evaluacionRepository = serviceLocator<EvaluacionRepository>();

//   Future<void> login(String username, String password) async {
//     try {
//       final token = await _authRepository.login(username, password);
//       print('Login successful, token: $token');
//     } catch (e) {
//       print('Login failed: $e');
//     }
//   }
// }

// // Ejemplo de uso en un Widget:

// class ExampleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authRepository = serviceLocator<AuthRepository>();
    
//     return Scaffold(
//       appBar: AppBar(title: Text('Example')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               final isLoggedIn = await authRepository.isLoggedIn();
//               print('Is logged in: $isLoggedIn');
//             } catch (e) {
//               print('Error: $e');
//             }
//           },
//           child: Text('Check Login Status'),
//         ),
//       ),
//     );
//   }
// }
