// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../bloc/evaluacion_global_bloc.dart';
import '../bloc/evaluacion_global_state.dart';
import '../widgets/navigation_fab_menu.dart';
import '../bloc/form/riesgosExternos/riesgos_externos_state.dart';

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
                _buildEvaluacionDanosCard(state),
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
                'riesgosExternos': state.riesgosExternos,
                'otroRiesgoExterno': state.otroRiesgoExterno,
              },
            ),
            _buildPDFSection(
              '5. Evaluación de Daños',
              {
                'Condiciones Existentes': _mapToString(state.danosEstructurales?['condicionesExistentes']),
                'Niveles de Elementos': _mapToString(state.danosEstructurales?['nivelesElementos']),
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
        ['Riesgos', 'riesgosExternos', _mapToString(state.riesgosExternos)],
        ['Riesgos', 'otroRiesgoExterno', state.otroRiesgoExterno?.toString() ?? 'No especificado'],
        // Evaluación de Daños
        ['Daños', 'Condiciones Existentes', _mapToString(state.danosEstructurales?['condicionesExistentes'])],
        ['Daños', 'Niveles de Elementos', _mapToString(state.danosEstructurales?['nivelesElementos'])],
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

  pw.Widget _buildPDFSection(String title, Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text(title),
        ),
        pw.SizedBox(height: 10),
        ...data.entries.map((entry) {
          if (title == '4. Riesgos Externos') {
            if (entry.key == 'riesgosExternos') {
              final riesgos = entry.value as Map<String, RiesgoItem>;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: riesgos.entries.map((riesgo) {
                  if (!riesgo.value.existeRiesgo) return pw.Container();
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${riesgo.key}: ${_getRiesgoDescripcion(riesgo.key)}'),
                      if (riesgo.value.comprometeAccesos)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 20),
                          child: pw.Text('- Compromete accesos/ocupantes'),
                        ),
                      if (riesgo.value.comprometeEstabilidad)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 20),
                          child: pw.Text('- Compromete estabilidad'),
                        ),
                      pw.SizedBox(height: 5),
                    ],
                  );
                }).toList(),
              );
            }
            if (entry.key == 'otroRiesgoExterno' && entry.value != null) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Otro riesgo: ${entry.value}'),
                  pw.SizedBox(height: 5),
                ],
              );
            }
            return pw.Container();
          }
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('${entry.key}: ${entry.value}'),
              pw.SizedBox(height: 5),
            ],
          );
        }).toList(),
        pw.SizedBox(height: 20),
      ],
    );
  }

  String _getRiesgoDescripcion(String codigo) {
    final riesgosDescripcion = {
      '4.1': 'Caída de objetos de edificios adyacentes',
      '4.2': 'Colapso o probable colapso de edificios adyacentes',
      '4.3': 'Falla en sistemas de distribución de servicios públicos',
      '4.4': 'Inestabilidad del terreno, movimientos en masa',
      '4.5': 'Accesos y salidas',
      '4.6': 'Otro riesgo',
    };
    return riesgosDescripcion[codigo] ?? 'Riesgo no especificado';
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
        _buildInfoRow('ID Evento', state.idEvento ?? 'No especificado', theme, icon: Icons.tag),
        _buildInfoRow('Evento', state.eventoSeleccionado ?? 'No especificado', theme, icon: Icons.category),
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
        
        // Componentes de la dirección
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Componentes de la dirección:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Tipo de Vía', state.tipoVia ?? 'No especificado', theme, icon: Icons.add_road),
              _buildInfoRow('Número de Vía', state.numeroVia ?? 'No especificado', theme, icon: Icons.signpost),
              _buildInfoRow('Apéndice de Vía', state.apendiceVia ?? 'No especificado', theme, icon: Icons.more),
              _buildInfoRow('Orientación de Vía', state.orientacionVia ?? 'No especificado', theme, icon: Icons.compass_calibration),
              _buildInfoRow('Número de Cruce', state.numeroCruce ?? 'No especificado', theme, icon: Icons.call_split),
              _buildInfoRow('Apéndice de Cruce', state.apendiceCruce ?? 'No especificado', theme, icon: Icons.more),
              _buildInfoRow('Orientación de Cruce', state.orientacionCruce ?? 'No especificado', theme, icon: Icons.compass_calibration),
              _buildInfoRow('Número', state.numero ?? 'No especificado', theme, icon: Icons.tag),
              _buildInfoRow('Complemento', state.complemento ?? 'No especificado', theme, icon: Icons.add),
            ],
          ),
        ),
        
        // Ubicación
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubicación:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Departamento', state.departamento ?? 'No especificado', theme, icon: Icons.location_city),
              _buildInfoRow('Municipio', state.municipio ?? 'No especificado', theme, icon: Icons.location_city),
              _buildInfoRow('Comuna', state.comuna ?? 'No especificada', theme, icon: Icons.location_city),
              _buildInfoRow('Barrio', state.barrio ?? 'No especificado', theme, icon: Icons.home),
              _buildInfoRow('CBML', state.cbml ?? 'No especificado', theme, icon: Icons.qr_code),
              if (state.latitud != null && state.longitud != null)
                _buildInfoRow('Coordenadas', '${state.latitud}, ${state.longitud}', theme, icon: Icons.pin_drop),
            ],
          ),
        ),
        
        // Información de contacto
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información de contacto:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Contacto', state.nombreContacto ?? 'No especificado', theme, icon: Icons.person),
              _buildInfoRow('Teléfono', state.telefonoContacto ?? 'No especificado', theme, icon: Icons.phone),
              _buildInfoRow('Email', state.emailContacto ?? 'No especificado', theme, icon: Icons.email),
              _buildInfoRow('Ocupación', state.ocupacion ?? 'No especificado', theme, icon: Icons.work),
            ],
          ),
        ),
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
        _buildInfoRow('Niveles', '${state.niveles?.toString() ?? "No especificado"} nivel(es)', theme, icon: Icons.layers),
        _buildInfoRow('Ocupantes', '${state.ocupantes?.toString() ?? "No especificado"} persona(s)', theme, icon: Icons.people),
        _buildInfoRow('Sistema Constructivo', state.sistemaConstructivo ?? 'No especificado', theme, icon: Icons.construction),
        _buildInfoRow('Tipo de Entrepiso', state.tipoEntrepiso ?? 'No especificado', theme, icon: Icons.view_agenda),
        _buildInfoRow('Tipo de Cubierta', state.tipoCubierta ?? 'No especificado', theme, icon: Icons.roofing),
        _buildInfoRow('Elementos No Estructurales', state.elementosNoEstructurales ?? 'No especificados', theme, icon: Icons.grid_view),
        _buildInfoRow('Características Adicionales', state.caracteristicasAdicionales ?? 'No especificadas', theme, icon: Icons.info_outline),
      ],
    );
  }

  Widget _buildRiesgosExternosCard(BuildContext context, ThemeData theme, EvaluacionGlobalState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4. Riesgos Externos',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...state.riesgosExternos.entries.map((entry) {
              final riesgo = entry.value;
              if (!riesgo.existeRiesgo) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key} ${_getRiesgoDescripcion(entry.key)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (entry.key == '4.6' && state.otroRiesgoExterno != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('Descripción: ${state.otroRiesgoExterno}'),
                      ),
                    if (riesgo.comprometeAccesos)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: theme.colorScheme.error, size: 16),
                            const SizedBox(width: 8),
                            Text('Compromete accesos/ocupantes',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                    if (riesgo.comprometeEstabilidad)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.dangerous, color: theme.colorScheme.error, size: 16),
                            const SizedBox(width: 8),
                            Text('Compromete estabilidad',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
            if (state.riesgosExternos.values.every((r) => !r.existeRiesgo))
              const Text('No se identificaron riesgos externos'),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluacionDanosCard(EvaluacionGlobalState state) {
    if (state.danosEstructurales == null) return const SizedBox.shrink();

    final condicionesExistentes = state.danosEstructurales?['condicionesExistentes'] as Map<String, bool>? ?? {};
    final nivelesElementos = state.danosEstructurales?['nivelesElementos'] as Map<String, String>? ?? {};

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5. Evaluación de Daños',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Condiciones Existentes (5.1-5.6)
            const Text(
              'Condiciones Existentes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...condicionesExistentes.entries.map((entry) {
              final condicionId = entry.key;
              final existe = entry.value;
              String descripcion = '';
              switch (condicionId) {
                case '5.1': descripcion = 'Colapso total'; break;
                case '5.2': descripcion = 'Colapso parcial'; break;
                case '5.3': descripcion = 'Asentamiento severo en elementos estructurales'; break;
                case '5.4': descripcion = 'Inclinación o desviación importante de la edificación o de un piso'; break;
                case '5.5': descripcion = 'Problemas de inestabilidad en el suelo de cimentación'; break;
                case '5.6': descripcion = 'Riesgo de caídas de elementos de la edificación'; break;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(
                      existe ? Icons.check_circle : Icons.cancel,
                      color: existe ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('$condicionId. $descripcion'),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 16),
            
            // Niveles de Elementos (5.7-5.11)
            const Text(
              'Nivel de Daño en Elementos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...nivelesElementos.entries.map((entry) {
              final elementoId = entry.key;
              final nivel = entry.value;
              String descripcion = '';
              switch (elementoId) {
                case '5.7': descripcion = 'Daño en muros de carga, columnas, y otros elementos estructurales primordiales'; break;
                case '5.8': descripcion = 'Daño en sistemas de contención, muros de contención'; break;
                case '5.9': descripcion = 'Daño en muros divisorios, muros de fachada, antepechos, barandas'; break;
                case '5.10': descripcion = 'Cubierta (recubrimiento y estructura de soporte)'; break;
                case '5.11': descripcion = 'Cielo rasos, luminarias, instalaciones y otros elementos no estructurales diferentes de muros'; break;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getNivelColor(nivel),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('$elementoId. $descripcion - $nivel'),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            if (state.alcanceEvaluacion != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Alcance de la Evaluación:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(state.alcanceEvaluacion!),
            ],
          ],
        ),
      ),
    );
  }

  Color _getNivelColor(String nivel) {
    switch (nivel) {
      case 'Sin daño': return Colors.green;
      case 'Leve': return Colors.yellow;
      case 'Moderado': return Colors.orange;
      case 'Severo': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildNivelDanoCard(ThemeData theme, EvaluacionGlobalState state) {
    Color getSeveridadColor(String? severidad) {
      if (severidad == null) return Colors.grey;
      switch (severidad.toLowerCase()) {
        case 'bajo':
          return const Color(0xFF43A047); // Verde
        case 'medio':
          return const Color(0xFFFDD835); // Amarillo
        case 'medio alto':
          return const Color(0xFFF57C00); // Naranja
        case 'alto':
          return const Color(0xFFD32F2F); // Rojo
        default:
          return Colors.grey;
      }
    }

    IconData getSeveridadIcon(String? severidad) {
      if (severidad == null) return Icons.help;
      switch (severidad.toLowerCase()) {
        case 'bajo':
          return Icons.check_circle;
        case 'medio':
          return Icons.warning;
        case 'medio alto':
          return Icons.warning_amber;
        case 'alto':
          return Icons.error;
        default:
          return Icons.help;
      }
    }

    String getSeveridadDescription(String? severidad) {
      if (severidad == null) return 'Complete la evaluación de daños para calcular la severidad';
      switch (severidad.toLowerCase()) {
        case 'bajo':
          return 'Si en 5.1, 5.2, 5.3, 5.4, 5.5 y 5.6 se selecciona NO, y Si en 5.7 o 5.8 o 5.9 o 5.10 o 5.11 se selecciona Leve';
        case 'medio':
          return 'Si en 5.8 o 5.9 o 5.10 o 5.11 se selecciona moderado';
        case 'medio alto':
          return 'Si en 5.5 o 5.6 se selecciona SI, Si en 5.7 se selecciona moderado';
        case 'alto':
          return 'Si en 5.1 o 5.2 o 5.3 o 5.4 se selecciona SI o Si en 5.7 se selecciona severo';
        default:
          return 'Complete la evaluación de daños para calcular la severidad';
      }
    }

    return _buildSectionCard(
      theme,
      '6. Nivel de Daño',
      Icons.assessment,
      [
        // Porcentaje de Afectación
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6.1 Porcentaje de Afectación',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.percent,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.porcentajeAfectacion ?? 'No especificado',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Severidad de Daños
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getSeveridadColor(state.severidadGlobal).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: getSeveridadColor(state.severidadGlobal),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6.2 Severidad de Daños',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    getSeveridadIcon(state.severidadGlobal),
                    color: getSeveridadColor(state.severidadGlobal),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.severidadGlobal?.toUpperCase() ?? 'NO ESPECIFICADA',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: getSeveridadColor(state.severidadGlobal),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getSeveridadDescription(state.severidadGlobal),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Matriz de Nivel de Daño
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6.3 Nivel de Daño en la Edificación',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Porcentaje de Afectación:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.porcentajeAfectacion ?? 'No especificado',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Severidad:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: getSeveridadColor(state.severidadGlobal),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.severidadGlobal?.toUpperCase() ?? 'NO ESPECIFICADA',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: getSeveridadColor(state.severidadGlobal),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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