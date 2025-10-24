import 'package:equatable/equatable.dart';
import '../models/form_mode.dart';

/// Eventos base para el módulo RiskThreatAnalysis
abstract class RiskThreatAnalysisEvent extends Equatable {
  const RiskThreatAnalysisEvent();

  @override
  List<Object?> get props => [];
}

// ========== NAVEGACIÓN ==========

/// Evento para cambiar el índice de navegación
class ChangeBottomNavIndex extends RiskThreatAnalysisEvent {
  final int index;

  const ChangeBottomNavIndex(this.index);

  @override
  List<Object?> get props => [index];
}

/// Evento para mostrar resultados finales
class ShowFinalResults extends RiskThreatAnalysisEvent {
  const ShowFinalResults();
}

// ========== MODO DE FORMULARIO ==========

/// Evento para establecer el modo del formulario
class SetFormMode extends RiskThreatAnalysisEvent {
  final FormMode mode;

  const SetFormMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Evento para cambiar a modo creación
class SetCreateMode extends RiskThreatAnalysisEvent {
  const SetCreateMode();
}

/// Evento para cambiar a modo edición
class SetEditMode extends RiskThreatAnalysisEvent {
  const SetEditMode();
}

// ========== DROPDOWNS ==========

/// Evento para alternar dropdown de probabilidad
class ToggleProbabilidadDropdown extends RiskThreatAnalysisEvent {
  const ToggleProbabilidadDropdown();
}

/// Evento para alternar dropdown de intensidad
class ToggleIntensidadDropdown extends RiskThreatAnalysisEvent {
  const ToggleIntensidadDropdown();
}

/// Evento para alternar dropdown dinámico
class ToggleDynamicDropdown extends RiskThreatAnalysisEvent {
  final String subClassificationId;

  const ToggleDynamicDropdown(this.subClassificationId);

  @override
  List<Object?> get props => [subClassificationId];
}

/// Evento para resetear dropdowns
class ResetDropdowns extends RiskThreatAnalysisEvent {
  const ResetDropdowns();
}

/// Evento para resetear completamente el estado
class ResetState extends RiskThreatAnalysisEvent {
  const ResetState();
}

// ========== SELECCIONES ==========

/// Evento para seleccionar probabilidad
class SelectProbabilidad extends RiskThreatAnalysisEvent {
  final String probabilidad;

  const SelectProbabilidad(this.probabilidad);

  @override
  List<Object?> get props => [probabilidad];
}

/// Evento para seleccionar intensidad
class SelectIntensidad extends RiskThreatAnalysisEvent {
  final String intensidad;

  const SelectIntensidad(this.intensidad);

  @override
  List<Object?> get props => [intensidad];
}

/// Evento para actualizar selección de probabilidad
class UpdateProbabilidadSelection extends RiskThreatAnalysisEvent {
  final String category;
  final String selection;

  const UpdateProbabilidadSelection({
    required this.category,
    required this.selection,
  });

  @override
  List<Object?> get props => [category, selection];
}

/// Evento para actualizar selección de intensidad
class UpdateIntensidadSelection extends RiskThreatAnalysisEvent {
  final String category;
  final String selection;

  const UpdateIntensidadSelection({
    required this.category,
    required this.selection,
  });

  @override
  List<Object?> get props => [category, selection];
}

/// Evento para actualizar selección dinámica
class UpdateDynamicSelection extends RiskThreatAnalysisEvent {
  final String subClassificationId;
  final String category;
  final String selection;

  const UpdateDynamicSelection({
    required this.subClassificationId,
    required this.category,
    required this.selection,
  });

  @override
  List<Object?> get props => [subClassificationId, category, selection];
}

/// Evento para seleccionar clasificación
class SelectClassification extends RiskThreatAnalysisEvent {
  final String classification;

  const SelectClassification(this.classification);

  @override
  List<Object?> get props => [classification];
}

// ========== EVENTOS DE RIESGO ==========

/// Evento para actualizar evento de riesgo seleccionado
class UpdateSelectedRiskEvent extends RiskThreatAnalysisEvent {
  final String eventName;

  const UpdateSelectedRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

// ========== FORMULARIOS ==========

/// Evento para cargar datos de formulario
class LoadFormData extends RiskThreatAnalysisEvent {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic>? evaluationData;

  const LoadFormData({
    required this.eventName,
    required this.classificationType,
    this.evaluationData,
  });

  @override
  List<Object?> get props => [eventName, classificationType, evaluationData];
}

/// Evento para guardar datos de formulario
class SaveFormData extends RiskThreatAnalysisEvent {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> data;

  const SaveFormData({
    required this.eventName,
    required this.classificationType,
    required this.data,
  });

  @override
  List<Object?> get props => [eventName, classificationType, data];
}

// ========== EVIDENCIAS ==========

/// Evento para actualizar coordenadas de imagen
class UpdateImageCoordinates extends RiskThreatAnalysisEvent {
  final String category;
  final int imageIndex;
  final Map<String, String> coordinates;

  const UpdateImageCoordinates({
    required this.category,
    required this.imageIndex,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [category, imageIndex, coordinates];
}

/// Evento para obtener ubicación actual para imagen
class GetCurrentLocationForImage extends RiskThreatAnalysisEvent {
  final String category;
  final int imageIndex;

  const GetCurrentLocationForImage({
    required this.category,
    required this.imageIndex,
  });

  @override
  List<Object?> get props => [category, imageIndex];
}

/// Evento para seleccionar ubicación desde mapa para imagen
class SelectLocationFromMapForImage extends RiskThreatAnalysisEvent {
  final String category;
  final int imageIndex;
  final Map<String, String> coordinates;

  const SelectLocationFromMapForImage({
    required this.category,
    required this.imageIndex,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [category, imageIndex, coordinates];
}

/// Evento para agregar imagen de evidencia
class AddEvidenceImage extends RiskThreatAnalysisEvent {
  final String category;
  final String imagePath;

  const AddEvidenceImage({
    required this.category,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [category, imagePath];
}

/// Evento para remover imagen de evidencia
class RemoveEvidenceImage extends RiskThreatAnalysisEvent {
  final String category;
  final int imageIndex;

  const RemoveEvidenceImage({
    required this.category,
    required this.imageIndex,
  });

  @override
  List<Object?> get props => [category, imageIndex];
}

/// Evento para actualizar coordenadas de evidencia
class UpdateEvidenceCoordinates extends RiskThreatAnalysisEvent {
  final String category;
  final int imageIndex;
  final Map<String, String> coordinates;

  const UpdateEvidenceCoordinates({
    required this.category,
    required this.imageIndex,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [category, imageIndex, coordinates];
}

/// Evento para cargar datos de evidencia
class LoadEvidenceData extends RiskThreatAnalysisEvent {
  final String eventName;
  final String classificationType;

  const LoadEvidenceData({
    required this.eventName,
    required this.classificationType,
  });

  @override
  List<Object?> get props => [eventName, classificationType];
}
