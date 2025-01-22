// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';
import '../../../presentation/blocs/evaluacion_global/evaluacion_global_bloc.dart';
import '../../../presentation/blocs/evaluacion_global/evaluacion_global_state.dart';
import '../../../presentation/widgets/navigation_fab_menu.dart';
import 'package:flutter/rendering.dart';

class ResumenEvaluacionPage extends StatelessWidget {
  const ResumenEvaluacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Resumen de Evaluación'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.file_download),
            onSelected: (value) async {
              final state = context.read<EvaluacionGlobalBloc>().state;
              switch (value) {
                case 'pdf':
                  await _generatePDF(context, state);
                  break;
                case 'csv':
                  await _generateCSV(context, state);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Exportar a PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Exportar a CSV'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<EvaluacionGlobalBloc, EvaluacionGlobalState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildIdentificacionCard(context, theme, state),
                const SizedBox(height: 16),
                _buildIdentificacionEdificacionCard(theme, state),
                const SizedBox(height: 16),
                _buildDescripcionEdificacionCard(theme, state),
                const SizedBox(height: 16),
                _buildRiesgosExternosCard(context, theme, state),
                const SizedBox(height: 16),
                _buildEvaluacionDanosCard(context, theme, state),
                const SizedBox(height: 16),
                _buildNivelDanoCard(theme, state),
                const SizedBox(height: 16),
                _buildHabitabilidadCard(theme, state),
                const SizedBox(height: 16),
                _buildAccionesCard(context, theme, state),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const NavigationFabMenu(currentRoute: '/resumen_evaluacion'),
    );
  }

