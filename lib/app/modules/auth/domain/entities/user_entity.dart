import 'package:equatable/equatable.dart';

/// Entidad de usuario en el dominio
/// Representa la lógica de negocio pura del usuario
class UserEntity extends Equatable {
  final String cedula;
  final String nombre;
  final bool isDagrdUser;
  final String? cargo;
  final String? dependencia;
  final String? email;
  final String? telefono;

  const UserEntity({
    required this.cedula,
    required this.nombre,
    required this.isDagrdUser,
    this.cargo,
    this.dependencia,
    this.email,
    this.telefono,
  });

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
  String toString() => 'UserEntity(cedula: $cedula, nombre: $nombre, isDagrdUser: $isDagrdUser)';
}
