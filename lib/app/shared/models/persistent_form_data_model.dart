import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PersistentFormDataModel extends Equatable {
  final String id;
  final String eventName;
  final String classificationType;
  final Map<String, Map<String, String>> dynamicSelections;
  final Map<String, double> subClassificationScores;
  final Map<String, dynamic> subClassificationColors;
  final Map<String, String> probabilidadSelections;
  final Map<String, String> intensidadSelections;
  final String? selectedProbabilidad;
  final String? selectedIntensidad;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PersistentFormDataModel({
    required this.id,
    required this.eventName,
    required this.classificationType,
    required this.dynamicSelections,
    required this.subClassificationScores,
    required this.subClassificationColors,
    required this.probabilidadSelections,
    required this.intensidadSelections,
    this.selectedProbabilidad,
    this.selectedIntensidad,
    required this.createdAt,
    required this.updatedAt,
  });

  PersistentFormDataModel copyWith({
    String? id,
    String? eventName,
    String? classificationType,
    Map<String, Map<String, String>>? dynamicSelections,
    Map<String, double>? subClassificationScores,
    Map<String, dynamic>? subClassificationColors,
    Map<String, String>? probabilidadSelections,
    Map<String, String>? intensidadSelections,
    String? selectedProbabilidad,
    String? selectedIntensidad,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PersistentFormDataModel(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      classificationType: classificationType ?? this.classificationType,
      dynamicSelections: dynamicSelections ?? this.dynamicSelections,
      subClassificationScores: subClassificationScores ?? this.subClassificationScores,
      subClassificationColors: subClassificationColors ?? this.subClassificationColors,
      probabilidadSelections: probabilidadSelections ?? this.probabilidadSelections,
      intensidadSelections: intensidadSelections ?? this.intensidadSelections,
      selectedProbabilidad: selectedProbabilidad ?? this.selectedProbabilidad,
      selectedIntensidad: selectedIntensidad ?? this.selectedIntensidad,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    // Convertir colores a valores enteros para serialización
    final serializableColors = <String, int>{};
    subClassificationColors.forEach((key, value) {
      if (value is Color) {
        serializableColors[key] = value.value;
      } else {
        serializableColors[key] = value as int;
      }
    });

    return {
      'id': id,
      'eventName': eventName,
      'classificationType': classificationType,
      'dynamicSelections': dynamicSelections,
      'subClassificationScores': subClassificationScores,
      'subClassificationColors': serializableColors,
      'probabilidadSelections': probabilidadSelections,
      'intensidadSelections': intensidadSelections,
      'selectedProbabilidad': selectedProbabilidad,
      'selectedIntensidad': selectedIntensidad,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PersistentFormDataModel.fromJson(Map<String, dynamic> json) {
    return PersistentFormDataModel(
      id: json['id'] as String,
      eventName: json['eventName'] as String,
      classificationType: json['classificationType'] as String,
      dynamicSelections: Map<String, Map<String, String>>.from(
        (json['dynamicSelections'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, Map<String, String>.from(value as Map<String, dynamic>)),
        ),
      ),
      subClassificationScores: Map<String, double>.from(
        json['subClassificationScores'] as Map<String, dynamic>,
      ),
      subClassificationColors: Map<String, dynamic>.from(
        (json['subClassificationColors'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, Color(value as int)),
        ),
      ),
      probabilidadSelections: Map<String, String>.from(
        json['probabilidadSelections'] as Map<String, dynamic>,
      ),
      intensidadSelections: Map<String, String>.from(
        json['intensidadSelections'] as Map<String, dynamic>,
      ),
      selectedProbabilidad: json['selectedProbabilidad'] as String?,
      selectedIntensidad: json['selectedIntensidad'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    eventName,
    classificationType,
    dynamicSelections,
    subClassificationScores,
    subClassificationColors,
    probabilidadSelections,
    intensidadSelections,
    selectedProbabilidad,
    selectedIntensidad,
    createdAt,
    updatedAt,
  ];
}
