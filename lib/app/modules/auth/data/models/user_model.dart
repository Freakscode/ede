import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Modelo de datos para usuario
/// Mapea entre la capa de datos y el dominio
class UserModel extends Equatable {
  final String cedula;
  final String nombre;
  final bool isDagrdUser;
  final String? cargo;
  final String? dependencia;
  final String? email;
  final String? telefono;

  const UserModel({
    required this.cedula,
    required this.nombre,
    required this.isDagrdUser,
    this.cargo,
    this.dependencia,
    this.email,
    this.telefono,
  });

  /// Convertir a entidad del dominio
  UserEntity toEntity() {
    return UserEntity(
      cedula: cedula,
      nombre: nombre,
      isDagrdUser: isDagrdUser,
      cargo: cargo,
      dependencia: dependencia,
      email: email,
      telefono: telefono,
    );
  }

  /// Crear desde entidad del dominio
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      cedula: entity.cedula,
      nombre: entity.nombre,
      isDagrdUser: entity.isDagrdUser,
      cargo: entity.cargo,
      dependencia: entity.dependencia,
      email: entity.email,
      telefono: entity.telefono,
    );
  }

  /// Serialización para SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'nombre': nombre,
      'isDagrdUser': isDagrdUser,
      'cargo': cargo,
      'dependencia': dependencia,
      'email': email,
      'telefono': telefono,
    };
  }

  /// Deserialización desde SharedPreferences
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      cedula: json['cedula'] ?? '',
      nombre: json['nombre'] ?? '',
      isDagrdUser: json['isDagrdUser'] ?? false,
      cargo: json['cargo'],
      dependencia: json['dependencia'],
      email: json['email'],
      telefono: json['telefono'],
    );
  }

  /// Crear usuario desde respuesta de API
  factory UserModel.fromApiResponse(Map<String, dynamic> data) {
    // La estructura de la API es:
    // { id, email, code, persona: { identificacion, nombre_completo, telefonos, profesion } }
    final persona = data['persona'] as Map<String, dynamic>? ?? {};
    final telefonos = persona['telefonos'] as List<dynamic>? ?? [];
    final primerTelefono = telefonos.isNotEmpty ? telefonos[0] as Map<String, dynamic>? : null;
    
    // Determinar si es DAGRD basado en la profesión
    final profesion = persona['profesion'] as String? ?? '';
    final isDagrd = profesion.toLowerCase().contains('bombero');
    
    return UserModel(
      cedula: persona['identificacion'] ?? data['code'] ?? '',
      nombre: persona['nombre_completo'] ?? '',
      isDagrdUser: isDagrd,
      cargo: profesion.isNotEmpty ? profesion : null,
      dependencia: null,
      email: data['email'],
      telefono: primerTelefono?['numero'],
    );
  }

  @override
  List<Object?> get props => [
        cedula,
        nombre,
        isDagrdUser,
        cargo,
        dependencia,
        email,
        telefono,
      ];

  @override
  String toString() => 'UserModel(cedula: $cedula, nombre: $nombre, isDagrdUser: $isDagrdUser)';
}
