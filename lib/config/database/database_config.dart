class DatabaseConfig {
  static const host = String.fromEnvironment('DB_HOST', defaultValue: 'localhost');
  static const port = int.fromEnvironment('DB_PORT', defaultValue: 5433);
  static const database = String.fromEnvironment('DB_NAME', defaultValue: 'EDE_DB');
  static const username = String.fromEnvironment('DB_USER', defaultValue: 'postgres');
  static const password = String.fromEnvironment('DB_PASSWORD', defaultValue: 'admin123');
}