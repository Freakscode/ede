class EvaluacionEntity {
  final String id;
  final String data;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;

  EvaluacionEntity({
    required this.id,
    required this.data,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  EvaluacionEntity copyWith({
    String? id,
    String? data,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EvaluacionEntity(
      id: id ?? this.id,
      data: data ?? this.data,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EvaluacionEntity &&
      other.id == id &&
      other.data == data &&
      other.synced == synced &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ 
      data.hashCode ^ 
      synced.hashCode ^ 
      createdAt.hashCode ^ 
      updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'EvaluacionEntity(id: $id, data: $data, synced: $synced, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
