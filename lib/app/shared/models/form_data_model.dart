import 'package:equatable/equatable.dart';

enum FormStatus {
  inProgress,
  completed,
}

enum FormType {
  riskAnalysis,
  ede, // Evaluación del daño en edificaciones
}

class FormDataModel extends Equatable {
  final String id;
  final String title;
  final String eventType; // 'Movimiento en Masa', 'Inundación', etc.
  final FormType formType;
  final FormStatus status;
  final DateTime createdAt;
  final DateTime lastModified;
  final double progressPercentage;
  final double threatProgress;
  final double vulnerabilityProgress;
  
  // Datos específicos del formulario de análisis de riesgo
  final Map<String, dynamic> riskAnalysisData;
  
  // Datos específicos del formulario EDE
  final Map<String, dynamic> edeData;

  const FormDataModel({
    required this.id,
    required this.title,
    required this.eventType,
    required this.formType,
    required this.status,
    required this.createdAt,
    required this.lastModified,
    this.progressPercentage = 0.0,
    this.threatProgress = 0.0,
    this.vulnerabilityProgress = 0.0,
    this.riskAnalysisData = const {},
    this.edeData = const {},
  });

  FormDataModel copyWith({
    String? id,
    String? title,
    String? eventType,
    FormType? formType,
    FormStatus? status,
    DateTime? createdAt,
    DateTime? lastModified,
    double? progressPercentage,
    double? threatProgress,
    double? vulnerabilityProgress,
    Map<String, dynamic>? riskAnalysisData,
    Map<String, dynamic>? edeData,
  }) {
    return FormDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      formType: formType ?? this.formType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      threatProgress: threatProgress ?? this.threatProgress,
      vulnerabilityProgress: vulnerabilityProgress ?? this.vulnerabilityProgress,
      riskAnalysisData: riskAnalysisData ?? this.riskAnalysisData,
      edeData: edeData ?? this.edeData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'eventType': eventType,
      'formType': formType.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'progressPercentage': progressPercentage,
      'threatProgress': threatProgress,
      'vulnerabilityProgress': vulnerabilityProgress,
      'riskAnalysisData': riskAnalysisData,
      'edeData': edeData,
    };
  }

  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      id: json['id'] as String,
      title: json['title'] as String,
      eventType: json['eventType'] as String,
      formType: FormType.values.firstWhere(
        (e) => e.name == json['formType'],
        orElse: () => FormType.riskAnalysis,
      ),
      status: FormStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FormStatus.inProgress,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      threatProgress: (json['threatProgress'] as num?)?.toDouble() ?? 0.0,
      vulnerabilityProgress: (json['vulnerabilityProgress'] as num?)?.toDouble() ?? 0.0,
      riskAnalysisData: json['riskAnalysisData'] as Map<String, dynamic>? ?? {},
      edeData: json['edeData'] as Map<String, dynamic>? ?? {},
    );
  }

  String get formattedLastModified {
    final now = DateTime.now();
    final difference = now.difference(lastModified);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        eventType,
        formType,
        status,
        createdAt,
        lastModified,
        progressPercentage,
        threatProgress,
        vulnerabilityProgress,
        riskAnalysisData,
        edeData,
      ];
}