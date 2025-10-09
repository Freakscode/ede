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

  // Método para obtener el progreso real de un formulario
  Future<Map<String, double>> _getFormProgress(String formId) async {
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);
      
      if (completeForm != null) {
        // Calcular progreso de amenaza basado en subclasificaciones completadas
        double amenazaProgress = 0.0;
        if (completeForm.amenazaSelections.isNotEmpty) {
          final total = completeForm.amenazaSelections.length;
          final completed = completeForm.amenazaSelections.values
              .where((selections) => selections.isNotEmpty)
              .length;
          amenazaProgress = total > 0 ? completed / total : 0.0;
        }
        
        // Calcular progreso de vulnerabilidad basado en subclasificaciones completadas
        double vulnerabilidadProgress = 0.0;
        if (completeForm.vulnerabilidadSelections.isNotEmpty) {
          final total = completeForm.vulnerabilidadSelections.length;
          final completed = completeForm.vulnerabilidadSelections.values
              .where((selections) => selections.isNotEmpty)
              .length;
          vulnerabilidadProgress = total > 0 ? completed / total : 0.0;
        }
        
        // Progreso total (promedio)
        final totalProgress = (amenazaProgress + vulnerabilidadProgress) / 2;
        
        return {
          'amenaza': amenazaProgress,
          'vulnerabilidad': vulnerabilidadProgress,
          'total': totalProgress,
        };
      }
    } catch (e) {
      print('Error al obtener progreso del formulario: $e');
    }
    
    return {
      'amenaza': 0.0,
      'vulnerabilidad': 0.0,
      'total': 0.0,
    };
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
                    
                    return FormCardInProgress(
                      title: form.title,
                      lastEdit: form.formattedLastModified,
                      tag: "Análisis de Riesgo",
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
        // Determinar qué sección mostrar primero (amenaza o vulnerabilidad)
        String initialClassification;
        if (!completeForm.isAmenazaCompleted) {
          initialClassification = 'amenaza';
        } else if (!completeForm.isVulnerabilidadCompleted) {
          initialClassification = 'vulnerabilidad';
        } else {
          // Si ambas están completas, mostrar amenaza por defecto
          initialClassification = 'amenaza';
        }
        
        // Navegar al RiskThreatAnalysisScreen con el formulario completo cargado
        final navigationData = {
          'event': completeForm.eventName,
          'classification': initialClassification,
          'loadSavedCompleteForm': true,
          'formId': completeForm.id,
        };
        
        context.go('/risk_threat_analysis', extra: navigationData);
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
          'loadSavedCompleteForm': true,
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
