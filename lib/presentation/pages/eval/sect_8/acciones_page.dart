import 'package:ede_final_app/presentation/blocs/form/acciones/acciones_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/acciones/acciones_event.dart';
import 'package:ede_final_app/presentation/blocs/form/acciones/acciones_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccionesPage extends StatelessWidget {
  const AccionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acciones Recomendadas y Medidas de Seguridad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEvaluacionAdicional(),
            const SizedBox(height: 16),
            _buildRecomendaciones(),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluacionAdicional() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '8.1 Evaluación adicional',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildEvaluacionField(
                      context,
                      'Estructural',
                      state.evaluacionAdicional['Estructural'] ?? '',
                    ),
                    const SizedBox(height: 8),
                    _buildEvaluacionField(
                      context,
                      'Geotécnica',
                      state.evaluacionAdicional['Geotécnica'] ?? '',
                    ),
                    const SizedBox(height: 8),
                    _buildEvaluacionField(
                      context,
                      'Otra',
                      state.evaluacionAdicional['Otra'] ?? '',
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

  Widget _buildRecomendaciones() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '8.2 Recomendaciones y medidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AccionesBloc, AccionesState>(
              builder: (context, state) {
                return Column(
                  children: [
                    ...state.recomendaciones.entries.map((e) => CheckboxListTile(
                      title: Text(_getRecomendacionText(e.key)),
                      value: e.value,
                      onChanged: (value) {
                        context.read<AccionesBloc>().add(
                          SetRecomendacion(
                            recomendacion: e.key,
                            valor: value ?? false,
                          ),
                        );
                      },
                    )),
                    const Divider(),
                    ...state.entidadesRecomendadas.entries.map((e) {
                      if (e.key == 'Otra') {
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('Se recomienda la intervención de otra entidad'),
                              value: e.value,
                              onChanged: (value) {
                                context.read<AccionesBloc>().add(
                                  SetEntidadRecomendada(
                                    entidad: e.key,
                                    valor: value ?? false,
                                  ),
                                );
                              },
                            ),
                            if (e.value)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: '¿Cuál?',
                                  ),
                                  initialValue: state.otraEntidad,
                                  onChanged: (value) {
                                    context.read<AccionesBloc>().add(
                                      SetEntidadRecomendada(
                                        entidad: e.key,
                                        valor: true,
                                        otraEntidad: value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        );
                      }
                      return CheckboxListTile(
                        title: Text('Se recomienda intervención de ${e.key}'),
                        value: e.value,
                        onChanged: (value) {
                          context.read<AccionesBloc>().add(
                            SetEntidadRecomendada(
                              entidad: e.key,
                              valor: value ?? false,
                            ),
                          );
                        },
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluacionField(BuildContext context, String tipo, String valor) {
    return Row(
      children: [
        Checkbox(
          value: valor.isNotEmpty,
          onChanged: (value) {
            if (value == false) {
              context.read<AccionesBloc>().add(
                SetEvaluacionAdicional(
                  tipo: tipo,
                  descripcion: '',
                ),
              );
            }
          },
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: tipo,
              enabled: valor.isNotEmpty,
            ),
            initialValue: valor,
            onChanged: (value) {
              context.read<AccionesBloc>().add(
                SetEvaluacionAdicional(
                  tipo: tipo,
                  descripcion: value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getRecomendacionText(String key) {
    final textos = {
      'restringirPeatones': 'Restringir paso de peatones',
      'restringirVehiculos': 'Restringir paso de vehículos pesados',
      'evacuarParcialmente': 'Evacuar parcialmente la edificación',
      'evacuarTotalmente': 'Evacuar totalmente la edificación',
      'evacuarVecinas': 'Evacuar edificaciones vecinas',
      'vigilanciaPermanente': 'Establecer vigilancia permanente',
      'monitoreoEstructural': 'Monitoreo estructural',
      'aislamiento': 'Aislamiento en las siguientes áreas',
      'apuntalar': 'Apuntalar o asegurar elementos en riesgo de caer',
      'demoler': 'Demoler elementos en peligro de caer',
      'manejoSustancias': 'Manejo de sustancias peligrosas',
      'desconectarServicios': 'Desconectar servicios públicos',
      'seguimiento': 'Seguimiento',
    };
    return textos[key] ?? key;
  }
} 