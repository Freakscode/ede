import 'package:equatable/equatable.dart';

/// Value Object para datos de progreso de formularios
/// Encapsula la lógica de negocio relacionada con el progreso
class FormProgressData extends Equatable {
  final String formId;
  final double amenazaProgress;      // 0.0 - 1.0
  final double vulnerabilidadProgress; // 0.0 - 1.0
  final DateTime lastUpdated;
  
  const FormProgressData({
    required this.formId,
    required this.amenazaProgress,
    required this.vulnerabilidadProgress,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [formId, amenazaProgress, vulnerabilidadProgress, lastUpdated];

  /// Lógica de negocio: Progreso total (promedio)
  double get totalProgress => (amenazaProgress + vulnerabilidadProgress) / 2;

  /// Lógica de negocio: ¿El formulario está completo?
  bool get isComplete => totalProgress >= 1.0;

  /// Lógica de negocio: ¿La amenaza está completa?
  bool get isAmenazaComplete => amenazaProgress >= 1.0;

  /// Lógica de negocio: ¿La vulnerabilidad está completa?
  bool get isVulnerabilidadComplete => vulnerabilidadProgress >= 1.0;

  /// Lógica de negocio: ¿Puede finalizar el formulario?
  bool get canFinalize => isAmenazaComplete && isVulnerabilidadComplete;

  /// Lógica de negocio: Porcentaje de amenaza como entero
  int get amenazaPercentage => (amenazaProgress * 100).round();

  /// Lógica de negocio: Porcentaje de vulnerabilidad como entero
  int get vulnerabilidadPercentage => (vulnerabilidadProgress * 100).round();

  /// Lógica de negocio: Porcentaje total como entero
  int get totalPercentage => (totalProgress * 100).round();

  /// Método de negocio: Actualizar progreso de amenaza
  FormProgressData updateAmenaza(double progress) {
    return FormProgressData(
      formId: formId,
      amenazaProgress: progress.clamp(0.0, 1.0),
      vulnerabilidadProgress: vulnerabilidadProgress,
      lastUpdated: DateTime.now(),
    );
  }

  /// Método de negocio: Actualizar progreso de vulnerabilidad
  FormProgressData updateVulnerabilidad(double progress) {
    return FormProgressData(
      formId: formId,
      amenazaProgress: amenazaProgress,
      vulnerabilidadProgress: progress.clamp(0.0, 1.0),
      lastUpdated: DateTime.now(),
    );
  }

  /// Método de negocio: Actualizar ambos progresos
  FormProgressData updateProgress({
    double? amenazaProgress,
    double? vulnerabilidadProgress,
  }) {
    return FormProgressData(
      formId: formId,
      amenazaProgress: amenazaProgress?.clamp(0.0, 1.0) ?? this.amenazaProgress,
      vulnerabilidadProgress: vulnerabilidadProgress?.clamp(0.0, 1.0) ?? this.vulnerabilidadProgress,
      lastUpdated: DateTime.now(),
    );
  }

  /// Método de negocio: Crear copia con cambios
  FormProgressData copyWith({
    String? formId,
    double? amenazaProgress,
    double? vulnerabilidadProgress,
    DateTime? lastUpdated,
  }) {
    return FormProgressData(
      formId: formId ?? this.formId,
      amenazaProgress: amenazaProgress ?? this.amenazaProgress,
      vulnerabilidadProgress: vulnerabilidadProgress ?? this.vulnerabilidadProgress,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Factory method: Crear progreso inicial
  static FormProgressData initial(String formId) {
    return FormProgressData(
      formId: formId,
      amenazaProgress: 0.0,
      vulnerabilidadProgress: 0.0,
      lastUpdated: DateTime.now(),
    );
  }

  /// Factory method: Crear progreso completo
  static FormProgressData complete(String formId) {
    return FormProgressData(
      formId: formId,
      amenazaProgress: 1.0,
      vulnerabilidadProgress: 1.0,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FormProgressData(formId: $formId, amenaza: ${amenazaPercentage}%, '
           'vulnerabilidad: ${vulnerabilidadPercentage}%, total: ${totalPercentage}%)';
  }
}
