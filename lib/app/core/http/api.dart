
import 'package:caja_herramientas/app/core/http/app_interceptors.dart';
import 'package:caja_herramientas/injection_container.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  // final String _baseApiUrl = sl<Env>().theCatApi;
  late Dio dio;

  ApiProvider() {
    dio = Dio(BaseOptions(baseUrl: ''));
    dio.interceptors.add(AppInterceptors());
  }
}