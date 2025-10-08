import 'package:equatable/equatable.dart';
import 'risk_event_model.dart';

enum FormStatus { inProgress, completed }

class FormDataModel extends Equatable {
  final String id;
  final String title;
  final FormStatus status;
  final DateTime createdAt;
  final DateTime lastModified;

  final RiskEventModel? riskEvent;

  const FormDataModel({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.lastModified,
    this.riskEvent,
  });

  FormDataModel copyWith({
    String? id,
    String? title,
    FormStatus? status,
    DateTime? createdAt,
    DateTime? lastModified,
    RiskEventModel? riskEvent,
    Map<String, dynamic>? edeData,
  }) {
    return FormDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      riskEvent: riskEvent ?? this.riskEvent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'riskEvent': riskEvent?.toMap(),
    };
  }

  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      id: json['id'] as String,
      title: json['title'] as String,

      status: FormStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FormStatus.inProgress,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),

      riskEvent: json['riskEvent'] != null
          ? RiskEventModel.fromMap(json['riskEvent'] as Map<String, dynamic>)
          : null,
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
    status,
    createdAt,
    lastModified,
    riskEvent,
  ];
}
