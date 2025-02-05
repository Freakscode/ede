import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:ede_final_app/environment.dart';

class SecurityConfig {
  static String generateSecretKey(){
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    final key= base64UrlEncode(values);

    return sha256.convert(utf8.encode(key)).toString();
  }

  static const String jwtSecretKey = Environment.jwtSecret;

}