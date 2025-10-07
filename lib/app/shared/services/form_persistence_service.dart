import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form_data_model.dart';

class FormPersistenceService {
  static const String _formsKey = 'saved_forms';
  static const String _activeFormKey = 'active_form_id';

  // Singleton pattern
  static final FormPersistenceService _instance = FormPersistenceService._internal();
  factory FormPersistenceService() => _instance;
  FormPersistenceService._internal();

  // Cache para mejorar rendimiento
  List<FormDataModel>? _cachedForms;

  /// Guardar un formulario
  Future<bool> saveForm(FormDataModel form) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final forms = await getAllForms();
      
      // Buscar si el formulario ya existe
      final existingIndex = forms.indexWhere((f) => f.id == form.id);
      
      if (existingIndex != -1) {
        // Actualizar formulario existente
        forms[existingIndex] = form.copyWith(lastModified: DateTime.now());
      } else {
        // Agregar nuevo formulario
        forms.add(form);
      }
      
      // Guardar lista actualizada
      final formsJson = forms.map((f) => f.toJson()).toList();
      final success = await prefs.setString(_formsKey, jsonEncode(formsJson));
      
      // Limpiar cache para forzar recarga
      _cachedForms = null;
      
      return success;
    } catch (e) {
      print('Error saving form: $e');
      return false;
    }
  }

  /// Obtener todos los formularios
  Future<List<FormDataModel>> getAllForms() async {
    try {
      // Usar cache si está disponible
      if (_cachedForms != null) {
        return List.from(_cachedForms!);
      }

      final prefs = await SharedPreferences.getInstance();
      final formsString = prefs.getString(_formsKey);
      
      if (formsString == null) {
        _cachedForms = [];
        return [];
      }

      final formsJson = jsonDecode(formsString) as List<dynamic>;
      final forms = formsJson
          .map((json) => FormDataModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Ordenar por fecha de modificación (más recientes primero)
      forms.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      
      _cachedForms = forms;
      return List.from(forms);
    } catch (e) {
      print('Error loading forms: $e');
      _cachedForms = [];
      return [];
    }
  }

  /// Obtener formularios por estado
  Future<List<FormDataModel>> getFormsByStatus(FormStatus status) async {
    final forms = await getAllForms();
    return forms.where((form) => form.status == status).toList();
  }

  /// Obtener formularios por tipo
  Future<List<FormDataModel>> getFormsByType(FormType formType) async {
    final forms = await getAllForms();
    return forms.where((form) => form.formType == formType).toList();
  }

  /// Obtener un formulario específico por ID
  Future<FormDataModel?> getFormById(String id) async {
    final forms = await getAllForms();
    try {
      return forms.firstWhere((form) => form.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Eliminar un formulario
  Future<bool> deleteForm(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final forms = await getAllForms();
      
      forms.removeWhere((form) => form.id == id);
      
      final formsJson = forms.map((f) => f.toJson()).toList();
      final success = await prefs.setString(_formsKey, jsonEncode(formsJson));
      
      // Limpiar cache
      _cachedForms = null;
      
      return success;
    } catch (e) {
      print('Error deleting form: $e');
      return false;
    }
  }

  /// Marcar un formulario como completado
  Future<bool> markFormAsCompleted(String id) async {
    final form = await getFormById(id);
    if (form == null) return false;

    final completedForm = form.copyWith(
      status: FormStatus.completed,
      progressPercentage: 1.0,
      lastModified: DateTime.now(),
    );

    return await saveForm(completedForm);
  }

  /// Establecer formulario activo (el que se está editando actualmente)
  Future<void> setActiveForm(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeFormKey, formId);
  }

  /// Obtener formulario activo
  Future<String?> getActiveFormId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeFormKey);
  }

  /// Limpiar formulario activo
  Future<void> clearActiveForm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeFormKey);
  }

  /// Generar ID único para formularios
  String generateFormId() {
    return 'form_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Calcular progreso basado en datos del formulario
  double calculateProgress(Map<String, dynamic> riskAnalysisData) {
    print('DEBUG CALCULATE PROGRESS - Input data keys: ${riskAnalysisData.keys.toList()}');
    
    if (riskAnalysisData.isEmpty) {
      print('DEBUG CALCULATE PROGRESS - Data is empty, returning 0.0');
      return 0.0;
    }

    int totalFields = 0;
    int completedFields = 0;

    // Contar campos completados en dynamicSelections
    final dynamicSelections = riskAnalysisData['dynamicSelections'] as Map<String, dynamic>?;
    print('DEBUG CALCULATE PROGRESS - dynamicSelections: $dynamicSelections');
    
    if (dynamicSelections != null) {
      for (final entry in dynamicSelections.entries) {
        final key = entry.key;
        final subClassification = entry.value;
        if (subClassification is Map<String, dynamic>) {
          totalFields += 10; // Estimación de campos por subclasificación
          final subFields = (subClassification as Map).length;
          completedFields += subFields;
          print('DEBUG CALCULATE PROGRESS - $key: $subFields fields completed');
        }
      }
    }

    // Contar probabilidad e intensidad
    final hasProbabilidad = riskAnalysisData['selectedProbabilidad'] != null;
    final hasIntensidad = riskAnalysisData['selectedIntensidad'] != null;
    
    if (hasProbabilidad) completedFields += 5;
    if (hasIntensidad) completedFields += 5;
    totalFields += 10;

    print('DEBUG CALCULATE PROGRESS - probabilidad: $hasProbabilidad, intensidad: $hasIntensidad');

    final progress = totalFields > 0 ? completedFields / totalFields : 0.0;
    print('DEBUG CALCULATE PROGRESS FINAL: $completedFields/$totalFields = $progress (${(progress * 100).toStringAsFixed(1)}%)');
    
    return progress;
  }

  /// Calcular progreso de amenaza
  double calculateThreatProgress(Map<String, dynamic> riskAnalysisData) {
    int threatFields = 0;
    int completedThreatFields = 0;

    if (riskAnalysisData['selectedProbabilidad'] != null) {
      completedThreatFields += 1;
    }
    if (riskAnalysisData['selectedIntensidad'] != null) {
      completedThreatFields += 1;
    }
    threatFields = 2;

    final progress = threatFields > 0 ? completedThreatFields / threatFields : 0.0;
    print('DEBUG THREAT PROGRESS: $completedThreatFields/$threatFields = $progress');
    return progress;
  }

  /// Calcular progreso de vulnerabilidad
  double calculateVulnerabilityProgress(Map<String, dynamic> riskAnalysisData) {
    int vulnerabilityFields = 0;
    int completedVulnerabilityFields = 0;

    print('DEBUG VULN PROGRESS - riskAnalysisData keys: ${riskAnalysisData.keys.toList()}');
    
    final dynamicSelections = riskAnalysisData['dynamicSelections'] as Map<String, dynamic>?;
    print('DEBUG VULN PROGRESS - dynamicSelections: $dynamicSelections');
    
    if (dynamicSelections != null) {
      final vulnerabilityKeys = ['fragilidad_fisica', 'fragilidad_personas', 'exposicion'];
      
      for (final key in vulnerabilityKeys) {
        vulnerabilityFields += 1;
        if (dynamicSelections[key] != null) {
          final selections = dynamicSelections[key] as Map<String, dynamic>?;
          print('DEBUG VULN PROGRESS - $key: $selections');
          if (selections != null && selections.isNotEmpty) {
            completedVulnerabilityFields += 1;
          }
        }
      }
    }

    final progress = vulnerabilityFields > 0 ? completedVulnerabilityFields / vulnerabilityFields : 0.0;
    print('DEBUG VULN PROGRESS: $completedVulnerabilityFields/$vulnerabilityFields = $progress');
    return progress;
  }

  /// Limpiar cache (útil para testing o forzar recarga)
  void clearCache() {
    _cachedForms = null;
  }
}