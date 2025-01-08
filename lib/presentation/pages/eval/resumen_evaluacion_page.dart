// ignore_for_file: unused_import, unused_element

import 'package:ede_final_app/presentation/blocs/form/acciones/acciones_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/acciones/acciones_state.dart';
import '../../blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../../blocs/form/identificacionEdificacion/id_edificacion_state.dart';
import '../../blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import '../../blocs/form/identificacionEvaluacion/id_evaluacion_state.dart';
import 'package:ede_final_app/presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/evaluacionDanos/evaluacion_danos_state.dart';
import 'package:ede_final_app/presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/habitabilidad/habitabilidad_state.dart';
import 'package:ede_final_app/presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/nivelDano/nivel_dano_state.dart';
import 'package:ede_final_app/presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/riesgosExternos/riesgos_externos_state.dart';
import 'package:ede_final_app/presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import 'package:ede_final_app/presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';



class ResumenEvaluacionPage extends StatelessWidget {
  const ResumenEvaluacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de la Evaluación'),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.download),
            label: 'Descargar PDF',
            onTap: () => _handleDownloadPDF(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.send),
            label: 'Enviar PDF',
            onTap: () => _handleSendPDF(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.file_download),
            label: 'Descargar CSV',
            onTap: () => _handleDownloadCSV(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.share),
            label: 'Enviar CSV',
            onTap: () => _handleSendCSV(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSeccionIdentificacionEvaluacion(),
            _buildSeccionIdentificacionEdificacion(),
            _buildSeccionDescripcionEdificacion(),
            _buildSeccionRiesgosExternos(),
            _buildSeccionEvaluacionDanos(),
            _buildSeccionNivelDano(),
            _buildSeccionHabitabilidad(),
            _buildSeccionAcciones(),
          ],
        ),
      ),
    );
  }

  // Métodos para manejar las acciones de los botones flotantes
  void _handleDownloadPDF(BuildContext context) {
    // TODO: Implementar descarga de PDF
  }

  void _handleSendPDF(BuildContext context) {
    // TODO: Implementar envío de PDF
  }

  void _handleDownloadCSV(BuildContext context) {
    // TODO: Implementar descarga de CSV
  }

  void _handleSendCSV(BuildContext context) {
    // TODO: Implementar envío de CSV
  }

  Widget _buildSeccionIdentificacionEvaluacion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EvaluacionBloc, EvaluacionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. IDENTIFICACIÓN DE LA EVALUACIÓN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Fecha', state.fechaInspeccion?.toString() ?? 'No especificada'),
                _buildInfoRow('Hora', state.horaInspeccion?.format(context) ?? 'No especificada'),
                _buildInfoRow('ID Grupo', state.idGrupo ?? 'No especificado'),
                _buildInfoRow('ID Evento', state.idEvento ?? 'No especificado'),
                _buildInfoRow('Evento', state.eventoSeleccionado?.name ?? 'No especificado'),
                if (state.descripcionOtro != null)
                  _buildInfoRow('Descripción otro evento', state.descripcionOtro!),
                _buildInfoRow('Dependencia/Entidad', state.dependenciaEntidad ?? 'No especificada'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionIdentificacionEdificacion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EdificacionBloc, EdificacionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. IDENTIFICACIÓN DE LA EDIFICACIÓN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Nombre', state.nombreEdificacion ?? 'No especificado'),
                _buildInfoRow('Dirección', state.direccion ?? 'No especificada'),
                _buildInfoRow('Comuna', state.comuna ?? 'No especificada'),
                _buildInfoRow('Barrio', state.barrio ?? 'No especificado'),
                _buildInfoRow('CBML', state.cbml ?? 'No especificado'),
                _buildInfoRow('Nombre de contacto', state.nombreContacto ?? 'No especificado'),
                _buildInfoRow('Teléfono', state.telefonoContacto ?? 'No especificado'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionDescripcionEdificacion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DescripcionEdificacionBloc, DescripcionEdificacionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '3. DESCRIPCIÓN DE LA EDIFICACIÓN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Número de pisos', state.numeroPisos?.toString() ?? 'No especificado'),
                _buildInfoRow('Número de sótanos', state.numeroSotanos?.toString() ?? 'No especificado'),
                _buildInfoRow('Área total construida', state.areaConstruida?.toString() ?? 'No especificada'),
                _buildInfoRow('Año de construcción', state.anoConstruccion?.toString() ?? 'No especificado'),
                _buildInfoRow('Uso principal', state.usoPrincipal ?? 'No especificado'),
                _buildInfoRow('Sistema estructural', state.sistemaEstructural ?? 'No especificado'),
                // ... otros campos de descripción
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionRiesgosExternos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RiesgosExternosBloc, RiesgosExternosState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4. RIESGOS EXTERNOS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...state.riesgos.entries.map((riesgo) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRiesgoText(riesgo.key),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    _buildInfoRow('Existe riesgo', riesgo.value.existeRiesgo ? 'Sí' : 'No'),
                    if (riesgo.value.existeRiesgo) ...[
                      _buildInfoRow('Compromete estabilidad', riesgo.value.comprometeEstabilidad ? 'Sí' : 'No'),
                      _buildInfoRow('Compromete accesos/ocupantes', riesgo.value.comprometeFuncionalidad ? 'Sí' : 'No'),
                    ],
                    const SizedBox(height: 8),
                  ],
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionEvaluacionDanos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EvaluacionDanosBloc, EvaluacionDanosState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '5. EVALUACIÓN DE DAÑOS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('5.1 Condiciones existentes:'),
                ...state.condicionesExistentes.entries.map(
                  (e) => _buildInfoRow(_getCondicionText(e.key), e.value == true ? 'Sí' : 'No'),
                ),
                const SizedBox(height: 16),
                const Text('5.2 Nivel de daño en elementos:'),
                ...state.nivelesElementos.entries.map(
                  (e) => _buildInfoRow(_getElementoText(e.key), e.value ?? 'No evaluado'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionNivelDano() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NivelDanoBloc, NivelDanoState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '6. NIVEL DE DAÑO EN LA EDIFICACIÓN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Porcentaje de afectación', state.porcentajeAfectacion ?? 'No especificado'),
                _buildInfoRow('Severidad de daños', state.severidadDanos ?? 'No especificada'),
                _buildInfoRow('Nivel de daño', state.nivelDano ?? 'No especificado'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionHabitabilidad() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<HabitabilidadBloc, HabitabilidadState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '7. HABITABILIDAD DE LA EDIFICACIÓN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Criterio de habitabilidad', state.criterioHabitabilidad ?? 'No especificado'),
                _buildInfoRow('Clasificación', state.clasificacion ?? 'No especificada'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeccionAcciones() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AccionesBloc, AccionesState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '8. ACCIONES RECOMENDADAS Y MEDIDAS DE SEGURIDAD',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('8.1 Evaluación adicional:'),
                ...state.evaluacionAdicional.entries
                    .where((e) => e.value.isNotEmpty)
                    .map((e) => _buildInfoRow(e.key, e.value)),
                const SizedBox(height: 16),
                const Text('8.2 Recomendaciones y medidas:'),
                ...state.recomendaciones.entries
                    .where((e) => e.value)
                    .map((e) => _buildInfoRow(_getRecomendacionText(e.key), 'Sí')),
                if (state.entidadesRecomendadas.values.any((v) => v)) ...[
                  const SizedBox(height: 8),
                  const Text('Entidades recomendadas:'),
                  ...state.entidadesRecomendadas.entries
                      .where((e) => e.value)
                      .map((e) => _buildInfoRow(e.key, 'Recomendada')),
                  if (state.otraEntidad != null)
                    _buildInfoRow('Otra entidad', state.otraEntidad!),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getRiesgoText(String key) {
    final riesgos = {
      '4.1': 'Caída de objetos de edificios adyacentes',
      '4.2': 'Colapso o probable colapso de edificios adyacentes',
      '4.3': 'Falla en sistemas de distribución de servicios públicos (energía, gas, etc)',
      '4.4': 'Inestabilidad del terreno, movimientos en masa en el área',
      '4.5': 'Accesos y salidas',
      '4.6': 'Otro',
    };
    return riesgos[key] ?? key;
  }

    String _getCondicionText(String key) {
    final condiciones = {
      '5.1': 'Colapso total',
      '5.2': 'Colapso parcial',
      '5.3': 'Asentamiento severo en elementos estructurales',
      '5.4': 'Inclinación o desviación importante de la edificación o de un piso',
      '5.5': 'Problemas de inestabilidad en el suelo de cimentación (Movimiento en masa, licuefacción, subsidencia, cambios volumétricos, asentamientos)',
      '5.6': 'Riesgo de caídas de elementos de la edificación (antepechos, fachadas, ventanas, etc.)',
    };
    return condiciones[key] ?? key;
  }

  String _getElementoText(String key) {
    final elementos = {
      '5.7': 'Columnas, pilares o muros estructurales',
      '5.8': 'Vigas',
      '5.9': 'Entrepiso',
      '5.10': 'Cubierta',
      '5.11': 'Escaleras',
    };
    return elementos[key] ?? key;
  }

  String _getRecomendacionText(String key) {
    final recomendaciones = {
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
    return recomendaciones[key] ?? key;
  }

  Widget _buildEvaluacionField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value.isEmpty ? 'No especificado' : value),
      ],
    );
  }
} 