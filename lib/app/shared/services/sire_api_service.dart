import 'package:caja_herramientas/app/core/data/datasources/remote_datasource.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:io';

/// Servicio para transformar y enviar formularios a la API de SIRE
class SireApiService {
  final RemoteDatasource _remoteDatasource;

  SireApiService(this._remoteDatasource);

  /// Transforma CompleteFormDataModel al formato JSON requerido por la API de SIRE
  Map<String, dynamic> transformFormToSireJson(CompleteFormDataModel form, {String? sireNumber}) {
    try {
      final eventModel = RiskEventFactory.getEventByName(form.eventName);
      if (eventModel == null) {
        throw Exception('Evento no encontrado: ${form.eventName}');
      }

      // Transformar categorías (amenaza y vulnerabilidad)
      final categories = <Map<String, dynamic>>[];
      
      // Agregar categoría de amenaza
      final amenazaCategory = _transformCategory(
        form: form,
        eventModel: eventModel,
        categoryId: 'amenaza',
        categoryName: 'Amenaza',
        scores: form.amenazaScores,
        selections: form.amenazaSelections,
        probabilidadSelections: form.amenazaProbabilidadSelections,
        intensidadSelections: form.amenazaIntensidadSelections,
      );
      if (amenazaCategory != null) {
        categories.add(amenazaCategory);
      }

      // Agregar categoría de vulnerabilidad
      final vulnerabilidadCategory = _transformCategory(
        form: form,
        eventModel: eventModel,
        categoryId: 'vulnerabilidad',
        categoryName: 'Vulnerabilidad',
        scores: form.vulnerabilidadScores,
        selections: form.vulnerabilidadSelections,
        probabilidadSelections: form.vulnerabilidadProbabilidadSelections,
        intensidadSelections: form.vulnerabilidadIntensidadSelections,
      );
      if (vulnerabilidadCategory != null) {
        categories.add(vulnerabilidadCategory);
      }

      // Construir el JSON final
      final sireJson = {
        'id': form.id,
        'name': form.eventName,
        'createdAt': form.createdAt.toIso8601String(),
        'updatedAt': form.updatedAt.toIso8601String(),
        if (sireNumber != null) 'sireNumber': sireNumber,
        'categories': categories,
        'contactData': form.contactData.isNotEmpty ? form.contactData : _getDefaultContactData(),
        'inspectionData': form.inspectionData.isNotEmpty 
            ? form.inspectionData 
            : _getDefaultInspectionData(form),
      };

      return sireJson;
    } catch (e, stackTrace) {
      developer.log(
        'Error transformando formulario a JSON de SIRE',
        error: e,
        stackTrace: stackTrace,
        name: 'SireApiService',
      );
      rethrow;
    }
  }

  /// Transforma una categoría (amenaza o vulnerabilidad) al formato requerido
  Map<String, dynamic>? _transformCategory({
    required CompleteFormDataModel form,
    required RiskEventModel eventModel,
    required String categoryId,
    required String categoryName,
    required Map<String, double> scores,
    required Map<String, Map<String, String>> selections,
    required Map<String, String> probabilidadSelections,
    required Map<String, String> intensidadSelections,
  }) {
    final classification = eventModel.getClassificationById(categoryId);
    if (classification == null) {
      return null;
    }

    // Determinar las subclasificaciones según la categoría
    List<String> subClassificationIds;
    if (categoryId == 'amenaza') {
      subClassificationIds = ['probabilidad', 'intensidad'];
    } else {
      subClassificationIds = ['fragilidad_fisica', 'fragilidad_personas', 'exposicion'];
    }

    // Transformar subclasificaciones
    final subClassifications = <Map<String, dynamic>>[];
    
    for (final subClassificationId in subClassificationIds) {
      final subClassificationData = _transformSubClassification(
        form: form,
        classification: classification,
        subClassificationId: subClassificationId,
        categoryId: categoryId,
        selections: selections[subClassificationId] ?? {},
        valueSelections: categoryId == 'amenaza' 
            ? (subClassificationId == 'probabilidad' 
                ? probabilidadSelections 
                : intensidadSelections)
            : (subClassificationId == 'exposicion' 
                ? intensidadSelections 
                : probabilidadSelections),
        scores: scores,
      );
      
      if (subClassificationData != null) {
        subClassifications.add(subClassificationData);
      }
    }

    // Obtener evidencias de la categoría
    final evidences = _transformEvidences(
      form: form,
      categoryId: categoryId,
    );

    return {
      'id': categoryId,
      'name': categoryName,
      'calification': scores['global'] ?? 0.0,
      'subClassifications': subClassifications,
      'evidences': evidences,
    };
  }

