import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import '../../../../presentation/blocs/form/habitabilidad/habitabilidad_state.dart';

class HabitabilidadPage extends StatelessWidget {
  const HabitabilidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitabilidad de la Edificación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<HabitabilidadBloc, HabitabilidadState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Criterio de Habitabilidad',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    _buildCriterioCard(state),
                    const SizedBox(height: 16),
                    _buildClasificacionInfo(state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCriterioCard(HabitabilidadState state) {
    Color backgroundColor;
    switch (state.criterioHabitabilidad) {
      case 'Habitable':
        backgroundColor = Colors.green;
        break;
      case 'Acceso restringido':
        backgroundColor = Colors.yellow;
        break;
      case 'No Habitable':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        state.criterioHabitabilidad ?? 'Pendiente de evaluación',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildClasificacionInfo(HabitabilidadState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        state.clasificacion ?? 'Pendiente de clasificación',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
} 