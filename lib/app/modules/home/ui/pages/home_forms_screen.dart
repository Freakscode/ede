import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/form_card_in_progress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../../../shared/models/form_data_model.dart';
import '../../../../shared/services/form_persistence_service.dart';
import '../../../../shared/models/risk_event_factory.dart';
import '../../../../shared/models/complete_form_data_model.dart';

class HomeFormsScreen extends StatefulWidget {
  const HomeFormsScreen({super.key});

  @override
  State<HomeFormsScreen> createState() => _HomeFormsScreenState();
}

class _HomeFormsScreenState extends State<HomeFormsScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  void _loadForms() {
    // Cargar formularios
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadForms());
    });
  }

  @override
  void didUpdateWidget(HomeFormsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recargar formularios cuando el widget se actualiza
    _loadForms();
  }

  // Método para obtener el progreso real de un formulario usando la misma lógica que ProgressBarWidget
  Future<Map<String, double>> _getFormProgress(String formId) async {
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      print('_getFormProgress Debug - FormId: $formId');
      print('  - CompleteForm found: ${completeForm != null}');
      
      if (completeForm != null) {
        print('  - EventName: ${completeForm.eventName}');
        print('  - Amenaza Probabilidad Selections: ${completeForm.amenazaProbabilidadSelections}');
        print('  - Amenaza Intensidad Selections: ${completeForm.amenazaIntensidadSelections}');
        print('  - Vulnerabilidad Selections: ${completeForm.vulnerabilidadSelections}');
        
        // Usar la misma lógica que ProgressBarWidget para consistencia
        
        // Calcular progreso de amenaza (probabilidad + intensidad)
        double amenazaProgress = _calculateAmenazaProgressFromCompleteForm(completeForm);
        
        // Calcular progreso de vulnerabilidad (todas las subclasificaciones dinámicas)
        double vulnerabilidadProgress = _calculateVulnerabilidadProgressFromCompleteForm(completeForm);
        
        // Progreso total (promedio)
        final totalProgress = (amenazaProgress + vulnerabilidadProgress) / 2;
        
        print('  - Calculated Progress:');
        print('    * Amenaza: $amenazaProgress');
        print('    * Vulnerabilidad: $vulnerabilidadProgress');
        print('    * Total: $totalProgress');
        
        return {
          'amenaza': amenazaProgress,
          'vulnerabilidad': vulnerabilidadProgress,
          'total': totalProgress,
        };
      }
    } catch (e) {
      print('Error al obtener progreso del formulario: $e');
    }
    
    print('  - Returning default progress (0.0)');
    return {
      'amenaza': 0.0,
      'vulnerabilidad': 0.0,
      'total': 0.0,
    };
  }

  // Calcular progreso de amenaza usando la misma lógica que ProgressBarWidget
  double _calculateAmenazaProgressFromCompleteForm(CompleteFormDataModel completeForm) {
    try {
      // Obtener el total esperado del modelo del evento
      final eventName = completeForm.eventName;
      final riskEvent = _getRiskEventByName(eventName);
      
      if (riskEvent == null) {
        print('No se encontró el evento: $eventName');
        return 0.0;
      }
      
      final amenazaClassification = riskEvent.classifications
          .where((c) => c.id.toLowerCase() == 'amenaza')
          .isNotEmpty 
          ? riskEvent.classifications.where((c) => c.id.toLowerCase() == 'amenaza').first
          : null;
      
      if (amenazaClassification == null) return 0.0;
      
      // Buscar subclasificaciones de probabilidad e intensidad
      final probabilidadSubClass = amenazaClassification.subClassifications
          .where((s) => s.id == 'probabilidad')
          .isNotEmpty 
          ? amenazaClassification.subClassifications.where((s) => s.id == 'probabilidad').first
          : null;
      final intensidadSubClass = amenazaClassification.subClassifications
          .where((s) => s.id == 'intensidad')
          .isNotEmpty 
          ? amenazaClassification.subClassifications.where((s) => s.id == 'intensidad').first
          : null;
      
      if (probabilidadSubClass == null || intensidadSubClass == null) return 0.0;
      
      // Contar categorías totales (probabilidad + intensidad)
      final totalCategories = probabilidadSubClass.categories.length + intensidadSubClass.categories.length;
      if (totalCategories == 0) return 0.0;
      
      // Contar categorías completadas
      double completed = 0.0;
      
      // Verificar categorías de probabilidad
      for (final category in probabilidadSubClass.categories) {
        if (completeForm.amenazaProbabilidadSelections.containsKey(category.title)) {
          completed += 1;
        }
      }
      
      // Verificar categorías de intensidad
      for (final category in intensidadSubClass.categories) {
        if (completeForm.amenazaIntensidadSelections.containsKey(category.title)) {
          completed += 1;
        }
      }
      
      final progress = completed / totalCategories;
      print('Amenaza Progress: completed=$completed, total=$totalCategories, progress=$progress');
      return progress;
    } catch (e) {
      print('Error al calcular progreso de amenaza: $e');
      return 0.0;
    }
  }

  // Calcular progreso de vulnerabilidad usando la misma lógica que ProgressBarWidget
  double _calculateVulnerabilidadProgressFromCompleteForm(CompleteFormDataModel completeForm) {
    try {
      final eventName = completeForm.eventName;
      final riskEvent = _getRiskEventByName(eventName);
      
      if (riskEvent == null) {
        print('No se encontró el evento: $eventName');
        return 0.0;
      }
      
      final vulnerabilidadClassification = riskEvent.classifications
          .where((c) => c.id.toLowerCase() == 'vulnerabilidad')
          .isNotEmpty 
          ? riskEvent.classifications.where((c) => c.id.toLowerCase() == 'vulnerabilidad').first
          : null;
      
      if (vulnerabilidadClassification == null) return 0.0;
      
      // Obtener todas las categorías de vulnerabilidad de todas las subclasificaciones
      final expectedCategories = <dynamic>[];
      for (final subClassification in vulnerabilidadClassification.subClassifications) {
        expectedCategories.addAll(subClassification.categories);
      }
      
      final total = expectedCategories.length.toDouble();
      if (total == 0) return 0.0;
      
      // Contar cuántas categorías tienen selecciones
      double completed = 0.0;
      for (final category in expectedCategories) {
        // Buscar en todas las subclasificaciones dinámicas
        bool hasSelection = false;
        for (final subClassId in completeForm.vulnerabilidadSelections.keys) {
          final subClassSelections = completeForm.vulnerabilidadSelections[subClassId];
          if (subClassSelections != null && subClassSelections.containsKey(category.title)) {
            hasSelection = true;
            break;
          }
        }
        if (hasSelection) {
          completed += 1;
        }
      }
      
      final progress = completed / total;
      print('Vulnerabilidad Progress: completed=$completed, total=$total, progress=$progress');
      return progress;
    } catch (e) {
      print('Error al calcular progreso de vulnerabilidad: $e');
      return 0.0;
    }
  }

  // Helper method para obtener el evento por nombre
  dynamic _getRiskEventByName(String eventName) {
    try {
      return RiskEventFactory.getEventByName(eventName);
    } catch (e) {
      print('Error al obtener evento por nombre: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(LoadForms());
            // Esperar un poco para que se complete la carga
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
        const SizedBox(height: 28),
        const Center(
          child: Text(
            'Mis Formularios',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DAGRDColors.azulDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() => _tabIndex = 0);
                        },
                        child: Text(
                          'En proceso',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _tabIndex == 0
                                ? DAGRDColors.azulDAGRD
                                : DAGRDColors.grisMedio,
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() => _tabIndex = 1);
                        },
                        child: Text(
                          'Finalizados',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _tabIndex == 1
                                ? DAGRDColors.azulDAGRD
                                : DAGRDColors.grisMedio,
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                left: _tabIndex == 0
                    ? 0
                    : MediaQuery.of(context).size.width / 2 - 26,
                right: _tabIndex == 0
                    ? MediaQuery.of(context).size.width / 2 - 26
                    : 0,
                bottom: 0,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: DAGRDColors.azulDAGRD,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _tabIndex == 1
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtros',
                      style: TextStyle(
                        color: DAGRDColors.azulDAGRD,
                        fontFamily: 'Work Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 26 / 16,
                        letterSpacing: 0,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.faders,
                        width: 29,
                        height: 27,
                        colorFilter: const ColorFilter.mode(
                          DAGRDColors.azulDAGRD,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _tabIndex == 0
                ? '${state.inProgressForms.length} formularios en proceso'
                : '${state.completedForms.length} formularios finalizados',
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 26 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (state.isLoadingForms) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ] else if (_tabIndex == 0) ...[
          // Formularios en proceso
          ...state.inProgressForms.asMap().entries.map((entry) {
            final index = entry.key;
            final form = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                FutureBuilder<Map<String, double>>(
                  future: _getFormProgress(form.id),
                  builder: (context, snapshot) {
                    final progress = snapshot.data ?? {
                      'amenaza': 0.0,
                      'vulnerabilidad': 0.0,
                      'total': 0.0,
                    };
                    
                    // Debug: imprimir valores de progreso
                    print('FormCard Progress Debug - Form: ${form.title}');
                    print('  - Total: ${progress['total']}');
                    print('  - Amenaza: ${progress['amenaza']}');
                    print('  - Vulnerabilidad: ${progress['vulnerabilidad']}');
                    print('  - Tag (EventName): ${form.riskEvent?.name ?? 'Evento'}');
                    
                    return FormCardInProgress(
                      title: form.title,
                      lastEdit: form.formattedLastModified,
                      tag: form.riskEvent?.name ?? 'Evento', // Mostrar el evento (ej: "Movimiento en Masa")
                      progress: progress['total']!,
                      threat: progress['amenaza']!,
                      vulnerability: progress['vulnerabilidad']!,
                      onDelete: () => _deleteForm(context, form.id, form.title),
                      onTap: () => _navigateToForm(context, form),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        ] else ...[
          // Formularios completados
          ...state.completedForms.asMap().entries.map((entry) {
            final index = entry.key;
            final form = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                FutureBuilder<Map<String, double>>(
                  future: _getFormProgress(form.id),
                  builder: (context, snapshot) {
                    final progress = snapshot.data ?? {
                      'amenaza': 1.0,
                      'vulnerabilidad': 1.0,
                      'total': 1.0,
                    };
                    
                    return GestureDetector(
                      onTap: () => _viewCompletedForm(context, form),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Información del formulario
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          form.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          form.formattedLastModified,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Completado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Información de progreso
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Amenaza: ${(progress['amenaza']! * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Vulnerabilidad: ${(progress['vulnerabilidad']! * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        ],
        const SizedBox(height: 24),
      ],
          ),
        );
      },
    );
  }

  // Métodos de navegación y acciones
  void _navigateToForm(BuildContext context, FormDataModel form) async {
    try {
      // Obtener datos reales del formulario completo desde SQLite
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(form.id);
      
      if (completeForm != null) {
        // Calcular progreso actual para determinar qué sección mostrar
        final amenazaProgress = _calculateAmenazaProgressFromCompleteForm(completeForm);
        final vulnerabilidadProgress = _calculateVulnerabilidadProgressFromCompleteForm(completeForm);
        
        // Determinar mensaje basado en el progreso
        String message = '';
        
        if (amenazaProgress < 1.0) {
          // Amenaza no está completa
          final amenazaPercentage = (amenazaProgress * 100).toInt();
          message = 'Continuando evaluación de Amenaza ($amenazaPercentage% completado)';
        } else if (vulnerabilidadProgress < 1.0) {
          // Amenaza completa, pero vulnerabilidad no
          final vulnerabilidadPercentage = (vulnerabilidadProgress * 100).toInt();
          message = 'Continuando evaluación de Vulnerabilidad ($vulnerabilidadPercentage% completado)';
        } else {
          // Ambas completas - ir a resultados finales
          message = 'Formulario completado - Mostrando resultados finales';
        }
        
        // Mostrar mensaje informativo
        if (message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        
        // Establecer el formulario como activo antes de navegar
        await persistenceService.setActiveFormId(completeForm.id);
        
        // Marcar como editar (no crear nuevo)
        context.read<HomeBloc>().add(SetActiveFormId(completeForm.id));
        
        // Navegar a la pantalla de categorías para ver el progreso y continuar
        context.read<HomeBloc>().add(HomeShowRiskCategoriesScreen(
          completeForm.eventName,
          loadSavedForm: true,
          formId: completeForm.id,
          showProgressInfo: true,
        ));
      } else {
        // Si no se encuentra el formulario, mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo cargar el formulario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error al navegar al formulario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el formulario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewCompletedForm(BuildContext context, FormDataModel form) async {
    try {
      // Obtener datos reales del formulario completo desde SQLite
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(form.id);
      
      if (completeForm != null) {
        // Para formularios completados, navegar directamente a resultados finales
        final navigationData = {
          'event': completeForm.eventName,
          'classification': 'amenaza', // Mostrar amenaza por defecto para resultados
          'finalResults': true,
          'targetIndex': 3,
          'readOnly': true,
          'loadSavedForm': true, // Cambiado de loadSavedCompleteForm a loadSavedForm
          'formId': completeForm.id,
        };
        context.go('/risk_threat_analysis', extra: navigationData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo cargar el formulario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error al cargar formulario completado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el formulario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteForm(BuildContext context, String formId, String formTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Eliminar formulario',
            style: TextStyle(
              color: DAGRDColors.azulDAGRD,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar el formulario "$formTitle"?\n\nEsta acción no se puede deshacer.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  // Eliminar formulario completo desde SQLite
                  final persistenceService = FormPersistenceService();
                  await persistenceService.deleteForm(formId);
                  
                  // Recargar la lista de formularios
                  context.read<HomeBloc>().add(LoadForms());
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Formulario "$formTitle" eliminado'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print('Error al eliminar formulario completo: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar formulario: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
