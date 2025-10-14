import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Widget de debug para mostrar usuarios disponibles
/// Solo para desarrollo - remover en producción
class AuthDebugWidget extends StatelessWidget {
  const AuthDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🔍 Usuarios de Prueba Disponibles:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...UserModel.simulatedUsers.map((user) {
            final userType = user.isDagrdUser ? 'DAGRD' : 'General';
            final color = user.isDagrdUser ? Colors.red : Colors.green;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Cédula: ${user.cedula} | ${user.nombre} | Tipo: $userType',
                style: TextStyle(
                  fontSize: 12,
                  color: color.shade700,
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          const Text(
            '💡 Usa cualquier contraseña con 4+ caracteres',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
