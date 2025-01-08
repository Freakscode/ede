import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_event.dart';
import '../../../../presentation/blocs/form/evaluacionDanos/evaluacion_danos_state.dart';

class EvaluacionDanosPage extends StatelessWidget {
  const EvaluacionDanosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de Daños en la Edificación'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCondicionesExistentes(),
              const SizedBox(height: 24),
              _buildNivelesElementos(),
              const SizedBox(height: 24),
              _buildAlcanceEvaluacion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCondicionesExistentes() {
    final condiciones = {
      '5.1': 'Colapso total',
      '5.2': 'Colapso parcial',
      '5.3': 'Asentamiento severo en elementos estructurales',
      '5.4': 'Inclinación o desviación importante de la edificación o de un piso',
      '5.5': 'Problemas de inestabilidad en el suelo de cimentación (Movimiento en masa, licuefacción, subsidencia, cambios volumétricos, asentamientos)',
      '5.6': 'Riesgo de caídas de elementos de la edificación (antepechos, fachadas, ventanas, etc.)',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Determinar la existencia de las siguientes Condiciones:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  children: condiciones.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: state.condicionesExistentes[entry.key],
                            onChanged: (value) {
                              context.read<EvaluacionDanosBloc>().add(
                                SetCondicionExistente(entry.key, value),
                              );
                            },
                          ),
                          const Text('Sí'),
                          Radio<bool>(
                            value: false,
                            groupValue: state.condicionesExistentes[entry.key],
                            onChanged: (value) {
                              context.read<EvaluacionDanosBloc>().add(
                                SetCondicionExistente(entry.key, value),
                              );
                            },
                          ),
                          const Text('No'),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNivelesElementos() {
    final elementos = {
      '5.7': 'Daño en muros de carga, columnas, y otros elementos estructurales primordiales',
      '5.8': 'Daño en sistemas de contrapiso, entrepiso, muros de contención',
      '5.9': 'Daño en muros divisorios, muros de fachada, antepechos, barandas',
      '5.10': 'Cubierta (recubrimiento y estructura de soporte)',
      '5.11': 'Cielo raso, escaleras, instalaciones y otros elementos no estructurales diferentes a muros',
    };

    final niveles = ['Sin daño', 'Leve', 'Moderado', 'Severo'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Establecer el nivel de daño de los siguientes elementos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Column(
                  children: elementos.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: niveles.map((nivel) {
                            return Row(
                              children: [
                                Radio<String>(
                                  value: nivel,
                                  groupValue: state.nivelesElementos[entry.key],
                                  onChanged: (value) {
                                    context.read<EvaluacionDanosBloc>().add(
                                      SetNivelElemento(entry.key, value!),
                                    );
                                  },
                                ),
                                Text(nivel),
                              ],
                            );
                          }).toList(),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcanceEvaluacion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alcance de la evaluación realizada',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Exterior:'),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Parcial',
                                groupValue: state.alcanceExterior,
                                onChanged: (value) {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetAlcanceEvaluacion(alcanceExterior: value),
                                  );
                                },
                              ),
                              const Text('Parcial'),
                              Radio<String>(
                                value: 'Completa',
                                groupValue: state.alcanceExterior,
                                onChanged: (value) {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetAlcanceEvaluacion(alcanceExterior: value),
                                  );
                                },
                              ),
                              const Text('Completa'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Interior:'),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'No Ingreso',
                                groupValue: state.alcanceInterior,
                                onChanged: (value) {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetAlcanceEvaluacion(alcanceInterior: value),
                                  );
                                },
                              ),
                              const Text('No Ingreso'),
                              Radio<String>(
                                value: 'Parcial',
                                groupValue: state.alcanceInterior,
                                onChanged: (value) {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetAlcanceEvaluacion(alcanceInterior: value),
                                  );
                                },
                              ),
                              const Text('Parcial'),
                              Radio<String>(
                                value: 'Completa',
                                groupValue: state.alcanceInterior,
                                onChanged: (value) {
                                  context.read<EvaluacionDanosBloc>().add(
                                    SetAlcanceEvaluacion(alcanceInterior: value),
                                  );
                                },
                              ),
                              const Text('Completa'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 