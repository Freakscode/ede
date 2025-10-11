import 'package:equatable/equatable.dart';
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
