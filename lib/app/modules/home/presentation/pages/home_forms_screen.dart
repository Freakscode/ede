import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/form_card_in_progress.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/completed_form_card_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/home_event.dart';
import '../../presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/auth_state.dart';
import '../../domain/entities/form_entity.dart';
import '../../../../shared/services/form_persistence_service.dart';
import '../../../../shared/models/risk_event_factory.dart';
import '../../../../shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/filter_dialog.dart';
import 'package:caja_herramientas/app/core/data/datasources/remote_datasource.dart';
import 'package:caja_herramientas/app/shared/services/sire_api_service.dart';
import 'dart:developer' as developer;

class HomeFormsScreen extends StatefulWidget {
  const HomeFormsScreen({super.key});

  @override
  State<HomeFormsScreen> createState() => _HomeFormsScreenState();
}

class _HomeFormsScreenState extends State<HomeFormsScreen> {
  int _tabIndex = 0;
  
  // Variables de filtros
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedPhenomenon = 'Todos';
  String _sireNumber = '';

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

      if (completeForm != null) {

        // Usar la misma lógica que ProgressBarWidget para consistencia

        // Calcular progreso de amenaza (probabilidad + intensidad)
        double amenazaProgress = _calculateAmenazaProgressFromCompleteForm(
          completeForm,
        );

        // Calcular progreso de vulnerabilidad (todas las subclasificaciones dinámicas)
        double vulnerabilidadProgress =
            _calculateVulnerabilidadProgressFromCompleteForm(completeForm);

        // Progreso total (promedio)
        final totalProgress = (amenazaProgress + vulnerabilidadProgress) / 2;
        
        return {
          'amenaza': amenazaProgress,
          'vulnerabilidad': vulnerabilidadProgress,
          'total': totalProgress,
        };
      }
    } catch (e) {
      // Error al obtener progreso del formulario
    }

    return {'amenaza': 0.0, 'vulnerabilidad': 0.0, 'total': 0.0};
  }

  // Calcular progreso de amenaza usando la misma lógica que ProgressBarWidget
  double _calculateAmenazaProgressFromCompleteForm(
    CompleteFormDataModel completeForm,
  ) {
    try {
      // Obtener el total esperado del modelo del evento
      final eventName = completeForm.eventName;
      final riskEvent = _getRiskEventByName(eventName);

      if (riskEvent == null) {
        return 0.0;
      }

      final amenazaClassification =
          riskEvent.classifications
              .where((c) => c.id.toLowerCase() == 'amenaza')
              .isNotEmpty
          ? riskEvent.classifications
                .where((c) => c.id.toLowerCase() == 'amenaza')
                .first
          : null;

      if (amenazaClassification == null) return 0.0;

      // Buscar subclasificaciones de probabilidad e intensidad
      final probabilidadSubClass =
          amenazaClassification.subClassifications
              .where((s) => s.id == 'probabilidad')
              .isNotEmpty
          ? amenazaClassification.subClassifications
                .where((s) => s.id == 'probabilidad')
                .first
          : null;
      final intensidadSubClass =
          amenazaClassification.subClassifications
              .where((s) => s.id == 'intensidad')
              .isNotEmpty
          ? amenazaClassification.subClassifications
                .where((s) => s.id == 'intensidad')
                .first
          : null;

      if (probabilidadSubClass == null || intensidadSubClass == null)
        return 0.0;

      // Contar categorías totales (probabilidad + intensidad)
      final totalCategories =
          probabilidadSubClass.categories.length +
          intensidadSubClass.categories.length;
      if (totalCategories == 0) return 0.0;

      // Contar categorías completadas
      double completed = 0.0;

      // Verificar categorías de probabilidad
      for (final category in probabilidadSubClass.categories) {
        if (completeForm.amenazaProbabilidadSelections.containsKey(
          category.title,
        )) {
          completed += 1;
        }
      }

      // Verificar categorías de intensidad
      for (final category in intensidadSubClass.categories) {
        if (completeForm.amenazaIntensidadSelections.containsKey(
          category.title,
        )) {
          completed += 1;
        }
      }

      final progress = completed / totalCategories;
      return progress;
    } catch (e) {
      return 0.0;
    }
  }

  // Calcular progreso de vulnerabilidad usando la misma lógica que ProgressBarWidget
  double _calculateVulnerabilidadProgressFromCompleteForm(
    CompleteFormDataModel completeForm,
  ) {
    try {
      final eventName = completeForm.eventName;
      final riskEvent = _getRiskEventByName(eventName);

      if (riskEvent == null) {
        return 0.0;
      }

      final vulnerabilidadClassification =
          riskEvent.classifications
              .where((c) => c.id.toLowerCase() == 'vulnerabilidad')
              .isNotEmpty
          ? riskEvent.classifications
                .where((c) => c.id.toLowerCase() == 'vulnerabilidad')
                .first
          : null;

      if (vulnerabilidadClassification == null) return 0.0;

      // Obtener todas las categorías de vulnerabilidad de todas las subclasificaciones
      final expectedCategories = <dynamic>[];
      for (final subClassification
          in vulnerabilidadClassification.subClassifications) {
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
          final subClassSelections =
              completeForm.vulnerabilidadSelections[subClassId];
          if (subClassSelections != null &&
              subClassSelections.containsKey(category.title)) {
            hasSelection = true;
            break;
          }
        }
        if (hasSelection) {
          completed += 1;
        }
      }

      final progress = completed / total;
      return progress;
    } catch (e) {
      return 0.0;
    }
  }

  // Helper method para obtener el evento por nombre
  dynamic _getRiskEventByName(String eventName) {
    try {
      return RiskEventFactory.getEventByName(eventName);
    } catch (e) {
      return null;
    }
  }

  // Método para filtrar los formularios completados
  List<FormEntity> _filterCompletedForms(List<FormEntity> forms) {
    return forms.where((form) {
      // Filtro por fenómeno amenazante
      if (_selectedPhenomenon != 'Todos') {
        if (form.riskEvent != _selectedPhenomenon) {
          return false;
        }
      }
      
      // Filtro por rango de fechas
      if (_startDate != null || _endDate != null) {
        final formDate = form.lastModified;
        
        if (_startDate != null && formDate.isBefore(_startDate!)) {
          return false;
        }
        
        if (_endDate != null && formDate.isAfter(_endDate!.add(const Duration(days: 1)))) {
          return false;
        }
      }
      
      // Filtro por número SIRE
      if (_sireNumber.isNotEmpty) {
        // TODO: Implementar filtro por número SIRE cuando esté disponible en FormEntity
        // Por ahora, no filtrar por SIRE
      }
      
      return true;
    }).toList();
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
                            onPressed: () async {
                              // Get authentication status
                              final authState = context.read<AuthBloc>().state;
                              final isAuthenticated = authState is AuthAuthenticated;
                              
                              final filters = await FilterDialog.show(
                                context,
                                isUserAuthenticated: isAuthenticated,
                              );
                              if (filters != null && mounted) {
                                // Aplicar filtros
                                setState(() {
                                  _startDate = filters['startDate'];
                                  _endDate = filters['endDate'];
                                  _selectedPhenomenon = filters['phenomenon'] ?? 'Todos';
                                  _sireNumber = filters['sireNumber'] ?? '';
                                });
                                
                                CustomSnackBar.showInfo(
                                  context,
                                  message: 'Filtros aplicados',
                                  title: 'Filtros',
                                );
                              }
                            },
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
                      : '${_filterCompletedForms(state.completedForms).length} formularios finalizados',
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
                          final progress =
                              snapshot.data ??
                              {
                                'amenaza': 0.0,
                                'vulnerabilidad': 0.0,
                                'total': 0.0,
                              };

                              

                          return FormCardInProgress(
                            title: form.title,
                            lastEdit: form.formattedLastModified,
                            tag:
                                form.riskEvent ??
                                'Evento', // Mostrar el evento (ej: "Movimiento en Masa")
                            progress: progress['total']!,
                            threat: progress['amenaza']!,
                            vulnerability: progress['vulnerabilidad']!,
                            onDelete: () =>
                                _deleteForm(context, form.id, form.title),
                            onTap: () {
                              _navigateToForm(context, form);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }),
              ] else ...[
                // Formularios completados
                ..._filterCompletedForms(state.completedForms).asMap().entries.map((entry) {
                  final index = entry.key;
                  final form = entry.value;
                  return Column(
                    children: [
                      if (index > 0) const SizedBox(height: 16),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return CompletedFormCardWidget(
                            form: form,
                            onDownload: () => _showMessage(context, 'Funcionalidad de descarga en desarrollo'),
                            onAssociateToSIRE: () => _associateFormToSIRE(context, form),
                            onSendEmail: () => _showMessage(context, 'Funcionalidad de envío por email en desarrollo'),
                            onDelete: () => _deleteForm(context, form.id, form.title),
                            getFormProgress: _getFormProgress,
                            isUserAuthenticated: authState is AuthAuthenticated,
                          );
                        },
                      ),
                    ],
                  );
                }),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // Métodos de navegación y acciones
  void _navigateToForm(BuildContext context, FormEntity form) async {
    try {
      // Obtener datos reales del formulario completo desde SQLite
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(form.id);

      if (completeForm != null) {
        // Establecer el formulario como activo antes de navegar
        await persistenceService.setActiveFormId(completeForm.id);

        // Check if widget is still mounted before using context
        if (!mounted) return;

        // Get bloc references before async gap
        final homeBloc = context.read<HomeBloc>();
        final riskBloc = context.read<RiskThreatAnalysisBloc>();

        // No resetear el estado del BLoC aquí para preservar los datos cargados

        // Determinar la clasificación basándose en los datos disponibles
        // Priorizar amenaza primero, ya que es el flujo natural de creación
        String classificationType = 'amenaza'; // Por defecto
        
        
        // Si hay datos de amenaza (probabilidad o intensidad), usar amenaza
        if (completeForm.amenazaProbabilidadSelections.isNotEmpty || 
            completeForm.amenazaIntensidadSelections.isNotEmpty) {
          classificationType = 'amenaza';
        }
        // Solo usar vulnerabilidad si hay datos específicos de vulnerabilidad Y amenaza está completa
        else if (completeForm.vulnerabilidadSelections.isNotEmpty) {
          classificationType = 'vulnerabilidad';
        }
        

        // Calcular el progreso del formulario
        final progress = await _getFormProgress(form.id);
        
        // Cargar los datos específicos del formulario en el RiskThreatAnalysisBloc
        final evaluationData = completeForm.toJson();
        
        riskBloc.add(LoadFormData(
          eventName: completeForm.eventName,
          classificationType: classificationType,
          evaluationData: evaluationData,
        ));

        // Marcar como editar (no crear nuevo)
        homeBloc.add(SetActiveFormId(formId: completeForm.id, isCreatingNew: false));

        // Guardar el progreso en el estado del HomeBloc para preservarlo
        homeBloc.add(SetFormProgress(
          formId: completeForm.id,
          progressData: progress,
        ));

        // Navegar al RiskThreatAnalysisScreen (siempre empieza en CategoriesScreen)
        // Convertir eventName a eventId usando RiskEventFactory
        final riskEvent = RiskEventFactory.getEventByName(completeForm.eventName);
        final eventId = riskEvent?.id ?? completeForm.eventName; // Fallback al nombre si no se encuentra
        
        final navigationData = {
          'eventId': eventId,
          'formId': completeForm.id,
          'showProgressInfo': true,
          'progressData': progress,
        };
        
        if (!mounted) return;
        context.go('/risk-threat-analysis', extra: navigationData);
      } else {
        // Si no se encuentra el formulario, mostrar error
        if (!mounted) return;
        CustomSnackBar.showError(
          context,
          message: 'No se pudo cargar el formulario',
          title: 'Error',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(
        context,
        message: 'Error al cargar el formulario: $e',
        title: 'Error',
      );
    }
  }

  void _deleteForm(BuildContext context, String formId, String formTitle) {
    CustomActionDialog.show(
      context: context,
      title: 'Eliminar formulario',
      message: '¿Está seguro que desea eliminar el borrador de este formulario?',
      leftButtonText: 'Cancelar',
      leftButtonIcon: Icons.close,
      onLeftButtonPressed: () => Navigator.of(context).pop(),
      rightButtonText: 'Eliminar',
      rightButtonIcon: Icons.delete,
      rightButtonColor: Colors.red,
      onRightButtonPressed: () async {
        Navigator.of(context).pop();
        try {
          // Eliminar formulario completo desde SQLite
          final persistenceService = FormPersistenceService();
          await persistenceService.deleteForm(formId);

          // Check if widget is still mounted before using context
          if (!mounted) return;

          // Recargar la lista de formularios
          context.read<HomeBloc>().add(LoadForms());

          CustomSnackBar.showSuccess(
            context,
            message: 'Formulario "$formTitle" eliminado',
            title: 'Eliminado',
            duration: const Duration(seconds: 2),
          );
        } catch (e) {
          if (!mounted) return;
          CustomSnackBar.showError(
            context,
            message: 'Error al eliminar formulario: $e',
            title: 'Error',
          );
        }
      },
    );
  }


  void _showMessage(BuildContext context, String message) {
    CustomSnackBar.showWarning(
      context,
      message: message,
    );
  }

  /// Asocia un formulario completado a SIRE
  Future<void> _associateFormToSIRE(BuildContext context, FormEntity form) async {
    try {
      // Mostrar diálogo de confirmación
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Asociar a SIRE'),
          content: const Text(
            '¿Está seguro que desea asociar este formulario a SIRE?\n\n'
            'Esta acción enviará los datos del formulario a la plataforma SIRE.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azulDAGRD,
              ),
              child: const Text('Asociar'),
            ),
          ],
        ),
      );

      if (shouldProceed != true || !mounted) return;

      // Mostrar indicador de carga
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Obtener el formulario completo desde la base de datos
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(form.id);

      if (completeForm == null) {
        if (!mounted) return;
        Navigator.of(context).pop(); // Cerrar diálogo de carga
        CustomSnackBar.showError(
          context,
          message: 'No se pudo encontrar el formulario completo',
          title: 'Error',
        );
        return;
      }

      // Obtener token de autenticación si está disponible
      String? authToken;
      try {
        final authBloc = context.read<AuthBloc>();
        final authState = authBloc.state;
        if (authState is AuthAuthenticated) {
          // Intentar obtener el token desde el repositorio
          // Necesitamos acceder al repositorio, pero por ahora usaremos null
          // y el servicio usará autenticación básica como fallback
        }
      } catch (e) {
        developer.log('Error obteniendo token: $e', name: 'HomeFormsScreen');
      }

      // Crear servicio de API de SIRE
      final remoteDatasource = await RemoteDatasource.create();
      final sireApiService = SireApiService(remoteDatasource);

      // Transformar y enviar el formulario (simulado)
      final response = await sireApiService.sendFormToSIRE(
        completeForm,
        authToken: authToken,
        simulate: true,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Cerrar diálogo de carga

      // Mostrar mensaje de éxito (simulación)
      CustomSnackBar.showSuccess(
        context,
        message: 'Simulación exitosa: se imprimió el JSON en consola',
        title: 'Simulado',
        duration: const Duration(seconds: 3),
      );

      // Si la respuesta incluye un número SIRE, podríamos actualizarlo en el formulario
      if (response.containsKey('sireNumber')) {
        developer.log(
          'Número SIRE recibido: ${response['sireNumber']}',
          name: 'HomeFormsScreen',
        );
      }
    } catch (e) {
      developer.log(
        'Error asociando formulario a SIRE: $e',
        name: 'HomeFormsScreen',
      );

      if (!mounted) return;
      // Cerrar diálogo de carga si está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Mostrar mensaje de error
      CustomSnackBar.showError(
        context,
        message: 'Error al asociar formulario a SIRE: ${e.toString()}',
        title: 'Error',
        duration: const Duration(seconds: 4),
      );
    }
  }
}
