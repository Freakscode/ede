class EvaluacionModel {
  final String id;
  final String data;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;

  EvaluacionModel({
    required this.id,
    required this.data,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EvaluacionModel.fromJson(Map<String, dynamic> json) {
    return EvaluacionModel(
      id: json['id'],
      data: json['data'],
      synced: json['synced'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'synced': synced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  EvaluacionModel copyWith({
    String? id,
    String? data,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EvaluacionModel(
      id: id ?? this.id,
      data: data ?? this.data,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
