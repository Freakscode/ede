class UserModel {
  final int userId;
  final String cedula;
  final String nombreCompleto;
  final String dependencia;
  final String firma;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.cedula,
    required this.nombreCompleto,
    required this.dependencia,
    required this.firma,
    required this.createdAt,
  });

  // Para convertir desde un Map (respuesta de PostgreSQL) a un UserModel
  factory UserModel.fromRow(Map<String, dynamic> row) {
    return UserModel(
      userId: row['user_id'] as int,
      cedula: row['cedula'] as String,
      nombreCompleto: row['nombre_completo'] as String,
      dependencia: row['dependencia'] as String,
      firma: row['firma'] as String,
      createdAt: row['created_at'] as DateTime,
    );
  }
}