import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_event.dart';
import '../../../../presentation/blocs/form/nivelDano/nivel_dano_state.dart';

class NivelDanoPage extends StatelessWidget {
  const NivelDanoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivel de Daño en la Edificación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPorcentajeYSeveridad(),
            const SizedBox(height: 24),
            _buildMatrizNivelDano(),
          ],
        ),
      ),
    );
  }

  Widget _buildPorcentajeYSeveridad() {
    final porcentajes = ['Ninguno', '< 10%', '10-40%', '40-70%', '>70%'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '6.1. PORCENTAJE DE AFECTACIÓN DE LA EDIFICACIÓN EN PLANTA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<NivelDanoBloc, NivelDanoState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: porcentajes.map((porcentaje) {
                    return Row(
                      children: [
                        Radio<String>(
                          value: porcentaje,
                          groupValue: state.porcentajeAfectacion,
                          onChanged: (value) {
                            context.read<NivelDanoBloc>().add(
                              SetPorcentajeAfectacion(value!),
                            );
                          },
                        ),
                        Text(porcentaje),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '6.2. SEVERIDAD DE DAÑOS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              children: const [
                TableRow(
                  children: [
                    TableCell(
                      child: ColoredBox(
                        color: Colors.green,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Bajo', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    TableCell(
                      child: ColoredBox(
                        color: Colors.yellow,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Medio', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    TableCell(
                      child: ColoredBox(
                        color: Colors.orange,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Medio Alto', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    TableCell(
                      child: ColoredBox(
                        color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Alto', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrizNivelDano() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '6.3. NIVEL DE DAÑO EN LA EDIFICACIÓN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Encabezado de la matriz
                const TableRow(
                  children: [
                    TableCell(child: SizedBox()), // Celda vacía para el eje Y
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Bajo', textAlign: TextAlign.center),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Medio', textAlign: TextAlign.center),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Medio\nAlto', textAlign: TextAlign.center),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Alto', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                // Fila >70%
                _buildMatrixRow(
                  label: '>70',
                  cells: [
                    Colors.green,
                    Colors.yellow,
                    Colors.red[300]!, // Rojo más claro para caso especial
                    Colors.red,
                  ],
                ),
                // Fila 40-70%
                _buildMatrixRow(
                  label: '40-70',
                  cells: [
                    Colors.green,
                    Colors.yellow,
                    Colors.red[300]!, // Rojo más claro para caso especial
                    Colors.red,
                  ],
                ),
                // Fila 10-40%
                _buildMatrixRow(
                  label: '10-40',
                  cells: [
                    Colors.green,
                    Colors.yellow,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
                // Fila <10%
                _buildMatrixRow(
                  label: '<10',
                  cells: [
                    Colors.green,
                    Colors.green,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Leyenda de severidad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.green,
                  margin: const EdgeInsets.only(right: 8),
                ),
                const Text('Bajo'),
                const SizedBox(width: 16),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.yellow,
                  margin: const EdgeInsets.only(right: 8),
                ),
                const Text('Medio'),
                const SizedBox(width: 16),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.orange,
                  margin: const EdgeInsets.only(right: 8),
                ),
                const Text('Medio Alto'),
                const SizedBox(width: 16),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.red,
                  margin: const EdgeInsets.only(right: 8),
                ),
                const Text('Alto'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildMatrixRow({
    required String label,
    required List<Color> cells,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...cells.map((color) => TableCell(
          child: Container(
            height: 40,
            color: color,
          ),
        )).toList(),
      ],
    );
  }
} 