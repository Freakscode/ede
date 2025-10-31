import 'package:caja_herramientas/injection_container.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  late Dio dio;

  ApiProvider() {
    // Usa el Dio configurado con interceptores del contenedor de DI
    dio = sl<Dio>();
  }
}