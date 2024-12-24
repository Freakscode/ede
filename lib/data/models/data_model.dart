class DataModel {
  final String id;
  final String title;
  final String description;
  final DateTime lastModified;
  final bool isSynced;

  DataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lastModified,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'lastModified': lastModified.toIso8601String(),
    'isSynced': isSynced,
  };

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    lastModified: DateTime.parse(json['lastModified']),
    isSynced: json['isSynced'] ?? false,
  );
}