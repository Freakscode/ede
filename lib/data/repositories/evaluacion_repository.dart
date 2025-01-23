import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:retry/retry.dart';
import '../../domain/models/evaluacion_model.dart';

class EvaluacionRepository {
  final SharedPreferences prefs;
  final Dio dio;
  final String baseUrl;
  static const timeout = Duration(seconds: 30);
  static const String FIRMA_KEY = 'firma_evaluador';
  static const String FIRMA_DEFAULT_KEY = 'firma_default';

  EvaluacionRepository({
    required this.prefs,
    required this.dio,
    required this.baseUrl,
  }) {
    dio.options.connectTimeout = timeout;
  }

  Future<bool> _verificarConexion() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Guardar evaluación localmente
  Future<void> guardarEvaluacion(EvaluacionModel evaluacion) async {
    try {
      final evaluacionJson = json.encode(evaluacion.toJson());
      await prefs.setString('evaluacion_${evaluacion.id}', evaluacionJson);
      
      if (!evaluacion.sincronizado) {
        final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
        if (!pendientes.contains(evaluacion.id)) {
          pendientes.add(evaluacion.id!);
          await prefs.setStringList('evaluaciones_pendientes', pendientes);
        }
      }
    } catch (e) {
      throw Exception('Error al guardar la evaluación: $e');
    }
  }

  // Obtener todas las evaluaciones
  Future<List<EvaluacionModel>> obtenerTodasLasEvaluaciones() async {
    try {
      final evaluaciones = <EvaluacionModel>[];
      for (String key in prefs.getKeys()) {
        if (key.startsWith('evaluacion_')) {
          final json = prefs.getString(key);
          if (json != null) {
            evaluaciones.add(EvaluacionModel.fromJson(jsonDecode(json)));
          }
        }
      }
      return evaluaciones;
    } catch (e) {
      throw Exception('Error al obtener las evaluaciones: $e');
    }
  }

  // Eliminar evaluación
  Future<void> eliminarEvaluacion(String id) async {
    try {
      await prefs.remove('evaluacion_$id');
      final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
      pendientes.remove(id);
      await prefs.setStringList('evaluaciones_pendientes', pendientes);
    } catch (e) {
      throw Exception('Error al eliminar la evaluación: $e');
    }
  }

  // Limpiar datos antiguos
  Future<void> limpiarDatosAntiguos() async {
    try {
      final evaluaciones = await obtenerTodasLasEvaluaciones();
      final ahora = DateTime.now();
      for (final evaluacion in evaluaciones) {
        if (evaluacion.ultimaModificacion != null &&
            ahora.difference(evaluacion.ultimaModificacion!) > const Duration(days: 30)) {
          await eliminarEvaluacion(evaluacion.id!);
        }
      }
    } catch (e) {
      throw Exception('Error al limpiar datos antiguos: $e');
    }
  }

  // Sincronizar con el servidor
  Future<bool> sincronizarEvaluacion(EvaluacionModel evaluacion) async {
    if (!await _verificarConexion()) {
      throw Exception('No hay conexión a internet');
    }

    final retry = const RetryOptions(maxAttempts: 3);
    return retry.retry(
      () => _intentarSincronizacion(evaluacion),
      retryIf: (e) => e is DioException && e.type == DioExceptionType.connectionTimeout,
    );
  }

  Future<bool> _intentarSincronizacion(EvaluacionModel evaluacion) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/evaluaciones/',
        data: evaluacion.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final remota = EvaluacionModel.fromJson(response.data);
        if (await _manejarConflicto(evaluacion, remota)) {
          await _actualizarEvaluacionLocal(evaluacion.copyWith(sincronizado: true));
        } else {
          await _actualizarEvaluacionLocal(remota);
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Error al sincronizar: $e');
    }
  }

  Future<bool> _manejarConflicto(EvaluacionModel local, EvaluacionModel remota) async {
    if (local.ultimaModificacion == null || remota.ultimaModificacion == null) {
      return true;
    }
    return local.ultimaModificacion!.isAfter(remota.ultimaModificacion!);
  }

  Future<void> _actualizarEvaluacionLocal(EvaluacionModel evaluacion) async {
    await guardarEvaluacion(evaluacion);
    if (evaluacion.sincronizado) {
      final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
      pendientes.remove(evaluacion.id);
      await prefs.setStringList('evaluaciones_pendientes', pendientes);
    }
  }

  // Sincronizar todas las evaluaciones pendientes
  Future<void> sincronizarPendientes() async {
    final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
    for (final id in pendientes) {
      final evaluacion = await obtenerEvaluacion(id);
      if (evaluacion != null) {
        await sincronizarEvaluacion(evaluacion);
      }
    }
  }

  // Obtener evaluación por ID
  Future<EvaluacionModel?> obtenerEvaluacion(String id) async {
    try {
      final evaluacionJson = prefs.getString('evaluacion_$id');
      if (evaluacionJson != null) {
        return EvaluacionModel.fromJson(json.decode(evaluacionJson));
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener la evaluación: $e');
    }
  }

  // Guardar firma del evaluador
  Future<void> guardarFirmaEvaluador(String firmaPath) async {
    try {
      await prefs.setString(FIRMA_KEY, firmaPath);
    } catch (e) {
      throw Exception('Error al guardar la firma: $e');
    }
  }

  // Obtener firma del evaluador
  String? obtenerFirmaEvaluador() {
    try {
      return prefs.getString(FIRMA_KEY);
    } catch (e) {
      throw Exception('Error al obtener la firma: $e');
    }
  }

  Future<void> eliminarFirmaEvaluador() async {
    await prefs.remove(FIRMA_KEY);
  }
} 