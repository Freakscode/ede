import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:go_router/go_router.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../widgets/widgets.dart';

class FinalRiskResultsScreen extends StatelessWidget {
  const FinalRiskResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              // Título principal
              Text(
                'Perfil del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),

              const SizedBox(height: 10),

              // Subtítulo
              Text(
                'Amenaza',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),

              const SizedBox(height: 24),

              // Secciones de Amenaza
              _buildClassificationSections(context, state, 'amenaza'),

              const SizedBox(height: 24),

              // Calificación de Amenaza
              _buildRatingCard('amenaza'),

              const SizedBox(height: 32),

              // Botón Ir a Análisis de la Amenaza
              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Amenaza',
                'amenaza',
              ),

              const SizedBox(height: 24),
              Text(
                'Vulnerabilidad',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),
              const SizedBox(height: 24),

              // Secciones de Vulnerabilidad
              _buildClassificationSections(context, state, 'vulnerabilidad'),

              const SizedBox(height: 24),

              // Calificación de Vulnerabilidad
              _buildRatingCard('vulnerabilidad'),
              const SizedBox(height: 24),

              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Vulnerabilidad',
                'vulnerabilidad',
              ),

              const SizedBox(height: 24),

              // Matriz de Riesgo Final
              RiskMatrixWidget(state: state),
              const SizedBox(height: 24),

              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
                onContinuePressed: () {
                  CustomActionDialog.show(
                    context: context,
                    title: 'Finalizar formulario',
                    message:
                        '¿Deseas finalizar el formulario? Antes de finalizar, puedes revisar tus respuestas.',
                    leftButtonText: 'Revisar  ',
                    leftButtonIcon: Icons.close,
                    rightButtonText: 'Finalizar  ',
                    rightButtonIcon: Icons.check_circle,
                    onRightButtonPressed: () async {
                      final homeBloc = context.read<HomeBloc>();
                      final homeState = homeBloc.state;
                      final persistenceService = FormPersistenceService();

                      if (homeState.activeFormId != null) {
                        final completeForm = await persistenceService
                            .getCompleteForm(homeState.activeFormId!);

                        if (completeForm != null && context.mounted) {
                          // Completar el formulario
                          context.read<HomeBloc>().add(
                            CompleteForm(completeForm.id),
                          );

                          // Cerrar el diálogo
                          Navigator.of(context).pop();

                          // Mostrar mensaje de éxito
                          CustomSnackBar.showSuccess(
                            context,
                            title: 'Formulario completado',
                            message:
                                'El formulario ha sido guardado y completado exitosamente',
                          );

                          // Navegar a Home y mostrar FormCompletedScreen
                          context.read<HomeBloc>().add(
                            const HomeShowFormCompletedScreen(),
                          );
                          context.go('/home');
                        }
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  /// Helper para construir rating cards
  static Widget _buildRatingCard(String classificationType) {
    return ClassificationRatingCardWidget(
      classificationType: classificationType,
    );
  }

  /// Helper genérico para construir secciones de clasificación (amenaza o vulnerabilidad)
  static Widget _buildClassificationSections(
    BuildContext context,
    RiskThreatAnalysisState state,
    String classificationType,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener IDs de subclasificaciones desde el BLoC
    final subClassificationIds = bloc.getSubClassificationIds(
      classificationType,
    );

    return Column(
      children: subClassificationIds.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Obtener datos usando métodos del BLoC
        final items = bloc.getItemsForSubClassification(
          subClassId,
          classificationType,
        );
        final score = bloc.calculateSectionScore(
          subClassId,
          classificationType,
        );
        final title = bloc.getSubClassificationName(
          subClassId,
          classificationType,
        );

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  static Widget _buildAnalysisButton(
    BuildContext context,
    String text,
    String classificationType,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          final bloc = context.read<RiskThreatAnalysisBloc>();
          bloc.add(SelectClassification(classificationType.toLowerCase()));
          bloc.add(ChangeBottomNavIndex(1));
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: DAGRDColors.azulSecundario, // Azul informativo
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: DAGRDColors.azulSecundario, // Azul informativo
                fontFamily: 'Work Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 16 / 15, // 106.667%
              ),
            ),
          ],
        ),
      ),
    );
  }
}
