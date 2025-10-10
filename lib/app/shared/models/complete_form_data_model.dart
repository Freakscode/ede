import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CompleteFormDataModel extends Equatable {
  final String id;
  final String eventName;
  
  // Datos de Amenaza
  final Map<String, Map<String, String>> amenazaSelections;
  final Map<String, double> amenazaScores;
  final Map<String, Color> amenazaColors;
  final Map<String, String> amenazaProbabilidadSelections;
  final Map<String, String> amenazaIntensidadSelections;
  final String? amenazaSelectedProbabilidad;
  final String? amenazaSelectedIntensidad;
  
  // Datos de Vulnerabilidad
  final Map<String, Map<String, String>> vulnerabilidadSelections;
  final Map<String, double> vulnerabilidadScores;
  final Map<String, Color> vulnerabilidadColors;
  final Map<String, String> vulnerabilidadProbabilidadSelections;
  final Map<String, String> vulnerabilidadIntensidadSelections;
  final String? vulnerabilidadSelectedProbabilidad;
  final String? vulnerabilidadSelectedIntensidad;
  
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isExplicitlyCompleted; // Indica si el formulario fue explícitamente marcado como completado

  const CompleteFormDataModel({
    required this.id,
    required this.eventName,
    required this.amenazaSelections,
    required this.amenazaScores,
    required this.amenazaColors,
    required this.amenazaProbabilidadSelections,
    required this.amenazaIntensidadSelections,
    this.amenazaSelectedProbabilidad,
    this.amenazaSelectedIntensidad,
    required this.vulnerabilidadSelections,
    required this.vulnerabilidadScores,
    required this.vulnerabilidadColors,
    required this.vulnerabilidadProbabilidadSelections,
    required this.vulnerabilidadIntensidadSelections,
    this.vulnerabilidadSelectedProbabilidad,
    this.vulnerabilidadSelectedIntensidad,
    required this.createdAt,
    required this.updatedAt,
    this.isExplicitlyCompleted = false, // Por defecto, no está explícitamente completado
  });

  CompleteFormDataModel copyWith({
    String? id,
    String? eventName,
    Map<String, Map<String, String>>? amenazaSelections,
    Map<String, double>? amenazaScores,
    Map<String, Color>? amenazaColors,
    Map<String, String>? amenazaProbabilidadSelections,
    Map<String, String>? amenazaIntensidadSelections,
    String? amenazaSelectedProbabilidad,
    String? amenazaSelectedIntensidad,
    Map<String, Map<String, String>>? vulnerabilidadSelections,
    Map<String, double>? vulnerabilidadScores,
    Map<String, Color>? vulnerabilidadColors,
    Map<String, String>? vulnerabilidadProbabilidadSelections,
    Map<String, String>? vulnerabilidadIntensidadSelections,
    String? vulnerabilidadSelectedProbabilidad,
    String? vulnerabilidadSelectedIntensidad,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isExplicitlyCompleted,
  }) {
    return CompleteFormDataModel(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      amenazaSelections: amenazaSelections ?? this.amenazaSelections,
      amenazaScores: amenazaScores ?? this.amenazaScores,
      amenazaColors: amenazaColors ?? this.amenazaColors,
      amenazaProbabilidadSelections: amenazaProbabilidadSelections ?? this.amenazaProbabilidadSelections,
      amenazaIntensidadSelections: amenazaIntensidadSelections ?? this.amenazaIntensidadSelections,
      amenazaSelectedProbabilidad: amenazaSelectedProbabilidad ?? this.amenazaSelectedProbabilidad,
      amenazaSelectedIntensidad: amenazaSelectedIntensidad ?? this.amenazaSelectedIntensidad,
      vulnerabilidadSelections: vulnerabilidadSelections ?? this.vulnerabilidadSelections,
      vulnerabilidadScores: vulnerabilidadScores ?? this.vulnerabilidadScores,
      vulnerabilidadColors: vulnerabilidadColors ?? this.vulnerabilidadColors,
      vulnerabilidadProbabilidadSelections: vulnerabilidadProbabilidadSelections ?? this.vulnerabilidadProbabilidadSelections,
      vulnerabilidadIntensidadSelections: vulnerabilidadIntensidadSelections ?? this.vulnerabilidadIntensidadSelections,
      vulnerabilidadSelectedProbabilidad: vulnerabilidadSelectedProbabilidad ?? this.vulnerabilidadSelectedProbabilidad,
      vulnerabilidadSelectedIntensidad: vulnerabilidadSelectedIntensidad ?? this.vulnerabilidadSelectedIntensidad,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isExplicitlyCompleted: isExplicitlyCompleted ?? this.isExplicitlyCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    // Convertir colores a valores enteros para serialización
    final serializableAmenazaColors = <String, int>{};
    amenazaColors.forEach((key, value) {
      serializableAmenazaColors[key] = value.value;
    });
    
    final serializableVulnerabilidadColors = <String, int>{};
    vulnerabilidadColors.forEach((key, value) {
      serializableVulnerabilidadColors[key] = value.value;
    });

    return {
      'id': id,
      'eventName': eventName,
      'amenazaSelections': amenazaSelections,
      'amenazaScores': amenazaScores,
      'amenazaColors': serializableAmenazaColors,
      'amenazaProbabilidadSelections': amenazaProbabilidadSelections,
      'amenazaIntensidadSelections': amenazaIntensidadSelections,
      'amenazaSelectedProbabilidad': amenazaSelectedProbabilidad,
      'amenazaSelectedIntensidad': amenazaSelectedIntensidad,
      'vulnerabilidadSelections': vulnerabilidadSelections,
      'vulnerabilidadScores': vulnerabilidadScores,
      'vulnerabilidadColors': serializableVulnerabilidadColors,
      'vulnerabilidadProbabilidadSelections': vulnerabilidadProbabilidadSelections,
      'vulnerabilidadIntensidadSelections': vulnerabilidadIntensidadSelections,
      'vulnerabilidadSelectedProbabilidad': vulnerabilidadSelectedProbabilidad,
      'vulnerabilidadSelectedIntensidad': vulnerabilidadSelectedIntensidad,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isExplicitlyCompleted': isExplicitlyCompleted,
    };
  }

  factory CompleteFormDataModel.fromJson(Map<String, dynamic> json) {
    // Convertir valores enteros de vuelta a Color para amenaza
    final amenazaColorsData = Map<String, int>.from(json['amenazaColors'] as Map<String, dynamic>);
    final deserializedAmenazaColors = <String, Color>{};
    amenazaColorsData.forEach((key, value) {
      deserializedAmenazaColors[key] = Color(value);
    });
    
    // Convertir valores enteros de vuelta a Color para vulnerabilidad
    final vulnerabilidadColorsData = Map<String, int>.from(json['vulnerabilidadColors'] as Map<String, dynamic>);
    final deserializedVulnerabilidadColors = <String, Color>{};
    vulnerabilidadColorsData.forEach((key, value) {
      deserializedVulnerabilidadColors[key] = Color(value);
    });

    return CompleteFormDataModel(
      id: json['id'] as String,
      eventName: json['eventName'] as String,
      amenazaSelections: Map<String, Map<String, String>>.from(
        (json['amenazaSelections'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, Map<String, String>.from(value as Map<String, dynamic>)),
        ),
      ),
      amenazaScores: Map<String, double>.from(
        json['amenazaScores'] as Map<String, dynamic>,
      ),
      amenazaColors: deserializedAmenazaColors,
      amenazaProbabilidadSelections: Map<String, String>.from(
        json['amenazaProbabilidadSelections'] as Map<String, dynamic>,
      ),
      amenazaIntensidadSelections: Map<String, String>.from(
        json['amenazaIntensidadSelections'] as Map<String, dynamic>,
      ),
      amenazaSelectedProbabilidad: json['amenazaSelectedProbabilidad'] as String?,
      amenazaSelectedIntensidad: json['amenazaSelectedIntensidad'] as String?,
      vulnerabilidadSelections: Map<String, Map<String, String>>.from(
        (json['vulnerabilidadSelections'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, Map<String, String>.from(value as Map<String, dynamic>)),
        ),
      ),
      vulnerabilidadScores: Map<String, double>.from(
        json['vulnerabilidadScores'] as Map<String, dynamic>,
      ),
      vulnerabilidadColors: deserializedVulnerabilidadColors,
      vulnerabilidadProbabilidadSelections: Map<String, String>.from(
        json['vulnerabilidadProbabilidadSelections'] as Map<String, dynamic>,
      ),
      vulnerabilidadIntensidadSelections: Map<String, String>.from(
        json['vulnerabilidadIntensidadSelections'] as Map<String, dynamic>,
      ),
      vulnerabilidadSelectedProbabilidad: json['vulnerabilidadSelectedProbabilidad'] as String?,
      vulnerabilidadSelectedIntensidad: json['vulnerabilidadSelectedIntensidad'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isExplicitlyCompleted: json['isExplicitlyCompleted'] as bool? ?? false,
    );
  }

  // Métodos de conveniencia para verificar el estado del formulario
  bool get isAmenazaCompleted => amenazaSelections.isNotEmpty;
  bool get isVulnerabilidadCompleted => vulnerabilidadSelections.isNotEmpty;
  bool get isComplete => isExplicitlyCompleted; // Solo está completo si fue explícitamente marcado como tal

  @override
  List<Object?> get props => [
    id,
    eventName,
    amenazaSelections,
    amenazaScores,
    amenazaColors,
    amenazaProbabilidadSelections,
    amenazaIntensidadSelections,
    amenazaSelectedProbabilidad,
    amenazaSelectedIntensidad,
    vulnerabilidadSelections,
    vulnerabilidadScores,
    vulnerabilidadColors,
    vulnerabilidadProbabilidadSelections,
    vulnerabilidadIntensidadSelections,
    vulnerabilidadSelectedProbabilidad,
    vulnerabilidadSelectedIntensidad,
    createdAt,
    updatedAt,
    isExplicitlyCompleted,
  ];
}
