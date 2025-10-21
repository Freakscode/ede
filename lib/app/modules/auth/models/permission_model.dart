import 'package:equatable/equatable.dart';

/// Modelo para un permiso de usuario
class PermissionModel extends Equatable {
  final String name;
  final String? description;
  final bool? active;

  const PermissionModel({
    required this.name,
    this.description,
    this.active,
  });

  /// Factory method: Crear desde JSON de la API
  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      active: json['active'] as bool?,
    );
  }

  /// Factory method: Crear desde string (para permisos simples)
  factory PermissionModel.fromString(String permissionName) {
    return PermissionModel(name: permissionName);
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'active': active,
    };
  }

  /// Verificar si el permiso está activo
  bool get isActive => active ?? true;

  /// Verificar si tiene un permiso específico
  bool hasPermission(String permissionName) {
    return name.toLowerCase() == permissionName.toLowerCase();
  }

  /// Verificar si tiene alguno de los permisos especificados
  bool hasAnyPermission(List<String> permissionNames) {
    return permissionNames.any((permission) => hasPermission(permission));
  }

  @override
  List<Object?> get props => [name, description, active];

  @override
  String toString() {
    return 'PermissionModel(name: $name, description: $description, active: $active)';
  }
}