  Future<void> _generatePDF(BuildContext context, EvaluacionGlobalState state) async {
    try {
      final pdf = pw.Document();
      final timeFormat = state.horaInspeccion?.format(context) ?? 'No especificada';
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Header(
              level: 0,
              child: pw.Text('Resumen de Evaluación',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            _buildPDFSection(
              '1. Identificación de la Evaluación',
              {
                'Fecha': state.fechaInspeccion?.toString() ?? 'No especificada',
                'Hora': timeFormat,
                'Evaluador': state.nombreEvaluador ?? 'No especificado',
                'ID Grupo': state.idGrupo ?? 'No especificado',
                'ID Evento': state.idEvento ?? 'No especificado',
                'Evento': state.eventoSeleccionado ?? 'No especificado',
                'Descripción': state.descripcionOtro ?? 'No especificada',
                'Dependencia': state.dependenciaEntidad ?? 'No especificada',
              },
            ),
            _buildPDFSection(
              '2. Identificación de la Edificación',
              {
                'Nombre': state.nombreEdificacion ?? 'No especificado',
                'Dirección': state.direccion ?? 'No especificada',
                'Comuna': state.comuna ?? 'No especificada',
                'Barrio': state.barrio ?? 'No especificado',
                'Código de Barrio': state.codigoBarrio ?? 'No especificado',
                'CBML': state.cbml ?? 'No especificado',
                'Contacto': state.nombreContacto ?? 'No especificado',
                'Teléfono': state.telefonoContacto ?? 'No especificado',
                'Email': state.emailContacto ?? 'No especificado',
                'Ocupación': state.ocupacion ?? 'No especificado',
              },
            ),
            _buildPDFSection(
              '3. Descripción de la Edificación',
              {
                'Uso': state.uso ?? 'No especificado',
                'Niveles': state.niveles?.toString() ?? 'No especificado',
                'Ocupantes': state.ocupantes?.toString() ?? 'No especificado',
                'Sistema Constructivo': state.sistemaConstructivo ?? 'No especificado',
                'Tipo de Entrepiso': state.tipoEntrepiso ?? 'No especificado',
                'Tipo de Cubierta': state.tipoCubierta ?? 'No especificado',
                'Elementos No Estructurales': state.elementosNoEstructurales ?? 'No especificados',
                'Características Adicionales': state.caracteristicasAdicionales ?? 'No especificadas',
              },
            ),
            _buildPDFSection(
              '4. Riesgos Externos',
              {
                'Colapso de Estructuras': state.colapsoEstructuras == true ? 'Sí' : 'No',
                'Caída de Objetos': state.caidaObjetos == true ? 'Sí' : 'No',
                'Otros Riesgos': state.otrosRiesgos == true ? 'Sí' : 'No',
                'Riesgo de Colapso': (state.riesgoColapso ?? false) ? 'Sí' : 'No',
                'Riesgo de Caída': (state.riesgoCaida ?? false) ? 'Sí' : 'No',
                'Riesgo en Servicios': (state.riesgoServicios ?? false) ? 'Sí' : 'No',
                'Riesgo en Terreno': (state.riesgoTerreno ?? false) ? 'Sí' : 'No',
                'Riesgo en Accesos': (state.riesgoAccesos ?? false) ? 'Sí' : 'No',
              },
            ),
            _buildPDFSection(
              '5. Evaluación de Daños',
              {
                'Daños Estructurales': _mapToString(state.danosEstructurales),
                'Daños No Estructurales': _mapToString(state.danosNoEstructurales),
                'Daños Geotécnicos': _mapToString(state.danosGeotecnicos),
                'Condiciones Preexistentes': _mapToString(state.condicionesPreexistentes),
                'Alcance de la Evaluación': state.alcanceEvaluacion ?? 'No especificado',
              },
            ),
            _buildPDFSection(
              '6. Nivel de Daño',
              {
                'Nivel de Daño Estructural': state.nivelDanoEstructural ?? 'No especificado',
                'Nivel de Daño No Estructural': state.nivelDanoNoEstructural ?? 'No especificado',
                'Nivel de Daño Geotécnico': state.nivelDanoGeotecnico ?? 'No especificado',
                'Severidad Global': state.severidadGlobal ?? 'No especificada',
              },
            ),
            _buildPDFSection(
              '7. Habitabilidad',
              {
                'Estado': state.estadoHabitabilidad ?? 'No especificado',
                'Clasificación': state.clasificacionHabitabilidad ?? 'No especificada',
                'Observaciones': state.observacionesHabitabilidad ?? 'No especificadas',
                'Criterio': state.criterioHabitabilidad ?? 'No especificado',
              },
            ),
            _buildPDFSection(
              '8. Acciones Recomendadas',
              {
                'Evaluaciones Adicionales': _mapToString(state.evaluacionesAdicionales),
                'Medidas de Seguridad': _mapToString(state.medidasSeguridad),
                'Entidades Recomendadas': _mapBoolToString(state.entidadesRecomendadas),
                'Observaciones': _getObservaciones(state),
              },
            ),
          ],
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/evaluacion_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF guardado en: ${file.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Compartir',
              textColor: Colors.white,
              onPressed: () async {
                await Share.shareXFiles([XFile(file.path)], text: 'Resumen de Evaluación');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generateCSV(BuildContext context, EvaluacionGlobalState state) async {
    try {
      final timeFormat = state.horaInspeccion?.format(context) ?? 'No especificada';
      
      List<List<String>> rows = [
        ['Sección', 'Campo', 'Valor'],
        // Identificación de la Evaluación
        ['Identificación', 'Fecha', state.fechaInspeccion?.toString() ?? 'No especificada'],
        ['Identificación', 'Hora', timeFormat],
        ['Identificación', 'Evaluador', state.nombreEvaluador ?? 'No especificado'],
        ['Identificación', 'ID Grupo', state.idGrupo ?? 'No especificado'],
        ['Identificación', 'ID Evento', state.idEvento ?? 'No especificado'],
        ['Identificación', 'Evento', state.eventoSeleccionado ?? 'No especificado'],
        ['Identificación', 'Descripción', state.descripcionOtro ?? 'No especificada'],
        ['Identificación', 'Dependencia', state.dependenciaEntidad ?? 'No especificada'],
        // Identificación de la Edificación
        ['Edificación', 'Nombre', state.nombreEdificacion ?? 'No especificado'],
        ['Edificación', 'Dirección', state.direccion ?? 'No especificada'],
        ['Edificación', 'Comuna', state.comuna ?? 'No especificada'],
        ['Edificación', 'Barrio', state.barrio ?? 'No especificado'],
        ['Edificación', 'Código de Barrio', state.codigoBarrio ?? 'No especificado'],
        ['Edificación', 'CBML', state.cbml ?? 'No especificado'],
        ['Edificación', 'Contacto', state.nombreContacto ?? 'No especificado'],
        ['Edificación', 'Teléfono', state.telefonoContacto ?? 'No especificado'],
        ['Edificación', 'Email', state.emailContacto ?? 'No especificado'],
        ['Edificación', 'Ocupación', state.ocupacion ?? 'No especificado'],
        if (state.latitud != null && state.longitud != null)
          ['Edificación', 'Ubicación', '${state.latitud}, ${state.longitud}'],
        ['Edificación', 'Tipo de Vía', state.tipoVia ?? 'No especificado'],
        ['Edificación', 'Número de Vía', state.numeroVia ?? 'No especificado'],
        ['Edificación', 'Apéndice de Vía', state.apendiceVia ?? 'No especificado'],
        ['Edificación', 'Orientación de Vía', state.orientacionVia ?? 'No especificado'],
        ['Edificación', 'Número de Cruce', state.numeroCruce ?? 'No especificado'],
        ['Edificación', 'Apéndice de Cruce', state.apendiceCruce ?? 'No especificado'],
        ['Edificación', 'Orientación de Cruce', state.orientacionCruce ?? 'No especificado'],
        ['Edificación', 'Número', state.numero ?? 'No especificado'],
        ['Edificación', 'Complemento', state.complemento ?? 'No especificado'],
        ['Edificación', 'Departamento', state.departamento ?? 'No especificado'],
        ['Edificación', 'Municipio', state.municipio ?? 'No especificado'],
        // Descripción de la Edificación
        ['Descripción', 'Uso', state.uso ?? 'No especificado'],
        ['Descripción', 'Niveles', state.niveles?.toString() ?? 'No especificado'],
        ['Descripción', 'Ocupantes', state.ocupantes?.toString() ?? 'No especificado'],
        ['Descripción', 'Sistema Constructivo', state.sistemaConstructivo ?? 'No especificado'],
        ['Descripción', 'Tipo de Entrepiso', state.tipoEntrepiso ?? 'No especificado'],
        ['Descripción', 'Tipo de Cubierta', state.tipoCubierta ?? 'No especificado'],
        ['Descripción', 'Elementos No Estructurales', state.elementosNoEstructurales ?? 'No especificados'],
        ['Descripción', 'Características Adicionales', state.caracteristicasAdicionales ?? 'No especificadas'],
        // Riesgos Externos
        ['Riesgos', 'Colapso de Estructuras', state.colapsoEstructuras == true ? 'Sí' : 'No'],
        ['Riesgos', 'Caída de Objetos', state.caidaObjetos == true ? 'Sí' : 'No'],
        ['Riesgos', 'Otros Riesgos', state.otrosRiesgos == true ? 'Sí' : 'No'],
        ['Riesgos', 'Riesgo de Colapso', (state.riesgoColapso ?? false) ? 'Sí' : 'No'],
        ['Riesgos', 'Riesgo de Caída', (state.riesgoCaida ?? false) ? 'Sí' : 'No'],
        ['Riesgos', 'Riesgo en Servicios', (state.riesgoServicios ?? false) ? 'Sí' : 'No'],
        ['Riesgos', 'Riesgo en Terreno', (state.riesgoTerreno ?? false) ? 'Sí' : 'No'],
        ['Riesgos', 'Riesgo en Accesos', (state.riesgoAccesos ?? false) ? 'Sí' : 'No'],
        // Evaluación de Daños
        ['Daños', 'Daños Estructurales', _mapToString(state.danosEstructurales)],
        ['Daños', 'Daños No Estructurales', _mapToString(state.danosNoEstructurales)],
        ['Daños', 'Daños Geotécnicos', _mapToString(state.danosGeotecnicos)],
        ['Daños', 'Condiciones Preexistentes', _mapToString(state.condicionesPreexistentes)],
        ['Daños', 'Alcance de la Evaluación', state.alcanceEvaluacion ?? 'No especificado'],
        // Nivel de Daño
        ['Nivel de Daño', 'Estructural', state.nivelDanoEstructural ?? 'No especificado'],
        ['Nivel de Daño', 'No Estructural', state.nivelDanoNoEstructural ?? 'No especificado'],
        ['Nivel de Daño', 'Geotécnico', state.nivelDanoGeotecnico ?? 'No especificado'],
        ['Nivel de Daño', 'Severidad Global', state.severidadGlobal ?? 'No especificada'],
        // Habitabilidad
        ['Habitabilidad', 'Estado', state.estadoHabitabilidad ?? 'No especificado'],
        ['Habitabilidad', 'Clasificación', state.clasificacionHabitabilidad ?? 'No especificada'],
        ['Habitabilidad', 'Observaciones', state.observacionesHabitabilidad ?? 'No especificadas'],
        ['Habitabilidad', 'Criterio', state.criterioHabitabilidad ?? 'No especificado'],
        // Acciones Recomendadas
        ['Acciones', 'Evaluaciones Adicionales', _mapToString(state.evaluacionesAdicionales)],
        ['Acciones', 'Medidas de Seguridad', _mapToString(state.medidasSeguridad)],
        ['Acciones', 'Entidades Recomendadas', _mapBoolToString(state.entidadesRecomendadas)],
        ['Acciones', 'Observaciones', _getObservaciones(state)],
      ];

      String csv = const ListToCsvConverter().convert(rows);
      
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/evaluacion_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV guardado en: ${file.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Compartir',
              textColor: Colors.white,
              onPressed: () async {
                await Share.shareXFiles([XFile(file.path)], text: 'Resumen de Evaluación');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar CSV: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  pw.Widget _buildPDFSection(String title, Map<String, dynamic>? data) {
    final safeData = data ?? {};
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        ...safeData.keys.map((key) => pw.Text(
          '$key: ${safeData[key]?.toString() ?? 'No especificado'}',
          style: const pw.TextStyle(fontSize: 12),
        )),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildPDFBoolSection(String title, Map<String, bool>? data) {
    final safeData = data ?? {};
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        ...safeData.keys.map((key) => pw.Text(
          '$key: ${(safeData[key] ?? false) ? 'Sí' : 'No'}',
          style: const pw.TextStyle(fontSize: 12),
        )),
        pw.SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: value == 'No especificado' || 
                       value == 'No especificada' || 
                       value == 'No especificadas' 
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(ThemeData theme, String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentificacionCard(BuildContext context, ThemeData theme, EvaluacionGlobalState state) {
    return _buildSectionCard(
      theme,
      '1. Identificación de la Evaluación',
      Icons.assignment,
      [
        _buildInfoRow('Fecha', state.fechaInspeccion?.toString() ?? 'No especificada', theme, icon: Icons.calendar_today),
        _buildInfoRow('Hora', state.horaInspeccion?.format(context) ?? 'No especificada', theme, icon: Icons.access_time),
        _buildInfoRow('Evaluador', state.nombreEvaluador ?? 'No especificado', theme, icon: Icons.person),
        _buildInfoRow('ID Grupo', state.idGrupo ?? 'No especificado', theme, icon: Icons.group),
        _buildInfoRow('ID Evento', state.idEvento ?? 'No especificado', theme, icon: Icons.event),
        _buildInfoRow('Evento', state.eventoSeleccionado ?? 'No especificado', theme, icon: Icons.category),
        _buildInfoRow('Descripción', state.descripcionOtro ?? 'No especificada', theme, icon: Icons.description),
        _buildInfoRow('Dependencia', state.dependenciaEntidad ?? 'No especificada', theme, icon: Icons.business),
      ],
    );
  }

  Widget _buildIdentificacionEdificacionCard(ThemeData theme, EvaluacionGlobalState state) {
    return _buildSectionCard(
      theme,
      '2. Identificación de la Edificación',
      Icons.location_city,
      [
        _buildInfoRow('Nombre', state.nombreEdificacion ?? 'No especificado', theme, icon: Icons.business),
        _buildInfoRow('Dirección', state.direccion ?? 'No especificada', theme, icon: Icons.location_on),
        _buildInfoRow('Comuna', state.comuna ?? 'No especificada', theme, icon: Icons.location_city),
        _buildInfoRow('Barrio', state.barrio ?? 'No especificado', theme, icon: Icons.home),
        _buildInfoRow('Código de Barrio', state.codigoBarrio ?? 'No especificado', theme, icon: Icons.qr_code),
        _buildInfoRow('CBML', state.cbml ?? 'No especificado', theme, icon: Icons.qr_code),
        _buildInfoRow('Contacto', state.nombreContacto ?? 'No especificado', theme, icon: Icons.person),
        _buildInfoRow('Teléfono', state.telefonoContacto ?? 'No especificado', theme, icon: Icons.phone),
        _buildInfoRow('Email', state.emailContacto ?? 'No especificado', theme, icon: Icons.email),
        _buildInfoRow('Ocupación', state.ocupacion ?? 'No especificado', theme, icon: Icons.work),
        if (state.latitud != null && state.longitud != null)
          _buildInfoRow('Ubicación', '${state.latitud}, ${state.longitud}', theme, icon: Icons.pin_drop),
        _buildInfoRow('Tipo de Vía', state.tipoVia ?? 'No especificado', theme, icon: Icons.add_road),
        _buildInfoRow('Número de Vía', state.numeroVia ?? 'No especificado', theme, icon: Icons.signpost),
        _buildInfoRow('Apéndice de Vía', state.apendiceVia ?? 'No especificado', theme, icon: Icons.more),
        _buildInfoRow('Orientación de Vía', state.orientacionVia ?? 'No especificado', theme, icon: Icons.compass_calibration),
        _buildInfoRow('Número de Cruce', state.numeroCruce ?? 'No especificado', theme, icon: Icons.call_split),
        _buildInfoRow('Apéndice de Cruce', state.apendiceCruce ?? 'No especificado', theme, icon: Icons.more),
        _buildInfoRow('Orientación de Cruce', state.orientacionCruce ?? 'No especificado', theme, icon: Icons.compass_calibration),
        _buildInfoRow('Número', state.numero ?? 'No especificado', theme, icon: Icons.tag),
        _buildInfoRow('Complemento', state.complemento ?? 'No especificado', theme, icon: Icons.add),
        _buildInfoRow('Departamento', state.departamento ?? 'No especificado', theme, icon: Icons.location_city),
        _buildInfoRow('Municipio', state.municipio ?? 'No especificado', theme, icon: Icons.location_city),
      ],
    );
  }

  Widget _buildDescripcionEdificacionCard(ThemeData theme, EvaluacionGlobalState state) {
    return _buildSectionCard(
      theme,
      '3. Descripción de la Edificación',
      Icons.apartment,
      [
        _buildInfoRow('Uso', state.uso ?? 'No especificado', theme, icon: Icons.category),
        _buildInfoRow('Niveles', state.niveles?.toString() ?? 'No especificado', theme, icon: Icons.layers),
        _buildInfoRow('Ocupantes', state.ocupantes?.toString() ?? 'No especificado', theme, icon: Icons.people),
        _buildInfoRow('Sistema Constructivo', state.sistemaConstructivo ?? 'No especificado', theme, icon: Icons.construction),
        _buildInfoRow('Tipo de Entrepiso', state.tipoEntrepiso ?? 'No especificado', theme, icon: Icons.view_agenda),
        _buildInfoRow('Tipo de Cubierta', state.tipoCubierta ?? 'No especificado', theme, icon: Icons.roofing),
        _buildInfoRow('Elementos No Estructurales', state.elementosNoEstructurales ?? 'No especificados', theme, icon: Icons.view_module),
        _buildInfoRow('Características Adicionales', state.caracteristicasAdicionales ?? 'No especificadas', theme, icon: Icons.add_box),
      ],
    );
  }

  Widget _buildRiesgosExternosCard(BuildContext context, ThemeData theme, EvaluacionGlobalState state) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riesgos Externos',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(
              'Colapso de Estructuras',
              state.colapsoEstructuras == true ? 'Sí' : 'No',
              theme,
            ),
            _buildInfoRow(
              'Caída de Objetos',
              state.caidaObjetos == true ? 'Sí' : 'No',
              theme,
            ),
            _buildInfoRow(
              'Otros Riesgos',
              state.otrosRiesgos == true ? 'Sí' : 'No',
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluacionDanosCard(BuildContext context, ThemeData theme, EvaluacionGlobalState state) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evaluación de Daños',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(
              'Daños Estructurales',
              _mapToString(state.danosEstructurales),
              theme,
            ),
            _buildInfoRow(
              'Daños No Estructurales',
              _mapToString(state.danosNoEstructurales),
              theme,
            ),
            _buildInfoRow(
              'Daños Geotécnicos',
              _mapToString(state.danosGeotecnicos),
              theme,
            ),
            _buildInfoRow(
              'Condiciones Preexistentes',
              _mapToString(state.condicionesPreexistentes),
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNivelDanoCard(ThemeData theme, EvaluacionGlobalState state) {
    return _buildSectionCard(
      theme,
      '6. Nivel de Daño',
      Icons.assessment,
      [
        _buildInfoRow('Nivel de Daño Estructural', state.nivelDanoEstructural ?? 'No especificado', theme, icon: Icons.warning),
        _buildInfoRow('Nivel de Daño No Estructural', state.nivelDanoNoEstructural ?? 'No especificado', theme, icon: Icons.warning),
        _buildInfoRow('Nivel de Daño Geotécnico', state.nivelDanoGeotecnico ?? 'No especificado', theme, icon: Icons.warning),
        _buildInfoRow('Severidad Global', state.severidadGlobal ?? 'No especificada', theme, icon: Icons.warning),
      ],
    );
  }

  Widget _buildHabitabilidadCard(ThemeData theme, EvaluacionGlobalState state) {
    return _buildSectionCard(
      theme,
      '7. Habitabilidad',
      Icons.home,
      [
        _buildHabitabilidadIndicator(state, theme),
        const SizedBox(height: 16),
        _buildInfoRow('Estado', state.estadoHabitabilidad ?? 'No especificado', theme, icon: Icons.home),
        _buildInfoRow('Clasificación', state.clasificacionHabitabilidad ?? 'No especificada', theme, icon: Icons.class_),
        _buildInfoRow('Observaciones', state.observacionesHabitabilidad ?? 'No especificadas', theme, icon: Icons.note),
        _buildInfoRow('Criterio', state.criterioHabitabilidad ?? 'No especificado', theme, icon: Icons.rule),
      ],
    );
  }

  Widget _buildHabitabilidadIndicator(EvaluacionGlobalState state, ThemeData theme) {
    Color getColorForEstado(String? estado) {
      switch (estado?.toLowerCase()) {
        case 'habitable':
          return Colors.green;
        case 'uso restringido':
          return Colors.orange;
        case 'no habitable':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    IconData getIconForEstado(String? estado) {
      switch (estado?.toLowerCase()) {
        case 'habitable':
          return Icons.check_circle;
        case 'uso restringido':
          return Icons.warning;
        case 'no habitable':
          return Icons.dangerous;
        default:
          return Icons.help;
      }
    }

    final color = getColorForEstado(state.estadoHabitabilidad);
    final icon = getIconForEstado(state.estadoHabitabilidad);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.estadoHabitabilidad?.toUpperCase() ?? 'NO ESPECIFICADO',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccionesCard(BuildContext context, ThemeData theme, EvaluacionGlobalState state) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones Recomendadas',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(
              'Evaluaciones Adicionales',
              _mapToString(state.evaluacionesAdicionales),
              theme,
            ),
            _buildInfoRow(
              'Medidas de Seguridad',
              _mapToString(state.medidasSeguridad),
              theme,
            ),
            _buildInfoRow(
              'Entidades Recomendadas',
              _mapBoolToString(state.entidadesRecomendadas),
              theme,
            ),
            if ((state.observacionesAcciones ?? '').isNotEmpty)
              _buildInfoRow(
                'Observaciones',
                _getObservaciones(state),
                theme,
              ),
          ],
        ),
      ),
    );
  }

  String _mapToString(Map<String, dynamic>? map) {
    final safeMap = map ?? {};
    if (safeMap.isEmpty) return 'No especificado';
    final buffer = StringBuffer();
    safeMap.forEach((key, value) {
      buffer.writeln('$key: ${value?.toString() ?? 'No especificado'}');
    });
    return buffer.toString().trim();
  }

  String _mapBoolToString(Map<String, bool>? map) {
    final safeMap = map ?? {};
    if (safeMap.isEmpty) return 'No especificado';
    final buffer = StringBuffer();
    safeMap.forEach((key, value) {
      buffer.writeln('$key: ${value ? 'Sí' : 'No'}');
    });
    return buffer.toString().trim();
  }

  String _getObservaciones(EvaluacionGlobalState state) {
    final observaciones = state.observacionesAcciones;
    if (observaciones == null || observaciones.isEmpty) {
      return 'No especificado';
    }
    return observaciones;
  }
} 