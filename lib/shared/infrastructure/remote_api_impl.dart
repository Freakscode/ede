import '../../shared/domain/services/remote_api_service.dart';
import '../data/models/evaluacion_model.dart';
import 'dio_client.dart';

class RemoteApiImpl implements RemoteApi {
  final DioClient _dioClient;

  RemoteApiImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dioClient.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
  }

  @override
  Future<List<EvaluacionModel>> getAllEvaluaciones() async {
    final response = await _dioClient.get('/evaluaciones');
    final List<dynamic> data = response.data;
    return data.map((json) => EvaluacionModel.fromJson(json)).toList();
  }

  @override
  Future<EvaluacionModel?> getEvaluacion(String id) async {
    try {
      final response = await _dioClient.get('/evaluaciones/$id');
      return EvaluacionModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<EvaluacionModel> createEvaluacion(EvaluacionModel evaluacion) async {
    final response = await _dioClient.post('/evaluaciones', data: evaluacion.toJson());
    return EvaluacionModel.fromJson(response.data);
  }

  @override
  Future<EvaluacionModel> updateEvaluacion(EvaluacionModel evaluacion) async {
    final response = await _dioClient.put('/evaluaciones/${evaluacion.id}', data: evaluacion.toJson());
    return EvaluacionModel.fromJson(response.data);
  }

  @override
  Future<bool> deleteEvaluacion(String id) async {
    try {
      await _dioClient.delete('/evaluaciones/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncEvaluaciones() async {
    await _dioClient.post('/evaluaciones/sync');
  }
}
