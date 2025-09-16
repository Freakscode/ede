import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:flutter/material.dart';

class RiskEventsScreen extends StatelessWidget {
  const RiskEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: true,
        showInfo: true,
        showProfile: true,
      ),
      body: const Center(
        child: Text('Pantalla de eventos de riesgo'),
      ),
    );
  }
}
