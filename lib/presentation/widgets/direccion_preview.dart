import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../blocs/form/identificacionEdificacion/id_edificacion_state.dart';

class DireccionPreview extends StatelessWidget {
  const DireccionPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EdificacionBloc, EdificacionState>(
      builder: (context, state) {
        final direccion = _construirDireccion(
          tipoVia: state.tipoVia,
          numeroVia: state.numeroVia,
          apendiceVia: state.apendiceVia,
          orientacionVia: state.orientacionVia,
          numeroCruce: state.numeroCruce,
          apendiceCruce: state.apendiceCruce,
          orientacionCruce: state.orientacionCruce,
          numero: state.numero,
          complemento: state.complemento,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dirección:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  direccion.isEmpty ? 'Sin datos' : direccion,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _construirDireccion({
    String? tipoVia,
    String? numeroVia,
    String? apendiceVia,
    String? orientacionVia,
    String? numeroCruce,
    String? apendiceCruce,
    String? orientacionCruce,
    String? numero,
    String? complemento,
  }) {
    final List<String> partes = [];

    // Vía principal
    if (tipoVia != null) {
      partes.add(tipoVia);
      if (numeroVia != null) partes.add(numeroVia);
      if (apendiceVia != null && apendiceVia.isNotEmpty) partes.add(apendiceVia);
      if (orientacionVia != null && orientacionVia.isNotEmpty) {
        if ((tipoVia == 'CL' && orientacionVia == 'SUR') ||
            (tipoVia == 'CR' && orientacionVia == 'ESTE')) {
          partes.add(orientacionVia);
        }
      }
    }

    // Cruce
    if (numeroCruce != null) {
      partes.add('#');
      partes.add(numeroCruce);
      if (apendiceCruce != null && apendiceCruce.isNotEmpty) partes.add(apendiceCruce);
      if (orientacionCruce != null && orientacionCruce.isNotEmpty) {
        if ((tipoVia == 'CL' && orientacionCruce == 'SUR') ||
            (tipoVia == 'CR' && orientacionCruce == 'ESTE')) {
          partes.add(orientacionCruce);
        }
      }
    }

    // Número y complemento
    if (numero != null) {
      partes.add('-');
      partes.add(numero);
      if (complemento != null && complemento.isNotEmpty) {
        partes.add('(${complemento})');
      }
    }

    return partes.join(' ');
  }
} 