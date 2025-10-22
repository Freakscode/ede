import 'package:caja_herramientas/app/modules/home/presentation/widgets/event_card.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RiskEventsScreen extends StatelessWidget {
  const RiskEventsScreen({super.key});



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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: RiskEventFactory.getAllEvents().length,
                itemBuilder: (context, index) {
                  final riskEvent = RiskEventFactory.getAllEvents()[index];
                  final homeBloc = context.read<HomeBloc>();
                  
                  return EventCard(
                    iconAsset: riskEvent.iconAsset,
                    title: riskEvent.name,
                    onTap: () {
                      print('=== RiskEventsScreen: Evento seleccionado ===');
                      print('Evento: ${riskEvent.name}');
                      print('IconAsset: ${riskEvent.iconAsset}');
                      homeBloc.add(
                        SelectRiskEvent(riskEvent.name),
                      );
                      print('=== RiskEventsScreen: Evento enviado al HomeBloc ===');
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
