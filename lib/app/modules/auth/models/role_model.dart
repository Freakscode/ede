import 'package:equatable/equatable.dart';
import 'permission_model.dart';

/// Modelo para un rol de usuario
class RoleModel extends Equatable {
  final int id;
  final String name;
  final String? displayName;
  final String? description;
  final List<PermissionModel> permissions;
  final bool? active;

  const RoleModel({
    required this.id,
    required this.name,
    this.displayName,
    this.description,
    this.permissions = const [],
    this.active,
  });

  /// Factory method: Crear desde JSON de la API
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      displayName: json['display_name'] as String?,
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((perm) => PermissionModel.fromString(perm as String))
          .toList() ?? [],
      active: json['active'] as bool?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'permissions': permissions.map((perm) => perm.name).toList(),
      'active': active,
    };
  }

  /// Verificar si el rol está activo
  bool get isActive => active ?? true;

  /// Obtener nombre para mostrar
  String get displayNameOrName => displayName ?? name;

  /// Verificar si tiene un permiso específico
  bool hasPermission(String permissionName) {
    return permissions.any((permission) => permission.hasPermission(permissionName));
  }

  /// Verificar si tiene alguno de los permisos especificados
  bool hasAnyPermission(List<String> permissionNames) {
    return permissions.any((permission) => permission.hasAnyPermission(permissionNames));
  }

  /// Verificar si tiene todos los permisos especificados
  bool hasAllPermissions(List<String> permissionNames) {
    return permissionNames.every((permissionName) => hasPermission(permissionName));
  }

  /// Verificar si es un rol específico
  bool isRole(String roleName) {
    return name.toLowerCase() == roleName.toLowerCase() ||
           displayName?.toLowerCase() == roleName.toLowerCase();
  }

  /// Verificar si es alguno de los roles especificados
  bool isAnyRole(List<String> roleNames) {
    return roleNames.any((roleName) => isRole(roleName));
  }

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        permissions,
        active,
      ];

  @override
  String toString() {
    return 'RoleModel(id: $id, name: $name, displayName: $displayNameOrName)';
  }
}
