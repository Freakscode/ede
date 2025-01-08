import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/evaluacion_model.dart';

class EvaluacionRepository {
  final SharedPreferences prefs;
  final Dio dio;
  final String baseUrl;

  EvaluacionRepository({
    required this.prefs,
    required this.dio,
    required this.baseUrl,
  });

  // Guardar evaluación localmente
  Future<void> guardarEvaluacion(EvaluacionModel evaluacion) async {
    final evaluacionJson = json.encode(evaluacion.toJson());
    await prefs.setString('evaluacion_${evaluacion.id}', evaluacionJson);
    
    // Guardar ID en lista de evaluaciones pendientes si no está sincronizada
    if (!evaluacion.sincronizado) {
      final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
      if (!pendientes.contains(evaluacion.id)) {
        pendientes.add(evaluacion.id!);
        await prefs.setStringList('evaluaciones_pendientes', pendientes);
      }
    }
  }

  // Obtener evaluación local
  Future<EvaluacionModel?> obtenerEvaluacion(String id) async {
    final evaluacionJson = prefs.getString('evaluacion_$id');
    if (evaluacionJson != null) {
      return EvaluacionModel.fromJson(json.decode(evaluacionJson));
    }
    return null;
  }

  // Sincronizar con el servidor
  Future<bool> sincronizarEvaluacion(EvaluacionModel evaluacion) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/evaluaciones/',
        data: evaluacion.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Actualizar estado local como sincronizado
        final Map<String, dynamic> datos = evaluacion.toJson();
        final evaluacionActualizada = EvaluacionModel(
          identificacionEvaluacion: datos['identificacionEvaluacion'],
          identificacionEdificacion: datos['identificacionEdificacion'],
          descripcionEdificacion: datos['descripcionEdificacion'],
          riesgosExternos: datos['riesgosExternos'],
          evaluacionDanos: datos['evaluacionDanos'],
          nivelDano: datos['nivelDano'],
          habitabilidad: datos['habitabilidad'],
          acciones: datos['acciones'],
          ultimaModificacion: evaluacion.ultimaModificacion,
          sincronizado: true,
          id: evaluacion.id,
        );
        await guardarEvaluacion(evaluacionActualizada);

        // Remover de la lista de pendientes
        final pendientes = prefs.getStringList('evaluaciones_pendientes') ?? [];
        pendientes.remove(evaluacion.id);
        await prefs.setStringList('evaluaciones_pendientes', pendientes);
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error al sincronizar: $e');
      return false;
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
} 