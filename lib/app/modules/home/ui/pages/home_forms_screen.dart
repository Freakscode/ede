import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/form_card_completed.dart';
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
                GestureDetector(
                  onTap: () => _navigateToForm(context, form),
                  child: FormCardInProgress(
                    title: form.title,
                    lastEdit: form.formattedLastModified,
                    tag: form.eventType,
                    progress: form.progressPercentage,
                    threat: form.threatProgress,
                    vulnerability: form.vulnerabilityProgress,
                    onDelete: () => _deleteForm(context, form.id, form.title),
                  ),
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
                GestureDetector(
                  onTap: () => _viewCompletedForm(context, form),
                  child: FormCardCompleted(
                    title: form.title,
                    lastEdit: form.formattedLastModified,
                    tag: form.eventType,
                  ),
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
  void _navigateToForm(BuildContext context, FormDataModel form) {
    // Cargar formulario para edición
    context.read<HomeBloc>().add(LoadFormForEditing(form.id));
    
    // Navegar a la pantalla de análisis de riesgo
    final navigationData = {
      'event': form.eventType,
      'loadExisting': true,
      'formId': form.id,
    };
    context.go('/risk_threat_analysis', extra: navigationData);
  }

  void _viewCompletedForm(BuildContext context, FormDataModel form) {
    // Para formularios completados, navegar directamente a resultados finales
    final navigationData = {
      'event': form.eventType,
      'finalResults': true,
      'targetIndex': 3,
      'readOnly': true,
      'formId': form.id,
    };
    context.go('/risk_threat_analysis', extra: navigationData);
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
              onPressed: () {
                Navigator.of(context).pop();
                context.read<HomeBloc>().add(DeleteForm(formId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Formulario "$formTitle" eliminado'),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Deshacer',
                      textColor: Colors.white,
                      onPressed: () {
                        // TODO: Implementar deshacer eliminación
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de deshacer no disponible'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ),
                );
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
