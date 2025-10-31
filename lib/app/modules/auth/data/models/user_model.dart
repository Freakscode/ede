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

  /// Usuario DAGRD simulado
  static const UserModel dagrdUser = UserModel(
    cedula: '12345678',
    nombre: 'Usuario DAGRD',
    isDagrdUser: true,
    cargo: 'Bombero',
    dependencia: 'DAGRD',
    email: 'usuario.dagrd@alcaldiabogota.gov.co',
    telefono: '3001234567',
  );

  /// Usuario general simulado
  static const UserModel generalUser = UserModel(
    cedula: '87654321',
    nombre: 'Usuario General',
    isDagrdUser: false,
    email: 'usuario.general@example.com',
    telefono: '3007654321',
  );

  /// Lista de usuarios simulados para el login
  static const List<UserModel> simulatedUsers = [
    dagrdUser,
    generalUser,
    UserModel(
      cedula: '11111111',
      nombre: 'Juan Pérez',
      isDagrdUser: true,
      cargo: 'Oficial',
      dependencia: 'DAGRD',
      email: 'juan.perez@alcaldiabogota.gov.co',
      telefono: '3001111111',
    ),
    UserModel(
      cedula: '22222222',
      nombre: 'María García',
      isDagrdUser: false,
      email: 'maria.garcia@example.com',
      telefono: '3002222222',
    ),
    UserModel(
      cedula: '33333333',
      nombre: 'Carlos López',
      isDagrdUser: true,
      cargo: 'Capitán',
      dependencia: 'DAGRD',
      email: 'carlos.lopez@alcaldiabogota.gov.co',
      telefono: '3003333333',
    ),
    UserModel(
      cedula: '44444444',
      nombre: 'Ana Rodríguez',
      isDagrdUser: false,
      email: 'ana.rodriguez@example.com',
      telefono: '3004444444',
    ),
  ];

  /// Obtener todos los usuarios DAGRD simulados
  static List<UserModel> get simulatedDagrdUsers {
    return simulatedUsers.where((user) => user.isDagrdUser).toList();
  }

  /// Obtener usuario DAGRD por índice
  static UserModel getSimulatedDagrdUserByIndex(int index) {
    final dagrdUsers = simulatedDagrdUsers;
    if (index >= 0 && index < dagrdUsers.length) {
      return dagrdUsers[index];
    }
    return dagrdUser; // Fallback al usuario DAGRD por defecto
  }

  /// Obtener usuario DAGRD por cédula
  static UserModel getSimulatedDagrdUserByCedula(String cedula) {
    final user = simulatedUsers.firstWhere(
      (user) => user.cedula == cedula,
      orElse: () => dagrdUser,
    );
    return user.isDagrdUser ? user : dagrdUser;
  }

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
    return UserModel(
      cedula: data['cedula'] ?? '',
      nombre: data['nombre'] ?? '',
      isDagrdUser: data['isDagrdUser'] ?? false,
      cargo: data['cargo'],
      dependencia: data['dependencia'],
      email: data['email'],
      telefono: data['telefono'],
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
