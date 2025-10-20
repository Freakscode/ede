import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/modules/auth/services/auth_service.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_bloc.dart';
import 'package:caja_herramientas/app/modules/data_registration/bloc/data_registration_state.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../../../home/bloc/home_bloc.dart';
import '../../../home/bloc/home_event.dart';

class SaveProgressButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Map<String, dynamic>? contactData;
  final Map<String, dynamic>? inspectionData;

  const SaveProgressButton({
    super.key, 
    this.onPressed, 
    this.text,
    this.contactData,
    this.inspectionData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onPressed ?? () => _showProgressInfo(context),
            icon: SvgPicture.asset(
              AppIcons.save,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                DAGRDColors.blancoDAGRD,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              text ?? 'Guardar avance',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFFFFF), // #FFF
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 24 / 14, // line-height: 171.429%
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }

  void _showProgressInfo(BuildContext context) async {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final state = bloc.state;
    final homeBloc = context.read<HomeBloc>();
    final homeState = homeBloc.state;
    final authService = AuthService();

    print('=== SaveProgressButton: Iniciando guardado ===');
    print('Evento seleccionado: ${state.selectedRiskEvent}');
    print('Clasificación seleccionada: ${state.selectedClassification}');
    print('isCreatingNew: ${homeState.isCreatingNew}');
    print('activeFormId: ${homeState.activeFormId}');
    print('Usuario autenticado: ${authService.isLoggedIn}');
    print('Usuario actual: ${authService.currentUser?.nombre}');

    // Usar datos pasados como parámetros o consultar del bloc como fallback
    print('=== PROCESANDO DATOS DE CONTACTO E INSPECCIÓN ===');
    print('Usuario autenticado: ${authService.isLoggedIn}');
    print('Usuario actual: ${authService.currentUser?.nombre}');
    
    // Determinar datos según el estado de autenticación
    Map<String, dynamic> contactData = {};
    Map<String, dynamic> inspectionData = {};
    
    if (authService.isLoggedIn) {
      // Usuario logueado - datos de contacto vienen de la API
      final user = authService.currentUser;
      contactData = {
        'names': user?.nombre ?? '',
        'cellPhone': user?.cedula ?? '',
        'landline': '',
        'email': user?.email ?? '',
      };
      print('=== Usuario logueado: Datos de contacto desde API ===');
      print('Nombre: ${contactData['names']}');
      print('Cédula: ${contactData['cellPhone']}');
      print('Email: ${contactData['email']}');
      
      // Usuario logueado NO tiene datos de inspección específicos
      // Los datos de inspección solo existen para usuarios no logueados
      inspectionData = {};
      print('=== Usuario logueado: Sin datos de inspección específicos ===');
      
    } else {
      // Usuario no logueado - usar datos pasados como parámetros o consultar del bloc
      contactData = this.contactData ?? {};
      inspectionData = this.inspectionData ?? {};
      
      print('Datos de contacto pasados: $contactData');
      print('Datos de inspección pasados: $inspectionData');
      
      // Si no se pasaron datos como parámetros, consultar del bloc como fallback
      if (contactData.isEmpty) {
        final dataRegistrationBloc = context.read<DataRegistrationBloc>();
        final dataRegistrationState = dataRegistrationBloc.state;
        
        if (dataRegistrationState is DataRegistrationData) {
          contactData = {
            'names': dataRegistrationState.contactNames,
            'cellPhone': dataRegistrationState.contactCellPhone,
            'landline': dataRegistrationState.contactLandline,
            'email': dataRegistrationState.contactEmail,
          };
          print('=== Fallback: Datos de contacto desde formulario ===');
        }
      }
      
      // Si no se pasaron datos de inspección como parámetros, consultar del bloc como fallback
      if (inspectionData.isEmpty) {
        final dataRegistrationBloc = context.read<DataRegistrationBloc>();
        final dataRegistrationState = dataRegistrationBloc.state;
        
        if (dataRegistrationState is DataRegistrationData) {
          inspectionData = {
            'incidentId': dataRegistrationState.inspectionIncidentId,
            'status': dataRegistrationState.inspectionStatus,
            'date': dataRegistrationState.inspectionDate,
            'time': dataRegistrationState.inspectionTime,
            'comment': dataRegistrationState.inspectionComment,
            'injured': dataRegistrationState.inspectionInjured,
            'dead': dataRegistrationState.inspectionDead,
          };
          print('=== Fallback: Datos de inspección desde formulario ===');
        }
      }
    }
    
    print('=== Datos finales a guardar ===');
    print('Contacto: $contactData');
    print('Inspección: $inspectionData');

    print('=== Procediendo con guardado incluyendo datos de contacto ===');

    try {
      final persistenceService = FormPersistenceService();

      // Obtener datos actuales del formulario
      final formData = bloc.getCurrentFormData();
      print('FormData obtenido: $formData');
      print('EvidenceImages: ${formData['evidenceImages']}');
      print('EvidenceCoordinates: ${formData['evidenceCoordinates']}');
      print(
        'EvidenceCoordinates type: ${formData['evidenceCoordinates'].runtimeType}',
      );

      // Sin validaciones - proceder directamente con el guardado

      // Convertir colores a valores enteros para serialización
      final colorsData =
          formData['subClassificationColors'] as Map<String, Color>? ?? {};
      final serializableColors = <String, Color>{};
      colorsData.forEach((key, value) {
        serializableColors[key] = value;
      });

      // Crear ID único para el formulario completo
      final formId =
          '${state.selectedRiskEvent}_complete_${DateTime.now().millisecondsSinceEpoch}';
      print('FormID generado: $formId');

      CompleteFormDataModel completeForm;
      final now = DateTime.now();

      // Si estamos creando un nuevo formulario, siempre crear uno nuevo
      if (homeState.isCreatingNew || homeState.activeFormId == null) {
        print(
          'SaveProgressButton: Creando nuevo formulario (isCreatingNew: ${homeState.isCreatingNew})',
        );

        completeForm = CompleteFormDataModel(
          id: formId,
          eventName: state.selectedRiskEvent,
          // Datos de contacto asociados al formulario
          contactData: contactData,
          // Datos de inspección asociados al formulario
          inspectionData: inspectionData,
          amenazaSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['dynamicSelections'] ?? {})
              : {},
          amenazaScores: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['subClassificationScores'] ?? {})
              : {},
          amenazaColors: state.selectedClassification.toLowerCase() == 'amenaza'
              ? serializableColors
              : {},
          amenazaProbabilidadSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['probabilidadSelections'] ?? {})
              : {},
          amenazaIntensidadSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['intensidadSelections'] ?? {})
              : {},
          amenazaSelectedProbabilidad:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedProbabilidad']
              : null,
          amenazaSelectedIntensidad:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedIntensidad']
              : null,
          vulnerabilidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['dynamicSelections'] ?? {})
              : {},
          vulnerabilidadScores:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationScores'] ?? {})
              : {},
          vulnerabilidadColors:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? serializableColors
              : {},
          vulnerabilidadProbabilidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['probabilidadSelections'] ?? {})
              : {},
          vulnerabilidadIntensidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['intensidadSelections'] ?? {})
              : {},
          vulnerabilidadSelectedProbabilidad:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedProbabilidad']
              : null,
          vulnerabilidadSelectedIntensidad:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedIntensidad']
              : null,
          evidenceImages: state.evidenceImages,
          evidenceCoordinates: state.evidenceCoordinates,
          createdAt: now,
          updatedAt: now,
        );
      } else {
        // Estamos editando un formulario existente
        print(
          'SaveProgressButton: Editando formulario existente ${homeState.activeFormId}',
        );

        // Obtener el formulario existente por ID
        final existingForm = await persistenceService.getCompleteForm(
          homeState.activeFormId!,
        );
        if (existingForm == null) {
          throw Exception(
            'No se encontró el formulario existente con ID: ${homeState.activeFormId}',
          );
        }

        completeForm = existingForm;

        // Actualizar según la clasificación actual
        if (state.selectedClassification.toLowerCase() == 'amenaza') {
          completeForm = completeForm.copyWith(
            amenazaSelections:
                formData['dynamicSelections'] ?? completeForm.amenazaSelections,
            amenazaScores:
                formData['subClassificationScores'] ??
                completeForm.amenazaScores,
            amenazaColors: serializableColors.isNotEmpty
                ? serializableColors
                : completeForm.amenazaColors,
            amenazaProbabilidadSelections:
                formData['probabilidadSelections'] ??
                completeForm.amenazaProbabilidadSelections,
            amenazaIntensidadSelections:
                formData['intensidadSelections'] ??
                completeForm.amenazaIntensidadSelections,
            amenazaSelectedProbabilidad:
                formData['selectedProbabilidad'] ??
                completeForm.amenazaSelectedProbabilidad,
            amenazaSelectedIntensidad:
                formData['selectedIntensidad'] ??
                completeForm.amenazaSelectedIntensidad,
            contactData: contactData,
            inspectionData: inspectionData,
            evidenceImages: state.evidenceImages,
            evidenceCoordinates: state.evidenceCoordinates,
            updatedAt: now,
          );
        } else if (state.selectedClassification.toLowerCase() ==
            'vulnerabilidad') {
          completeForm = completeForm.copyWith(
            vulnerabilidadSelections:
                formData['dynamicSelections'] ??
                completeForm.vulnerabilidadSelections,
            vulnerabilidadScores:
                formData['subClassificationScores'] ??
                completeForm.vulnerabilidadScores,
            vulnerabilidadColors: serializableColors.isNotEmpty
                ? serializableColors
                : completeForm.vulnerabilidadColors,
            vulnerabilidadProbabilidadSelections:
                formData['probabilidadSelections'] ??
                completeForm.vulnerabilidadProbabilidadSelections,
            vulnerabilidadIntensidadSelections:
                formData['intensidadSelections'] ??
                completeForm.vulnerabilidadIntensidadSelections,
            vulnerabilidadSelectedProbabilidad:
                formData['selectedProbabilidad'] ??
                completeForm.vulnerabilidadSelectedProbabilidad,
            vulnerabilidadSelectedIntensidad:
                formData['selectedIntensidad'] ??
                completeForm.vulnerabilidadSelectedIntensidad,
            contactData: contactData,
            inspectionData: inspectionData,
            evidenceImages: state.evidenceImages,
            evidenceCoordinates: state.evidenceCoordinates,
            updatedAt: now,
          );
        }
      }

      if (context.mounted) {
        CustomActionDialog.show(
          context: context,
          title: 'Guardar borrador',
          message:
              '¿Está seguro que desea guardar un borrador de este formulario? Podrá continuar más tarde.',
          leftButtonText: 'Cancelar',
          leftButtonIcon: Icons.close,
          rightButtonText: 'Guardar',
          rightButtonIcon: Icons.check,
          onRightButtonPressed: () async {
            print('=== SaveProgressButton: Usuario confirmó guardado ===');
            print('Formulario a guardar: ${completeForm.id}');

            try {
              // Guardar formulario completo
              await persistenceService.saveCompleteForm(completeForm);
              print('SaveProgressButton: Formulario guardado en base de datos');
              
              // === LOGGING DETALLADO PARA DEVTOOLS ===
              print('=== DATOS GUARDADOS EN SQLITE ===');
              print('ID del formulario: ${completeForm.id}');
              print('Evento: ${completeForm.eventName}');
              print('Datos de contacto: ${completeForm.contactData}');
              print('Datos de inspección: ${completeForm.inspectionData}');
              print('Fecha de creación: ${completeForm.createdAt}');
              print('Fecha de actualización: ${completeForm.updatedAt}');
              print('==================================');
              
              // Verificar que se guardó correctamente
              final savedForm = await persistenceService.getCompleteForm(completeForm.id);
              if (savedForm != null) {
                print('=== VERIFICACIÓN DE GUARDADO ===');
                print('Formulario recuperado: ${savedForm.id}');
                print('Contacto guardado: ${savedForm.contactData}');
                print('Inspección guardada: ${savedForm.inspectionData}');
                print('===============================');
              } else {
                print('ERROR: No se pudo recuperar el formulario guardado');
              }

              // Establecer como formulario activo
              await persistenceService.setActiveFormId(completeForm.id);
              print('SaveProgressButton: Formulario activo establecido');

              // Si era un formulario nuevo, actualizar el estado del HomeBloc
              if (homeState.isCreatingNew) {
                homeBloc.add(
                  SetActiveFormId(completeForm.id, isCreatingNew: false),
                );
                print(
                  'SaveProgressButton: Actualizando HomeBloc - isCreatingNew: false',
                );
              }

              print(
                'SaveProgressButton: Formulario completo guardado exitosamente - ${completeForm.id} (${state.selectedClassification})',
              );

              Navigator.of(context).pop();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progreso guardado exitosamente'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              print('SaveProgressButton: Error en onRightButtonPressed - $e');
              Navigator.of(context).pop();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al guardar: $e'),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      }
    } catch (e) {
      print('SaveProgressButton: Error al guardar progreso - $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar progreso: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
