import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../../domain/entities/tutorial_entity.dart';
import '../../domain/repositories/home_repository_interface.dart';
import '../models/home_model.dart';
import '../models/tutorial_model.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/core/database/database_config.dart';

/// Implementación del repositorio Home
/// Maneja la persistencia de datos usando SharedPreferences, Hive y SQLite
class HomeRepositoryImplementation implements HomeRepositoryInterface {
  final SharedPreferences _prefs;
  final FormPersistenceService _formPersistenceService;

  const HomeRepositoryImplementation({
    required SharedPreferences prefs,
    required FormPersistenceService formPersistenceService,
  }) : _prefs = prefs,
       _formPersistenceService = formPersistenceService;

  // ========== HOME STATE ==========

  @override
  Future<HomeEntity> getHomeState() async {
    try {
      final homeJson = _prefs.getString('home_state');
      
      if (homeJson != null) {
        final homeData = jsonDecode(homeJson);
        final model = HomeModel.fromJson(homeData);
        return model.toEntity();
      }
      
      return HomeEntity.initial();
    } catch (e) {
      return HomeEntity.initial();
    }
  }

  @override
  Future<void> updateHomeState(HomeEntity homeState) async {
    try {
      final model = HomeModel.fromEntity(homeState);
      final homeJson = jsonEncode(model.toJson());
      await _prefs.setString('home_state', homeJson);
    } catch (e) {
      throw Exception('Error al actualizar estado del home: $e');
    }
  }

  // ========== FORMS ==========

