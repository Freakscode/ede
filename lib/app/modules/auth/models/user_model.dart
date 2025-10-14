import 'package:equatable/equatable.dart';

/// Modelo de usuario
/// Entidad de dominio para representar un usuario del sistema
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

  /// Lógica de negocio: ¿Es usuario válido?
  bool get isValid => cedula.isNotEmpty && nombre.isNotEmpty;

  /// Lógica de negocio: ¿Es usuario DAGRD?
  bool get isDagrdEmployee => isDagrdUser;

  /// Lógica de negocio: ¿Tiene información completa?
  bool get hasCompleteInfo => email != null && telefono != null;

  /// Lógica de negocio: ¿Puede acceder a funciones DAGRD?
  bool get canAccessDagrdFeatures => isDagrdUser;

  /// Lógica de negocio: ¿Puede acceder a funciones generales?
  bool get canAccessGeneralFeatures => isValid;

  /// Factory method: Crear usuario DAGRD
  static UserModel createDagrdUser({
    required String cedula,
    required String nombre,
    String? cargo,
    String? dependencia,
    String? email,
    String? telefono,
  }) {
    return UserModel(
      cedula: cedula,
      nombre: nombre,
      isDagrdUser: true,
      cargo: cargo,
      dependencia: dependencia ?? 'DAGRD',
      email: email,
      telefono: telefono,
    );
  }

  /// Factory method: Crear usuario general
  static UserModel createGeneralUser({
    required String cedula,
    required String nombre,
    String? email,
    String? telefono,
  }) {
    return UserModel(
      cedula: cedula,
      nombre: nombre,
      isDagrdUser: false,
      email: email,
      telefono: telefono,
    );
  }

  /// Método de negocio: Crear copia con cambios
  UserModel copyWith({
    String? cedula,
    String? nombre,
    bool? isDagrdUser,
    String? cargo,
    String? dependencia,
    String? email,
    String? telefono,
  }) {
    return UserModel(
      cedula: cedula ?? this.cedula,
      nombre: nombre ?? this.nombre,
      isDagrdUser: isDagrdUser ?? this.isDagrdUser,
      cargo: cargo ?? this.cargo,
      dependencia: dependencia ?? this.dependencia,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
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
  String toString() {
    return 'UserModel(cedula: $cedula, nombre: $nombre, isDagrdUser: $isDagrdUser, '
           'cargo: $cargo, dependencia: $dependencia, email: $email, telefono: $telefono)';
  }
}