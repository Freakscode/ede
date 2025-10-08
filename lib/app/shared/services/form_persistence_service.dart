import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form_data_model.dart';

class FormPersistenceService {
  static const String _activeFormKey = 'active_form_id';
  static const String _dbName = 'risk_analysis_forms.db';
  static const int _dbVersion = 2;

  // Singleton pattern
  static final FormPersistenceService _instance = FormPersistenceService._internal();
  factory FormPersistenceService() => _instance;
  FormPersistenceService._internal();

  Database? _database;

  // Inicializar la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabla principal de formularios
    await db.execute('''
      CREATE TABLE forms (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        event_type TEXT NOT NULL,
        form_type TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        last_modified INTEGER NOT NULL,
        progress_percentage REAL NOT NULL DEFAULT 0.0,
        threat_progress REAL NOT NULL DEFAULT 0.0,
        vulnerability_progress REAL NOT NULL DEFAULT 0.0
      )
    ''');

    // Tabla de datos de análisis de riesgo (JSON)
    await db.execute('''
      CREATE TABLE risk_analysis_data (
        form_id TEXT PRIMARY KEY,
        selected_risk_event TEXT,
        selected_classification TEXT,
        probabilidad_selections TEXT,
        intensidad_selections TEXT,
        dynamic_selections TEXT,
        sub_classification_scores TEXT,
        amenaza_data TEXT,
        vulnerabilidad_data TEXT,
        FOREIGN KEY (form_id) REFERENCES forms (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de datos EDE (JSON)
    await db.execute('''
      CREATE TABLE ede_data (
        form_id TEXT PRIMARY KEY,
        data TEXT,
        FOREIGN KEY (form_id) REFERENCES forms (id) ON DELETE CASCADE
      )
    ''');

    // Índices para mejorar rendimiento
    await db.execute('CREATE INDEX idx_forms_status ON forms (status)');
    await db.execute('CREATE INDEX idx_forms_event_type ON forms (event_type)');
    await db.execute('CREATE INDEX idx_forms_last_modified ON forms (last_modified DESC)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Manejar actualizaciones de esquema en futuras versiones
    if (oldVersion < 2) {
      // Agregar campos para amenaza y vulnerabilidad separados
      await db.execute('ALTER TABLE risk_analysis_data ADD COLUMN amenaza_data TEXT DEFAULT "{}"');
      await db.execute('ALTER TABLE risk_analysis_data ADD COLUMN vulnerabilidad_data TEXT DEFAULT "{}"');
    }
  }



  /// Guardar un formulario
  Future<bool> saveForm(FormDataModel form) async {
    try {
      final db = await database;
      final updatedForm = form.copyWith(lastModified: DateTime.now());
      
      // Insertar o actualizar en la tabla principal de formularios
      await db.insert(
        'forms',
        {
          'id': updatedForm.id,
          'title': updatedForm.title,
          'event_type': updatedForm.eventType,
          'form_type': updatedForm.formType.toString(),
          'status': updatedForm.status.toString(),
          'created_at': updatedForm.createdAt.millisecondsSinceEpoch,
          'last_modified': updatedForm.lastModified.millisecondsSinceEpoch,
          'progress_percentage': updatedForm.progressPercentage,
          'threat_progress': updatedForm.threatProgress,
          'vulnerability_progress': updatedForm.vulnerabilityProgress,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Guardar datos de análisis de riesgo si existen
      if (updatedForm.riskAnalysisData.isNotEmpty || 
          updatedForm.amenazaData.isNotEmpty || 
          updatedForm.vulnerabilidadData.isNotEmpty) {
        await db.insert(
          'risk_analysis_data',
          {
            'form_id': updatedForm.id,
            'selected_risk_event': updatedForm.riskAnalysisData['selectedRiskEvent'],
            'selected_classification': updatedForm.riskAnalysisData['selectedClassification'],
            'probabilidad_selections': jsonEncode(updatedForm.riskAnalysisData['probabilidadSelections'] ?? {}),
            'intensidad_selections': jsonEncode(updatedForm.riskAnalysisData['intensidadSelections'] ?? {}),
            'dynamic_selections': jsonEncode(updatedForm.riskAnalysisData['dynamicSelections'] ?? {}),
            'sub_classification_scores': jsonEncode(updatedForm.riskAnalysisData['subClassificationScores'] ?? {}),
            'amenaza_data': jsonEncode(updatedForm.amenazaData),
            'vulnerabilidad_data': jsonEncode(updatedForm.vulnerabilidadData),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Guardar datos EDE si existen
      if (updatedForm.edeData.isNotEmpty) {
        await db.insert(
          'ede_data',
          {
            'form_id': updatedForm.id,
            'data': jsonEncode(updatedForm.edeData),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener todos los formularios
  Future<List<FormDataModel>> getAllForms() async {
    try {
      final db = await database;
      
      // Consulta principal con JOIN para obtener datos relacionados
      final List<Map<String, dynamic>> formsData = await db.rawQuery('''
        SELECT 
          f.*,
          r.selected_risk_event,
          r.selected_classification,
          r.probabilidad_selections,
          r.intensidad_selections,
          r.dynamic_selections,
          r.sub_classification_scores,
          r.amenaza_data,
          r.vulnerabilidad_data,
          e.data as ede_data
        FROM forms f
        LEFT JOIN risk_analysis_data r ON f.id = r.form_id
        LEFT JOIN ede_data e ON f.id = e.form_id
        ORDER BY f.last_modified DESC
      ''');

      final forms = <FormDataModel>[];
      
      for (final row in formsData) {
        // Construir riskAnalysisData
        final riskAnalysisData = <String, dynamic>{};
        if (row['selected_risk_event'] != null) {
          riskAnalysisData['selectedRiskEvent'] = row['selected_risk_event'];
        }
        if (row['selected_classification'] != null) {
          riskAnalysisData['selectedClassification'] = row['selected_classification'];
        }
        if (row['probabilidad_selections'] != null) {
          riskAnalysisData['probabilidadSelections'] = jsonDecode(row['probabilidad_selections'] as String);
        }
        if (row['intensidad_selections'] != null) {
          riskAnalysisData['intensidadSelections'] = jsonDecode(row['intensidad_selections'] as String);
        }
        if (row['dynamic_selections'] != null) {
          riskAnalysisData['dynamicSelections'] = jsonDecode(row['dynamic_selections'] as String);
        }
        if (row['sub_classification_scores'] != null) {
          riskAnalysisData['subClassificationScores'] = jsonDecode(row['sub_classification_scores'] as String);
        }

        // Construir amenazaData
        final amenazaData = row['amenaza_data'] != null 
          ? jsonDecode(row['amenaza_data'] as String) as Map<String, dynamic>
          : <String, dynamic>{};

        // Construir vulnerabilidadData
        final vulnerabilidadData = row['vulnerabilidad_data'] != null 
          ? jsonDecode(row['vulnerabilidad_data'] as String) as Map<String, dynamic>
          : <String, dynamic>{};

        // Construir edeData
        final edeData = row['ede_data'] != null 
          ? jsonDecode(row['ede_data'] as String) as Map<String, dynamic>
          : <String, dynamic>{};

        // Crear FormDataModel
        final form = FormDataModel(
          id: row['id'] as String,
          title: row['title'] as String,
          eventType: row['event_type'] as String,
          formType: FormType.values.firstWhere(
            (e) => e.toString() == row['form_type'],
            orElse: () => FormType.riskAnalysis,
          ),
          status: FormStatus.values.firstWhere(
            (e) => e.toString() == row['status'],
            orElse: () => FormStatus.inProgress,
          ),
          createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
          lastModified: DateTime.fromMillisecondsSinceEpoch(row['last_modified'] as int),
          progressPercentage: (row['progress_percentage'] as num).toDouble(),
          threatProgress: (row['threat_progress'] as num).toDouble(),
          vulnerabilityProgress: (row['vulnerability_progress'] as num).toDouble(),
          riskAnalysisData: riskAnalysisData,
          amenazaData: amenazaData,
          vulnerabilidadData: vulnerabilidadData,
          edeData: edeData,
        );
        
        forms.add(form);
      }

      return forms;
    } catch (e) {
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
      final db = await database;
      
      // Eliminar de la tabla principal (CASCADE eliminará las relacionadas)
      final deletedRows = await db.delete(
        'forms',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      return deletedRows > 0;
    } catch (e) {
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
    if (riskAnalysisData.isEmpty) {
      return 0.0;
    }

    int totalFields = 0;
    int completedFields = 0;

    // Contar campos completados en dynamicSelections
    final dynamicSelections = riskAnalysisData['dynamicSelections'] as Map<String, dynamic>?;
    
    if (dynamicSelections != null) {
      for (final entry in dynamicSelections.entries) {
        final subClassification = entry.value;
        if (subClassification is Map<String, dynamic>) {
          totalFields += 10; // Estimación de campos por subclasificación
          final subFields = (subClassification as Map).length;
          completedFields += subFields;
        }
      }
    }

    // Contar probabilidad e intensidad
    final probabilidadSelections = riskAnalysisData['probabilidadSelections'] as Map?;
    final intensidadSelections = riskAnalysisData['intensidadSelections'] as Map?;
    
    if (probabilidadSelections != null && probabilidadSelections.isNotEmpty) {
      completedFields += 5;
    }
    if (intensidadSelections != null && intensidadSelections.isNotEmpty) {
      completedFields += 5;
    }
    totalFields += 10;

    final progress = totalFields > 0 ? completedFields / totalFields : 0.0;
    return progress;
  }

  /// Calcular progreso de amenaza
  double calculateThreatProgress(Map<String, dynamic> riskAnalysisData) {
    int threatFields = 2;
    int completedThreatFields = 0;

    final probabilidadSelections = riskAnalysisData['probabilidadSelections'] as Map?;
    final intensidadSelections = riskAnalysisData['intensidadSelections'] as Map?;

    if (probabilidadSelections != null && probabilidadSelections.isNotEmpty) {
      completedThreatFields += 1;
    }
    if (intensidadSelections != null && intensidadSelections.isNotEmpty) {
      completedThreatFields += 1;
    }

    final progress = threatFields > 0 ? completedThreatFields / threatFields : 0.0;
    return progress;
  }

  /// Calcular progreso de vulnerabilidad
  double calculateVulnerabilityProgress(Map<String, dynamic> riskAnalysisData) {
    int vulnerabilityFields = 0;
    int completedVulnerabilityFields = 0;

    final dynamicSelections = riskAnalysisData['dynamicSelections'] as Map<String, dynamic>?;
    
    if (dynamicSelections != null) {
      final vulnerabilityKeys = ['fragilidad_fisica', 'fragilidad_personas', 'exposicion'];
      
      for (final key in vulnerabilityKeys) {
        vulnerabilityFields += 1;
        if (dynamicSelections[key] != null) {
          final selections = dynamicSelections[key] as Map<String, dynamic>?;
          if (selections != null && selections.isNotEmpty) {
            completedVulnerabilityFields += 1;
          }
        }
      }
    }

    final progress = vulnerabilityFields > 0 ? completedVulnerabilityFields / vulnerabilityFields : 0.0;
    return progress;
  }

  /// Cerrar la base de datos (útil para testing o limpieza)
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Limpiar todas las tablas (útil para testing)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('forms');
    await db.delete('risk_analysis_data');
    await db.delete('ede_data');
  }

  /// Obtener estadísticas de la base de datos
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;
    
    final formsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM forms')
    ) ?? 0;
    
    final riskDataCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM risk_analysis_data')
    ) ?? 0;
    
    final edeDataCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ede_data')
    ) ?? 0;
    
    return {
      'total_forms': formsCount,
      'forms_with_risk_data': riskDataCount,
      'forms_with_ede_data': edeDataCount,
    };
  }



  /// Crear backup manual de la base de datos
  Future<String?> createBackup() async {
    try {
      final forms = await getAllForms();
      final backupData = {
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0',
        'forms': forms.map((f) => f.toJson()).toList(),
      };
      
      final backupJson = jsonEncode(backupData);
      final prefs = await SharedPreferences.getInstance();
      final backupKey = 'backup_${DateTime.now().millisecondsSinceEpoch}';
      
      await prefs.setString(backupKey, backupJson);
      
      return backupKey;
    } catch (e) {
      return null;
    }
  }
}