import 'risk_threat_analysis_event.dart';

abstract class EvidenceEvent extends RiskThreatAnalysisEvent {
  const EvidenceEvent();
}

class UpdateImageCoordinates extends EvidenceEvent {
  final int imageIndex;
  final String lat;
  final String lng;

  const UpdateImageCoordinates({
    required this.imageIndex,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [imageIndex, lat, lng];
}

class GetCurrentLocationForImage extends EvidenceEvent {
  final int imageIndex;

  const GetCurrentLocationForImage(this.imageIndex);

  @override
  List<Object> get props => [imageIndex];
}

class SelectLocationFromMapForImage extends EvidenceEvent {
  final int imageIndex;
  final double lat;
  final double lng;

  const SelectLocationFromMapForImage({
    required this.imageIndex,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [imageIndex, lat, lng];
}

// Nuevos eventos para evidencias por categoría
class AddEvidenceImage extends EvidenceEvent {
  final String category; // 'amenaza' o 'vulnerabilidad'
  final String imagePath;

  const AddEvidenceImage({
    required this.category,
    required this.imagePath,
  });

  @override
  List<Object> get props => [category, imagePath];
}

class RemoveEvidenceImage extends EvidenceEvent {
  final String category; // 'amenaza' o 'vulnerabilidad'
  final int imageIndex;

  const RemoveEvidenceImage({
    required this.category,
    required this.imageIndex,
  });

  @override
  List<Object> get props => [category, imageIndex];
}

class UpdateEvidenceCoordinates extends EvidenceEvent {
  final String category; // 'amenaza' o 'vulnerabilidad'
  final int imageIndex;
  final String lat;
  final String lng;

  const UpdateEvidenceCoordinates({
    required this.category,
    required this.imageIndex,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [category, imageIndex, lat, lng];
}

class LoadEvidenceData extends EvidenceEvent {
  final String category; // 'amenaza' o 'vulnerabilidad'
  final List<String> imagePaths;
  final Map<int, Map<String, String>> coordinates;

  const LoadEvidenceData({
    required this.category,
    required this.imagePaths,
    required this.coordinates,
  });

  @override
  List<Object> get props => [category, imagePaths, coordinates];
}
