import '../models/inspection_data.dart';

class InspectionStorageService {
  static final InspectionStorageService _instance = InspectionStorageService._internal();
  factory InspectionStorageService() => _instance;
  InspectionStorageService._internal();

  // Lista en memoria para almacenar los datos de inspección
  final List<InspectionData> _inspections = [];

  /// Guarda una nueva inspección en memoria
  Future<void> saveInspection(InspectionData inspection) async {
    _inspections.add(inspection);
    print('=== INSPECCIÓN GUARDADA ===');
    print('ID Incidente: ${inspection.incidentId}');
    print('Estado: ${inspection.status}');
    print('Fecha: ${inspection.date}');
    print('Hora: ${inspection.time}');
    print('Comentario: ${inspection.comment}');
    print('Lesionados: ${inspection.injured}');
    print('Muertos: ${inspection.dead}');
    print('Total inspecciones guardadas: ${_inspections.length}');
  }

  /// Obtiene todas las inspecciones guardadas
  List<InspectionData> getAllInspections() {
    return List.unmodifiable(_inspections);
  }

  /// Obtiene una inspección por ID de incidente
  InspectionData? getInspectionById(String incidentId) {
    try {
      return _inspections.firstWhere(
        (inspection) => inspection.incidentId == incidentId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el número total de inspecciones guardadas
  int getInspectionCount() {
    return _inspections.length;
  }

  /// Limpia todas las inspecciones guardadas
  Future<void> clearAllInspections() async {
    _inspections.clear();
    print('=== TODAS LAS INSPECCIONES ELIMINADAS ===');
  }

  /// Obtiene las inspecciones en formato JSON
  List<Map<String, dynamic>> getAllInspectionsAsJson() {
    return _inspections.map((inspection) => inspection.toJson()).toList();
  }

  /// Guarda las inspecciones desde JSON
  Future<void> loadInspectionsFromJson(List<Map<String, dynamic>> jsonList) async {
    _inspections.clear();
    for (final json in jsonList) {
      _inspections.add(InspectionData.fromJson(json));
    }
    print('=== INSPECCIONES CARGADAS DESDE JSON ===');
    print('Total cargadas: ${_inspections.length}');
  }
}