  /// Transforma una subclasificación al formato requerido
  Map<String, dynamic>? _transformSubClassification({
    required CompleteFormDataModel form,
    required RiskClassification classification,
    required String subClassificationId,
    required String categoryId,
    required Map<String, String> selections,
    required Map<String, String> valueSelections,
    required Map<String, double> scores,
  }) {
    // Buscar la subclasificación en la lista de subclasificaciones
    RiskSubClassification? subClassification;
    try {
      subClassification = classification.subClassifications.firstWhere(
        (sc) => sc.id == subClassificationId,
      );
    } catch (e) {
      return null;
    }

    // Construir indicators array con formato {id, label, value}
    final indicators = <Map<String, dynamic>>[];
    
    for (final category in subClassification.categories) {
      // Obtener el valor de la categoría
      // 1) Buscar en valueSelections (mapeos directos id -> valor)
      // 2) Buscar dentro de cualquier submap de selections
      String? valueStr = valueSelections[category.id] ?? selections[category.id];
      if (valueStr == null || valueStr.isEmpty) {
        // Buscar en todos los mapas internos
        for (final entry in form.amenazaSelections.entries) {
          final found = entry.value[category.id];
          if (found != null && found.toString().isNotEmpty) {
            valueStr = found;
            break;
          }
        }
        if (valueStr == null || valueStr.isEmpty) {
          for (final entry in form.vulnerabilidadSelections.entries) {
            final found = entry.value[category.id];
            if (found != null && found.toString().isNotEmpty) {
              valueStr = found;
              break;
            }
          }
        }
      }
      
      if (valueStr != null) {
        final value = int.tryParse(valueStr) ?? 0;
        indicators.add({
          'id': category.id,
          'label': category.title,
          'value': value,
        });
      }
    }

    // Obtener el score de la subclasificación
    final calification = scores[subClassificationId] ?? 0.0;

    return {
      'id': subClassificationId,
      'name': subClassification.name,
      'calification': calification,
      'indicators': indicators,
    };
  }

  /// Transforma las evidencias al formato requerido
  List<Map<String, dynamic>> _transformEvidences({
    required CompleteFormDataModel form,
    required String categoryId,
  }) {
    final evidences = <Map<String, dynamic>>[];
    
    // Obtener todas las evidencias relacionadas con esta categoría
    // Las evidencias están organizadas por subclasificación (probabilidad, intensidad, etc.)
    final categoryPrefixes = categoryId == 'amenaza'
        ? ['probabilidad', 'intensidad']
        : ['fragilidad_fisica', 'fragilidad_personas', 'exposicion'];
    
    for (final prefix in categoryPrefixes) {
      final evidenceImages = form.evidenceImages[prefix] ?? [];
      final evidenceCoordinates = form.evidenceCoordinates[prefix] ?? {};

      // Transformar cada evidencia
      for (int i = 0; i < evidenceImages.length; i++) {
        final imagePath = evidenceImages[i];
        final coords = evidenceCoordinates[i];
        
        if (imagePath.isNotEmpty) {
          // Obtener información del archivo
          final file = File(imagePath);
          final fileName = file.path.split('/').last;
          final fileExtension = fileName.split('.').last.toLowerCase();
          
          // Determinar el tipo MIME
          String mimeType = 'image/jpeg'; // Por defecto
          if (fileExtension == 'png') {
            mimeType = 'image/png';
          } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            mimeType = 'image/jpeg';
          }

          // Construir objeto de evidencia
          final evidence = <String, dynamic>{
            'file': {
              'path': imagePath,
              'name': fileName,
              'type': mimeType,
            },
          };

          // Agregar ubicación si está disponible
          if (coords != null && coords.isNotEmpty) {
            evidence['location'] = {
              'latitude': double.tryParse(coords['latitude'] ?? '') ?? 0.0,
              'longitude': double.tryParse(coords['longitude'] ?? '') ?? 0.0,
              'altitude': double.tryParse(coords['altitude'] ?? '') ?? 0.0,
              'accuracy': double.tryParse(coords['accuracy'] ?? '') ?? 0.0,
            };

            // Agregar timestamp si está disponible
            if (coords['timestamp'] != null) {
              evidence['timestamp'] = coords['timestamp'];
            } else {
              // Usar timestamp actual si no está disponible
              evidence['timestamp'] = DateTime.now().toIso8601String();
            }
          } else {
            // Si no hay coordenadas, usar timestamp actual
            evidence['timestamp'] = DateTime.now().toIso8601String();
          }

          evidences.add(evidence);
        }
      }
    }

    return evidences;
  }

  /// Obtiene datos de contacto por defecto
  Map<String, dynamic> _getDefaultContactData() {
    return {
      'name': '',
      'phone': '',
      'email': '',
      'role': '',
    };
  }

  /// Obtiene datos de inspección por defecto
  Map<String, dynamic> _getDefaultInspectionData(CompleteFormDataModel form) {
    return {
      'location': '',
      'date': form.createdAt.toIso8601String(),
      'inspector': form.contactData['name'] ?? '',
    };
  }

  /// Envía el formulario a la API de SIRE
  Future<Map<String, dynamic>> sendFormToSIRE(
    CompleteFormDataModel form, {
    String? sireNumber,
    String? authToken,
    bool simulate = false,
  }) async {
    try {
      // Transformar el formulario al formato JSON requerido
      final sireJson = transformFormToSireJson(form, sireNumber: sireNumber);

      if (simulate) {
        // Simulación: imprimir JSON formateado y devolver respuesta mock
        final pretty = const JsonEncoder.withIndent('  ').convert(sireJson);
        developer.log('JSON SIMULADO A ENVIAR A SIRE (preview):\n$pretty', name: 'SireApiService');
        return {
          'status': 'simulated',
          'message': 'Envio simulado. No se realizó petición HTTP.',
          'payload': sireJson,
        };
      }

      developer.log('Enviando formulario a SIRE', name: 'SireApiService');

      // Enviar a la API
      final response = await _remoteDatasource.sendFormToSIRE(
        sireJson,
        authToken: authToken,
      );

      return response;
    } catch (e, stackTrace) {
      developer.log(
        'Error enviando formulario a SIRE',
        error: e,
        stackTrace: stackTrace,
        name: 'SireApiService',
      );
      rethrow;
    }
  }
}
