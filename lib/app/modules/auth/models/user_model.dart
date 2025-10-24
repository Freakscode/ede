import 'package:equatable/equatable.dart';
import 'user_api_model.dart';

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

  /// Obtener todos los usuarios DAGRD simulados
  static List<UserModel> get simulatedDagrdUsers {
    return simulatedUsers.where((user) => user.isDagrdUser).toList();
  }

  /// Obtener usuario DAGRD simulado por índice
  static UserModel? getSimulatedDagrdUserByIndex(int index) {
    final dagrdUsers = simulatedDagrdUsers;
    if (index >= 0 && index < dagrdUsers.length) {
      return dagrdUsers[index];
    }
    return null;
  }

  /// Obtener usuario DAGRD simulado basado en cédula (para consistencia)
  static UserModel getSimulatedDagrdUserByCedula(String cedula) {
    final dagrdUsers = simulatedDagrdUsers;
    if (dagrdUsers.isEmpty) {
      return simulatedUsers.first; // Fallback
    }
    
    final cedulaHash = cedula.trim().hashCode.abs();
    return dagrdUsers[cedulaHash % dagrdUsers.length];
  }

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

  /// Factory method: Crear usuario desde UserApiModel
  static UserModel fromUserApiModel(UserApiModel userApi) {
    return UserModel(
      cedula: userApi.identificacion,
      nombre: userApi.nombreCompleto,
      isDagrdUser: userApi.isDagrdUser,
      cargo: userApi.profesion,
      dependencia: userApi.isDagrdUser ? 'DAGRD' : null,
      email: userApi.email,
      telefono: userApi.telefonoPrincipal,
    );
  }

  /// Factory method: Crear usuario desde respuesta de API (método legacy)
  static UserModel fromApiResponse(Map<String, dynamic> apiData) {
    final userData = apiData['user'];
    final personaData = userData['persona'];
    final roles = userData['roles'] as List<dynamic>;
    
    // Determinar si es usuario DAGRD basado en los roles
    final isDagrdUser = roles.any((role) => 
      role['name'] == 'Bombero' || 
      role['display_name'] == 'Bombero'
    );
    
    // Obtener nombre completo
    final nombreCompleto = personaData['nombre_completo'] ?? 
                          '${personaData['nombres']['nombre1'] ?? ''} ${personaData['apellidos']['apellido1'] ?? ''}'.trim();
    
    // Obtener cargo (profesión)
    final cargo = personaData['profesion'];
    
    // Obtener teléfono (primer teléfono si existe)
    String? telefono;
    final telefonos = personaData['telefonos'] as List<dynamic>?;
    if (telefonos != null && telefonos.isNotEmpty) {
      telefono = telefonos.first['numero'] ?? telefonos.first['telefono'];
    }
    
    return UserModel(
      cedula: personaData['identificacion'] ?? userData['code'] ?? '',
      nombre: nombreCompleto,
      isDagrdUser: isDagrdUser,
      cargo: cargo,
      dependencia: isDagrdUser ? 'DAGRD' : null,
      email: userData['email'],
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