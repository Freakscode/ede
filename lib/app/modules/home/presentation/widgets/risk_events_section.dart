import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/risk_events/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiskEventsSection extends StatelessWidget {
  const RiskEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Metodología de Análisis del Riesgo',
                style: const TextStyle(
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20, // line-height / font-size
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Seleccione un evento',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF706F6F),
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 28 / 16, // line-height / font-size
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  EventCard(
                    iconAsset: AppIcons.movimientoMasa,
                    title: 'Movimiento en Masa',
                    onTap: () => context.go('/forms_history'),
                  ),
                  EventCard(
                    iconAsset: AppIcons.movimientoMasa,
                    title: 'Avenidas torrenciales',
                    onTap: () => context.go('/forms_history'),
                  ),
                  EventCard(
                    iconAsset: AppIcons.inundacionCH,
                    title: 'Inundación',
                    onTap: () => context.go('/forms_history'),
                  ),
                  EventCard(
                    iconAsset: AppIcons.estructuralCH,
                    title: 'Estructural',
                    onTap: () => context.go('/forms_history'),
                  ),
                  EventCard(
                    iconAsset: AppIcons.inundacionCH,
                    title: 'Inundación',
                    onTap: () => context.go('/forms_history'),
                  ),
                  EventCard(
                    iconAsset: AppIcons.estructuralCH,
                    title: 'Estructural',
                    onTap: () => context.go('/forms_history'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
