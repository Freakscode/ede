import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/persistent_form_data_model.dart';
import '../models/complete_form_data_model.dart';

class FormPersistenceService {
  // Singleton pattern
  static final FormPersistenceService _instance = FormPersistenceService._internal();
  factory FormPersistenceService() => _instance;
  FormPersistenceService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'form_persistence.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabla para formularios
    await db.execute('''
      CREATE TABLE forms (
        id TEXT PRIMARY KEY,
        event_name TEXT NOT NULL,
        classification_type TEXT NOT NULL,
        form_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_active INTEGER DEFAULT 0
      )
    ''');

    // Tabla para formulario activo
    await db.execute('''
      CREATE TABLE active_form (
        id INTEGER PRIMARY KEY,
        form_id TEXT,
        FOREIGN KEY (form_id) REFERENCES forms (id)
      )
    ''');
  }

  Future<void> saveForm(PersistentFormDataModel form) async {
    final db = await database;
    
    final formDataJson = jsonEncode(form.toJson());
    final now = DateTime.now().toIso8601String();
    
    await db.insert(
      'forms',
      {
        'id': form.id,
        'event_name': form.eventName,
        'classification_type': form.classificationType,
        'form_data': formDataJson,
        'created_at': now,
        'updated_at': now,
        'is_active': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('FormPersistenceService: Formulario guardado - ${form.id}');
  }

  Future<PersistentFormDataModel?> getForm(String formId) async {
    final db = await database;
    
    final result = await db.query(
      'forms',
      where: 'id = ?',
      whereArgs: [formId],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return PersistentFormDataModel.fromJson(formData);
    }

    return null;
  }

  Future<List<PersistentFormDataModel>> getAllForms() async {
    final db = await database;
    
    final results = await db.query('forms', orderBy: 'updated_at DESC');
    
    return results.map((row) {
      final formData = jsonDecode(row['form_data'] as String);
      return PersistentFormDataModel.fromJson(formData);
    }).toList();
  }

  Future<List<PersistentFormDataModel>> getFormsByEvent(String eventName) async {
    final db = await database;
    
    final results = await db.query(
      'forms',
      where: 'event_name = ?',
      whereArgs: [eventName],
      orderBy: 'updated_at DESC',
    );
    
    return results.map((row) {
      final formData = jsonDecode(row['form_data'] as String);
      return PersistentFormDataModel.fromJson(formData);
    }).toList();
  }

  Future<void> deleteForm(String formId) async {
    final db = await database;
    
    await db.delete(
      'forms',
      where: 'id = ?',
      whereArgs: [formId],
    );

    print('FormPersistenceService: Formulario eliminado - $formId');
  }

  Future<void> setActiveFormId(String? formId) async {
    final db = await database;
    
    // Limpiar formulario activo anterior
    await db.delete('active_form');
    
    if (formId != null) {
      // Establecer nuevo formulario activo
      await db.insert('active_form', {'form_id': formId});
      
      // Marcar como activo en la tabla forms
      await db.update(
        'forms',
        {'is_active': 1},
        where: 'id = ?',
        whereArgs: [formId],
      );
    }

    print('FormPersistenceService: Formulario activo establecido - $formId');
  }

  Future<String?> getActiveFormId() async {
    final db = await database;
    
    final result = await db.query('active_form', limit: 1);
    
    if (result.isNotEmpty) {
      return result.first['form_id'] as String?;
    }

    return null;
  }

  Future<PersistentFormDataModel?> getActiveForm() async {
    final activeFormId = await getActiveFormId();
    if (activeFormId != null) {
      return await getForm(activeFormId);
    }
    return null;
  }

  Future<void> updateFormProgress(String formId, Map<String, dynamic> updatedData) async {
    // Obtener formulario actual
    final form = await getForm(formId);
    if (form == null) return;
    
    // Actualizar datos
    final updatedForm = PersistentFormDataModel(
      id: form.id,
      eventName: form.eventName,
      classificationType: form.classificationType,
      dynamicSelections: updatedData['dynamicSelections'] ?? form.dynamicSelections,
      subClassificationScores: updatedData['subClassificationScores'] ?? form.subClassificationScores,
      subClassificationColors: updatedData['subClassificationColors'] ?? form.subClassificationColors,
      probabilidadSelections: updatedData['probabilidadSelections'] ?? form.probabilidadSelections,
      intensidadSelections: updatedData['intensidadSelections'] ?? form.intensidadSelections,
      selectedProbabilidad: updatedData['selectedProbabilidad'] ?? form.selectedProbabilidad,
      selectedIntensidad: updatedData['selectedIntensidad'] ?? form.selectedIntensidad,
      createdAt: form.createdAt,
      updatedAt: DateTime.now(),
    );
    
    // Guardar formulario actualizado
    await saveForm(updatedForm);
    
    print('FormPersistenceService: Progreso actualizado - $formId');
  }

  // ======= MÉTODOS PARA FORMULARIOS COMPLETOS =======

  /// Guarda un formulario completo (evento + amenaza + vulnerabilidad)
  Future<void> saveCompleteForm(CompleteFormDataModel form) async {
    final db = await database;
    
    print('=== DEBUG saveCompleteForm ===');
    print('Form ID: ${form.id}');
    print('EvidenceImages: ${form.evidenceImages}');
    print('EvidenceCoordinates: ${form.evidenceCoordinates}');
    
    String formDataJson;
    try {
      formDataJson = jsonEncode(form.toJson());
      print('Serialización exitosa');
    } catch (e) {
      print('Error en serialización: $e');
      print('toJson result: ${form.toJson()}');
      rethrow;
    }
    
    final now = DateTime.now().toIso8601String();
    
    await db.insert(
      'forms',
      {
        'id': form.id,
        'event_name': form.eventName,
        'classification_type': 'complete', // Tipo especial para formularios completos
        'form_data': formDataJson,
        'created_at': now,
        'updated_at': now,
        'is_active': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('FormPersistenceService: Formulario completo guardado - ${form.id}');
  }

  /// Obtiene un formulario completo por ID
  Future<CompleteFormDataModel?> getCompleteForm(String formId) async {
    final db = await database;
    final result = await db.query(
      'forms',
      where: 'id = ? AND classification_type = ?',
      whereArgs: [formId, 'complete'],
    );
    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return CompleteFormDataModel.fromJson(formData);
    }
    return null;
  }

  /// Obtiene todos los formularios completos
  Future<List<CompleteFormDataModel>> getAllCompleteForms() async {
    final db = await database;
    final results = await db.query(
      'forms', 
      where: 'classification_type = ?',
      whereArgs: ['complete'],
      orderBy: 'updated_at DESC'
    );
    return results.map((row) {
      final formData = jsonDecode(row['form_data'] as String);
      return CompleteFormDataModel.fromJson(formData);
    }).toList();
  }

  /// Obtiene formularios completos por evento
  Future<List<CompleteFormDataModel>> getCompleteFormsByEvent(String eventName) async {
    final db = await database;
    final results = await db.query(
      'forms',
      where: 'event_name = ? AND classification_type = ?',
      whereArgs: [eventName, 'complete'],
      orderBy: 'updated_at DESC',
    );
    return results.map((row) {
      final formData = jsonDecode(row['form_data'] as String);
      return CompleteFormDataModel.fromJson(formData);
    }).toList();
  }

  /// Actualiza el progreso de un formulario completo
  Future<void> updateCompleteFormProgress(String formId, Map<String, dynamic> updatedData) async {
    // Obtener formulario actual
    final form = await getCompleteForm(formId);
    if (form == null) return;
    
    // Actualizar datos según la clasificación
    final classificationType = updatedData['classificationType'] as String;
    CompleteFormDataModel updatedForm;
    
    if (classificationType == 'amenaza') {
      updatedForm = form.copyWith(
        amenazaSelections: updatedData['dynamicSelections'] ?? form.amenazaSelections,
        amenazaScores: updatedData['subClassificationScores'] ?? form.amenazaScores,
        amenazaColors: updatedData['subClassificationColors'] ?? form.amenazaColors,
        amenazaProbabilidadSelections: updatedData['probabilidadSelections'] ?? form.amenazaProbabilidadSelections,
        amenazaIntensidadSelections: updatedData['intensidadSelections'] ?? form.amenazaIntensidadSelections,
        amenazaSelectedProbabilidad: updatedData['selectedProbabilidad'] ?? form.amenazaSelectedProbabilidad,
        amenazaSelectedIntensidad: updatedData['selectedIntensidad'] ?? form.amenazaSelectedIntensidad,
        updatedAt: DateTime.now(),
      );
    } else if (classificationType == 'vulnerabilidad') {
      updatedForm = form.copyWith(
        vulnerabilidadSelections: updatedData['dynamicSelections'] ?? form.vulnerabilidadSelections,
        vulnerabilidadScores: updatedData['subClassificationScores'] ?? form.vulnerabilidadScores,
        vulnerabilidadColors: updatedData['subClassificationColors'] ?? form.vulnerabilidadColors,
        vulnerabilidadProbabilidadSelections: updatedData['probabilidadSelections'] ?? form.vulnerabilidadProbabilidadSelections,
        vulnerabilidadIntensidadSelections: updatedData['intensidadSelections'] ?? form.vulnerabilidadIntensidadSelections,
        vulnerabilidadSelectedProbabilidad: updatedData['selectedProbabilidad'] ?? form.vulnerabilidadSelectedProbabilidad,
        vulnerabilidadSelectedIntensidad: updatedData['selectedIntensidad'] ?? form.vulnerabilidadSelectedIntensidad,
        updatedAt: DateTime.now(),
      );
    } else {
      return; // Tipo de clasificación no válido
    }
    
    // Guardar formulario actualizado
    await saveCompleteForm(updatedForm);
    
    print('FormPersistenceService: Progreso de formulario completo actualizado - $formId ($classificationType)');
  }
}
