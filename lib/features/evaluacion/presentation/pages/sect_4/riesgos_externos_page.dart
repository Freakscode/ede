import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/form/riesgosExternos/riesgos_externos_state.dart';
import '../../bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import '../../bloc/form/riesgosExternos/riesgos_externos_event.dart';
import '../../widgets/navigation_fab_menu.dart';

class RiesgosExternosPage extends StatelessWidget {
  const RiesgosExternosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final riesgos = {
      '4.1': 'Caída de objetos de edificios adyacentes',
      '4.2': 'Colapso o probable colapso de edificios adyacentes',
      '4.3': 'Falla en sistemas de distribución de servicios públicos (energía, gas, etc)',
      '4.4': 'Inestabilidad del terreno, movimientos en masa en el área',
      '4.5': 'Accesos y salidas',
      
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificación de Riesgos Externos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<RiesgosExternosBloc, RiesgosExternosState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Considerar las condiciones externas que pueden suponer un riesgo para la estructura ó sus ocupantes en caso de que existan.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ...riesgos.entries.map((riesgo) => _buildRiesgoItem(
                      context,
                      riesgo.key,
                      riesgo.value,
                      state.riesgos[riesgo.key],
                    )),
                    _buildOtroRiesgo(context, state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: const NavigationFabMenu(
        currentRoute: '/riesgos_externos',
      ),
    );
  }

  Widget _buildRiesgoItem(
    BuildContext context,
    String id,
    String descripcion,
    RiesgoItem? riesgo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(descripcion),
          value: riesgo?.existeRiesgo ?? false,
          onChanged: (value) {
            context.read<RiesgosExternosBloc>().add(
              SetRiesgoExterno(
                riesgoId: id,
                valor: value ?? false,
              ),
            );
          },
        ),
        if (riesgo?.existeRiesgo ?? false) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('b) Compromete accesos/ocupantes de la edificación'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sí'),
                        value: true,
                        groupValue: riesgo?.comprometeAccesos,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeAccesos(
                              riesgoId: id,
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: riesgo?.comprometeAccesos,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeAccesos(
                              riesgoId: id,
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Text('c) Compromete estabilidad de la edificación'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sí'),
                        value: true,
                        groupValue: riesgo?.comprometeEstabilidad,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeEstabilidad(
                              riesgoId: id,
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: riesgo?.comprometeEstabilidad,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeEstabilidad(
                              riesgoId: id,
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOtroRiesgo(BuildContext context, RiesgosExternosState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4.6 Otro:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Especifique otro riesgo',
                ),
                initialValue: state.otroRiesgo,
                onChanged: (value) {
                  context.read<RiesgosExternosBloc>().add(
                    SetOtroRiesgo(valor: value),
                  );
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text(''),
                value: state.riesgos['4.6']?.existeRiesgo ?? false,
                onChanged: (value) {
                  context.read<RiesgosExternosBloc>().add(
                    SetRiesgoExterno(
                      riesgoId: '4.6',
                      valor: value ?? false,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (state.riesgos['4.6']?.existeRiesgo ?? false) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('b) Compromete accesos/ocupantes de la edificación'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sí'),
                        value: true,
                        groupValue: state.riesgos['4.6']?.comprometeAccesos,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeAccesos(
                              riesgoId: '4.6',
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: state.riesgos['4.6']?.comprometeAccesos,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeAccesos(
                              riesgoId: '4.6',
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Text('c) Compromete estabilidad de la edificación'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sí'),
                        value: true,
                        groupValue: state.riesgos['4.6']?.comprometeEstabilidad,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeEstabilidad(
                              riesgoId: '4.6',
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: state.riesgos['4.6']?.comprometeEstabilidad,
                        onChanged: (value) {
                          context.read<RiesgosExternosBloc>().add(
                            SetComprometeEstabilidad(
                              riesgoId: '4.6',
                              valor: value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
} 