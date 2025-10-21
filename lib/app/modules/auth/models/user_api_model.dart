import 'package:equatable/equatable.dart';
import 'persona_model.dart';
import 'role_model.dart';

/// Modelo para el usuario tal como viene de la API
class UserApiModel extends Equatable {
  final int id;
  final String email;
  final String code;
  final bool status;
  final String estadoTexto;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PersonaModel persona;
  final List<RoleModel> roles;
  final List<String> roleNames;
  final List<String> permissions;

  const UserApiModel({
    required this.id,
    required this.email,
    required this.code,
    required this.status,
    required this.estadoTexto,
    required this.createdAt,
    required this.updatedAt,
    required this.persona,
    this.roles = const [],
    this.roleNames = const [],
    this.permissions = const [],
  });

  /// Factory method: Crear desde JSON de la API
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['id'] as int,
      email: json['email'] as String,
      code: json['code'] as String,
      status: json['status'] as bool,
      estadoTexto: json['estado_texto'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      persona: PersonaModel.fromJson(json['persona'] as Map<String, dynamic>),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => RoleModel.fromJson(role as Map<String, dynamic>))
          .toList() ?? [],
      roleNames: (json['role_names'] as List<dynamic>?)
          ?.map((name) => name as String)
          .toList() ?? [],
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((perm) => perm as String)
          .toList() ?? [],
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'code': code,
      'status': status,
      'estado_texto': estadoTexto,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'persona': persona.toJson(),
      'roles': roles.map((role) => role.toJson()).toList(),
      'role_names': roleNames,
      'permissions': permissions,
    };
  }

  /// Verificar si el usuario está activo
  bool get isActive => status;

  /// Obtener nombre completo del usuario
  String get nombreCompleto => persona.nombreCompletoDisplay;

  /// Obtener identificación del usuario
  String get identificacion => persona.identificacion;

  /// Obtener profesión/cargo del usuario
  String? get profesion => persona.profesion;

  /// Obtener teléfono principal del usuario
  String? get telefonoPrincipal => persona.numeroTelefonoPrincipal;

  /// Verificar si tiene un rol específico
  bool hasRole(String roleName) {
    return roles.any((role) => role.isRole(roleName)) ||
           roleNames.contains(roleName);
  }

  /// Verificar si tiene alguno de los roles especificados
  bool hasAnyRole(List<String> roleNames) {
    return roles.any((role) => role.isAnyRole(roleNames)) ||
           roleNames.any((roleName) => this.roleNames.contains(roleName));
  }

  /// Verificar si es usuario DAGRD (tiene rol de Bombero)
  bool get isDagrdUser {
    return hasRole('Bombero') || 
           hasAnyRole(['Bombero', 'Oficial', 'Capitán', 'Teniente']);
  }

  /// Verificar si tiene un permiso específico
  bool hasPermission(String permissionName) {
    return permissions.contains(permissionName) ||
           roles.any((role) => role.hasPermission(permissionName));
  }

  /// Verificar si tiene alguno de los permisos especificados
  bool hasAnyPermission(List<String> permissionNames) {
    return permissionNames.any((permission) => hasPermission(permission));
  }

  /// Verificar si tiene todos los permisos especificados
  bool hasAllPermissions(List<String> permissionNames) {
    return permissionNames.every((permission) => hasPermission(permission));
  }

  /// Obtener roles como texto
  String get rolesText => roleNames.join(', ');

  /// Obtener permisos como texto
  String get permissionsText => permissions.join(', ');

  @override
  List<Object?> get props => [
        id,
        email,
        code,
        status,
        estadoTexto,
        createdAt,
        updatedAt,
        persona,
        roles,
        roleNames,
        permissions,
      ];

  @override
  String toString() {
    return 'UserApiModel(id: $id, email: $email, nombreCompleto: $nombreCompleto, isDagrdUser: $isDagrdUser)';
  }
}
