import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Environment {
  static String get fileName => ".env";

  static String get jwtSecret => dotenv.env['JWT_SECRET'] ?? '';
  static int get jwtExpirationDays => int.tryParse(dotenv.env['JWT_EXPIRATION_DAYS'] ?? '') ?? 30;
  static String get userBackend => dotenv.env['username'] ?? '';
  static String get passwordBackend => dotenv.env['password'] ?? '';
}