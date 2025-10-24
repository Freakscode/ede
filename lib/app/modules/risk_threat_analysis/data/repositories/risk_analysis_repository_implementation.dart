import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/risk_analysis_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/risk_analysis_repository_interface.dart';
import '../models/risk_analysis_model.dart';
import '../models/form_data_model.dart';
import '../models/rating_data_model.dart';

/// Implementación del repositorio RiskAnalysis
/// Maneja la persistencia de datos usando SharedPreferences
class RiskAnalysisRepositoryImplementation implements RiskAnalysisRepositoryInterface {
  final SharedPreferences _prefs;

  const RiskAnalysisRepositoryImplementation({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  // ========== RISK ANALYSIS ==========

  @override
  Future<void> saveRiskAnalysis(RiskAnalysisEntity entity) async {
    try {
      final model = RiskAnalysisModel.fromEntity(entity);
      final key = 'risk_analysis_${entity.eventName}_${entity.classificationType}';
      final json = jsonEncode(model.toJson());
      await _prefs.setString(key, json);
    } catch (e) {
      throw Exception('Error al guardar análisis de riesgo: $e');
    }
  }

  @override
  Future<RiskAnalysisEntity?> loadRiskAnalysis(String eventName, String classificationType) async {
    try {
      final key = 'risk_analysis_${eventName}_${classificationType}';
      final json = _prefs.getString(key);
      
      if (json != null) {
        final data = jsonDecode(json);
        final model = RiskAnalysisModel.fromJson(data);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      throw Exception('Error al cargar análisis de riesgo: $e');
    }
  }

  @override
  Future<void> deleteRiskAnalysis(String eventName, String classificationType) async {
    try {
      final key = 'risk_analysis_${eventName}_${classificationType}';
      await _prefs.remove(key);
    } catch (e) {
      throw Exception('Error al eliminar análisis de riesgo: $e');
    }
  }

  @override
  Future<List<RiskAnalysisEntity>> getAllRiskAnalyses() async {
    try {
      final keys = _prefs.getKeys().where((key) => key.startsWith('risk_analysis_'));
      final List<RiskAnalysisEntity> analyses = [];
      
      for (final key in keys) {
        final json = _prefs.getString(key);
        if (json != null) {
          final data = jsonDecode(json);
          final model = RiskAnalysisModel.fromJson(data);
          analyses.add(model.toEntity());
        }
      }
      
      return analyses;
    } catch (e) {
      throw Exception('Error al cargar todos los análisis: $e');
    }
  }

  @override
  Future<bool> riskAnalysisExists(String eventName, String classificationType) async {
    try {
      final key = 'risk_analysis_${eventName}_${classificationType}';
      return _prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  // ========== FORM DATA ==========

  @override
  Future<void> saveFormData(FormEntity entity) async {
    try {
      final model = FormDataModel.fromEntity(entity);
      final key = 'form_data_${entity.eventName}_${entity.classificationType}';
      final json = jsonEncode(model.toJson());
      await _prefs.setString(key, json);
    } catch (e) {
      throw Exception('Error al guardar datos de formulario: $e');
    }
  }

  @override
  Future<FormEntity?> loadFormData(String eventName, String classificationType) async {
    try {
      final key = 'form_data_${eventName}_${classificationType}';
      final json = _prefs.getString(key);
      
      if (json != null) {
        final data = jsonDecode(json);
        final model = FormDataModel.fromJson(data);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      throw Exception('Error al cargar datos de formulario: $e');
    }
  }

  @override
  bool validateFormData(FormEntity entity) {
    return entity.isValid;
  }

  @override
  Future<void> clearFormData(String eventName, String classificationType) async {
    try {
      final key = 'form_data_${eventName}_${classificationType}';
      await _prefs.remove(key);
    } catch (e) {
      throw Exception('Error al limpiar datos de formulario: $e');
    }
  }

  @override
  Future<List<FormEntity>> getAllFormData() async {
    try {
      final keys = _prefs.getKeys().where((key) => key.startsWith('form_data_'));
      final List<FormEntity> forms = [];
      
      for (final key in keys) {
        final json = _prefs.getString(key);
        if (json != null) {
          final data = jsonDecode(json);
          final model = FormDataModel.fromJson(data);
          forms.add(model.toEntity());
        }
      }
      
      return forms;
    } catch (e) {
      throw Exception('Error al cargar todos los formularios: $e');
    }
  }

  @override
  Future<bool> formDataExists(String eventName, String classificationType) async {
    try {
      final key = 'form_data_${eventName}_${classificationType}';
      return _prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  // ========== RATING DATA ==========

  @override
  Future<void> saveRatingData(RatingEntity entity) async {
    try {
      final model = RatingDataModel.fromEntity(entity);
      final key = 'rating_data_${entity.category}_${entity.subClassificationId}';
      final json = jsonEncode(model.toJson());
      await _prefs.setString(key, json);
    } catch (e) {
      throw Exception('Error al guardar datos de calificación: $e');
    }
  }

  @override
  Future<RatingEntity?> loadRatingData(String category, String subClassificationId) async {
    try {
      final key = 'rating_data_${category}_${subClassificationId}';
      final json = _prefs.getString(key);
      
      if (json != null) {
        final data = jsonDecode(json);
        final model = RatingDataModel.fromJson(data);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      throw Exception('Error al cargar datos de calificación: $e');
    }
  }

  @override
  Future<List<RatingEntity>> getAllRatingData() async {
    try {
      final keys = _prefs.getKeys().where((key) => key.startsWith('rating_data_'));
      final List<RatingEntity> ratings = [];
      
      for (final key in keys) {
        final json = _prefs.getString(key);
        if (json != null) {
          final data = jsonDecode(json);
          final model = RatingDataModel.fromJson(data);
          ratings.add(model.toEntity());
        }
      }
      
      return ratings;
    } catch (e) {
      throw Exception('Error al cargar todas las calificaciones: $e');
    }
  }

  // ========== UTILITIES ==========

  @override
  Future<void> clearAllData() async {
    try {
      final keys = _prefs.getKeys().where((key) => 
          key.startsWith('risk_analysis_') || 
          key.startsWith('form_data_') || 
          key.startsWith('rating_data_'));
      
      for (final key in keys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      throw Exception('Error al limpiar todos los datos: $e');
    }
  }

  @override
  Future<bool> isConnected() async {
    // Implementar lógica de conectividad si es necesario
    return true;
  }

  @override
  Future<void> syncData() async {
    // Implementar lógica de sincronización si hay backend
    // Por ahora no hay backend, así que no hace nada
  }
}
