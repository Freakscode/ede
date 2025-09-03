import 'package:dio/dio.dart';
import '../../core/network/network_info.dart';
import '../../core/error/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../core/constants/app_constants.dart';

class DioClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  DioClient({
    required Dio dio,
    required NetworkInfo networkInfo,
  }) : _dio = dio, _networkInfo = networkInfo {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options = BaseOptions(
      connectTimeout: AppConstants.defaultTimeout,
      receiveTimeout: AppConstants.defaultTimeout,
      sendTimeout: AppConstants.defaultTimeout,
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => Logger.debug(object.toString(), 'DioClient'),
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check network connectivity before making request
          if (!await _networkInfo.isConnected) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: const NetworkException('No internet connection'),
              ),
            );
          }
          handler.next(options);
        },
        onError: (error, handler) {
          Logger.error(
            'Dio error: ${error.message}',
            error: error,
            name: 'DioClient',
          );
          handler.next(error);
        },
      ),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');
      
      case DioExceptionType.connectionError:
        return const NetworkException('Connection error');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return const ServerException('Server error');
        } else if (statusCode == 401) {
          return const AuthException('Unauthorized');
        } else {
          return ServerException('Bad response: ${error.message}');
        }
      
      case DioExceptionType.cancel:
        return const ServerException('Request cancelled');
      
      case DioExceptionType.badCertificate:
        return const NetworkException('Bad certificate');
      
      case DioExceptionType.unknown:
        return ServerException('Unknown error: ${error.message}');
    }
  }
}