  @override
  Future<List<FormEntity>> getSavedForms() async {
    try {
      final completeForms = await _formPersistenceService.getAllCompleteForms();
      
      return completeForms.map((completeForm) {
        return FormEntity(
          id: completeForm.id,
          eventName: completeForm.eventName,
          status: completeForm.isExplicitlyCompleted 
              ? FormStatus.completed 
              : FormStatus.inProgress,
          createdAt: completeForm.createdAt,
          lastModified: completeForm.updatedAt,
          data: completeForm.toJson(),
          isExplicitlyCompleted: completeForm.isExplicitlyCompleted,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveForm(FormEntity form) async {
    try {
      // Convertir FormEntity a CompleteFormDataModel para SQLite
      final completeForm = CompleteFormDataModel(
        id: form.id,
        eventName: form.eventName,
        amenazaSelections: const {},
        amenazaScores: const {},
        amenazaColors: const {},
        amenazaProbabilidadSelections: const {},
        amenazaIntensidadSelections: const {},
        vulnerabilidadSelections: const {},
        vulnerabilidadScores: const {},
        vulnerabilidadColors: const {},
        vulnerabilidadProbabilidadSelections: const {},
        vulnerabilidadIntensidadSelections: const {},
        evidenceImages: const {},
        evidenceCoordinates: const {},
        contactData: const {},
        inspectionData: const {},
        createdAt: form.createdAt,
        updatedAt: form.lastModified,
        isExplicitlyCompleted: form.isExplicitlyCompleted,
      );
      
      await _formPersistenceService.saveCompleteForm(completeForm);
    } catch (e) {
      throw Exception('Error al guardar formulario: $e');
    }
  }

  @override
  Future<void> deleteForm(String formId) async {
    try {
      await _formPersistenceService.deleteForm(formId);
    } catch (e) {
      throw Exception('Error al eliminar formulario: $e');
    }
  }

  @override
  Future<FormEntity?> getFormById(String formId) async {
    try {
      final completeForm = await _formPersistenceService.getCompleteForm(formId);
      
      if (completeForm == null) {
        return null;
      }
      
      return FormEntity(
        id: completeForm.id,
        eventName: completeForm.eventName,
        status: completeForm.isExplicitlyCompleted 
            ? FormStatus.completed 
            : FormStatus.inProgress,
        createdAt: completeForm.createdAt,
        lastModified: completeForm.updatedAt,
        data: completeForm.toJson(),
        isExplicitlyCompleted: completeForm.isExplicitlyCompleted,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<FormEntity>> getFormsByStatus(FormStatus status) async {
    try {
      final allForms = await getSavedForms();
      return allForms.where((form) => form.status == status).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> setActiveFormId(String? formId) async {
    try {
      await _formPersistenceService.setActiveFormId(formId);
    } catch (e) {
      throw Exception('Error al establecer formulario activo: $e');
    }
  }

  @override
  Future<String?> getActiveFormId() async {
    try {
      return await _formPersistenceService.getActiveFormId();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearActiveFormId() async {
    try {
      await _formPersistenceService.setActiveFormId(null);
    } catch (e) {
      throw Exception('Error al limpiar formulario activo: $e');
    }
  }

  // ========== TUTORIAL ==========

  @override
  Future<TutorialEntity> getTutorialConfig() async {
    try {
      final box = Hive.box(DatabaseConfig.tutorialHomeKey);
      final tutorialJson = box.get('tutorial_config');
      
      if (tutorialJson != null) {
        final tutorialData = jsonDecode(tutorialJson);
        final model = TutorialModel.fromJson(tutorialData);
        return model.toEntity();
      }
      
      return TutorialEntity.initial();
    } catch (e) {
      return TutorialEntity.initial();
    }
  }

  @override
  Future<void> updateTutorialConfig(TutorialEntity tutorial) async {
    try {
      final model = TutorialModel.fromEntity(tutorial);
      final tutorialJson = jsonEncode(model.toJson());
      
      final box = Hive.box(DatabaseConfig.tutorialHomeKey);
      await box.put('tutorial_config', tutorialJson);
    } catch (e) {
      throw Exception('Error al actualizar configuración del tutorial: $e');
    }
  }

  @override
  Future<void> clearTutorialConfig() async {
    try {
      final box = Hive.box(DatabaseConfig.tutorialHomeKey);
      await box.clear();
    } catch (e) {
      throw Exception('Error al limpiar configuración del tutorial: $e');
    }
  }

  // ========== RISK EVENT MODELS ==========

  @override
  Future<void> saveRiskEventModel({
    required String eventName,
    required String classificationType,
    required Map<String, dynamic> evaluationData,
  }) async {
    try {
      final key = '${eventName}_${classificationType}';
      final data = {
        'eventName': eventName,
        'classificationType': classificationType,
        'evaluationData': evaluationData,
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      await _prefs.setString(key, jsonEncode(data));
    } catch (e) {
      throw Exception('Error al guardar modelo de evento de riesgo: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getRiskEventModel({
    required String eventName,
    required String classificationType,
  }) async {
    try {
      final key = '${eventName}_${classificationType}';
      final dataJson = _prefs.getString(key);
      
      if (dataJson != null) {
        return jsonDecode(dataJson);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getRiskEventModelsForEvent(String eventName) async {
    try {
      final keys = _prefs.getKeys().where((key) => key.startsWith('${eventName}_'));
      final Map<String, Map<String, dynamic>> models = {};
      
      for (final key in keys) {
        final dataJson = _prefs.getString(key);
        if (dataJson != null) {
          models[key] = jsonDecode(dataJson);
        }
      }
      
      return models;
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> deleteRiskEventModel({
    required String eventName,
    required String classificationType,
  }) async {
    try {
      final key = '${eventName}_${classificationType}';
      await _prefs.remove(key);
    } catch (e) {
      throw Exception('Error al eliminar modelo de evento de riesgo: $e');
    }
  }

  // ========== EVALUATIONS ==========

  @override
  Future<void> markEvaluationCompleted({
    required String eventName,
    required String classificationType,
  }) async {
    try {
      final key = '${eventName}_${classificationType}';
      await _prefs.setBool(key, true);
    } catch (e) {
      throw Exception('Error al marcar evaluación como completada: $e');
    }
  }

  @override
  Future<Map<String, bool>> getCompletedEvaluations() async {
    try {
      final keys = _prefs.getKeys().where((key) => key.contains('_'));
      final Map<String, bool> evaluations = {};
      
      for (final key in keys) {
        final value = _prefs.getBool(key);
        if (value != null) {
          evaluations[key] = value;
        }
      }
      
      return evaluations;
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> resetEvaluationsForEvent(String eventName) async {
    try {
      final keys = _prefs.getKeys().where((key) => key.startsWith('${eventName}_'));
      
      for (final key in keys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      throw Exception('Error al resetear evaluaciones para evento: $e');
    }
  }

  // ========== UTILITIES ==========

  @override
  Future<bool> formExists(String formId) async {
    try {
      final form = await getFormById(formId);
      return form != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, int>> getFormStatistics() async {
    try {
      final allForms = await getSavedForms();
      
      return {
        'total': allForms.length,
        'inProgress': allForms.where((form) => form.status == FormStatus.inProgress).length,
        'completed': allForms.where((form) => form.status == FormStatus.completed).length,
      };
    } catch (e) {
      return {
        'total': 0,
        'inProgress': 0,
        'completed': 0,
      };
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await _prefs.clear();
      // TODO: Implementar clearAllData en FormPersistenceService
      // await _formPersistenceService.clearAllData();
      
      final box = Hive.box(DatabaseConfig.tutorialHomeKey);
      await box.clear();
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
