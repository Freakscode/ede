class InspectionData {
  final String incidentId;
  final String status;
  final DateTime date;
  final String time;
  final String comment;
  final int injured;
  final int dead;

  const InspectionData({
    required this.incidentId,
    required this.status,
    required this.date,
    required this.time,
    required this.comment,
    required this.injured,
    required this.dead,
  });

  Map<String, dynamic> toJson() {
    return {
      'incidentId': incidentId,
      'status': status,
      'date': date.toIso8601String(),
      'time': time,
      'comment': comment,
      'injured': injured,
      'dead': dead,
    };
  }

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      incidentId: json['incidentId'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      comment: json['comment'] as String,
      injured: json['injured'] as int,
      dead: json['dead'] as int,
    );
  }

  InspectionData copyWith({
    String? incidentId,
    String? status,
    DateTime? date,
    String? time,
    String? comment,
    int? injured,
    int? dead,
  }) {
    return InspectionData(
      incidentId: incidentId ?? this.incidentId,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      comment: comment ?? this.comment,
      injured: injured ?? this.injured,
      dead: dead ?? this.dead,
    );
  }

  @override
  String toString() {
    return 'InspectionData(incidentId: $incidentId, status: $status, date: $date, time: $time, comment: $comment, injured: $injured, dead: $dead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InspectionData &&
        other.incidentId == incidentId &&
        other.status == status &&
        other.date == date &&
        other.time == time &&
        other.comment == comment &&
        other.injured == injured &&
        other.dead == dead;
  }

  @override
  int get hashCode {
    return incidentId.hashCode ^
        status.hashCode ^
        date.hashCode ^
        time.hashCode ^
        comment.hashCode ^
        injured.hashCode ^
        dead.hashCode;
  }
}
