import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_state.dart';

class ResultsRiskSectionWidget extends StatelessWidget {
  final HomeState homeState;
  final String selectedEvent;

  const ResultsRiskSectionWidget({
    super.key,
    required this.homeState,
    required this.selectedEvent,
  });

  /// Verifica si tanto Amenaza como Vulnerabilidad están completadas al 100%
  Future<bool> _isBothCompleted() async {
    print('=== _isBothCompleted DEBUG ===');
    print('homeState.activeFormId: ${homeState.activeFormId}');
    print('selectedEvent: $selectedEvent');
    
    if (homeState.activeFormId == null) {
      print('activeFormId es null - retornando false');
      return false;
    }
    
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
      
      print('completeForm encontrado: ${completeForm != null}');
      
      if (completeForm == null) {
        print('completeForm es null - retornando false');
        return false;
      }
      
      // VERIFICACIÓN ADICIONAL: El formulario debe ser para el evento actual
      if (completeForm.eventName != selectedEvent) {
        print('El formulario es para un evento diferente: ${completeForm.eventName} vs $selectedEvent - retornando false');
        return false;
      }
      
      // VERIFICACIÓN ADICIONAL: Si estamos creando un nuevo formulario, el formulario debe estar vacío
      if (homeState.isCreatingNew && 
          (completeForm.amenazaProbabilidadSelections.isNotEmpty || 
           completeForm.amenazaIntensidadSelections.isNotEmpty || 
           completeForm.vulnerabilidadSelections.isNotEmpty)) {
        print('⚠️  Estamos creando un nuevo formulario pero el formulario tiene datos - retornando false');
        print('  - amenazaProbabilidadSelections: ${completeForm.amenazaProbabilidadSelections.isNotEmpty}');
        print('  - amenazaIntensidadSelections: ${completeForm.amenazaIntensidadSelections.isNotEmpty}');
        print('  - vulnerabilidadSelections: ${completeForm.vulnerabilidadSelections.isNotEmpty}');
        return false;
      }
      
      // Verificar si Amenaza está completa
      final amenazaCompleted = completeForm.amenazaProbabilidadSelections.isNotEmpty && 
                              completeForm.amenazaIntensidadSelections.isNotEmpty;
      
      print('amenazaProbabilidadSelections: ${completeForm.amenazaProbabilidadSelections}');
      print('amenazaIntensidadSelections: ${completeForm.amenazaIntensidadSelections}');
      print('amenazaCompleted: $amenazaCompleted');
      
      // Verificar si Vulnerabilidad está completa (tiene al menos una subclasificación con datos)
      final vulnerabilidadCompleted = completeForm.vulnerabilidadSelections.isNotEmpty;
      
      print('vulnerabilidadSelections: ${completeForm.vulnerabilidadSelections}');
      print('vulnerabilidadCompleted: $vulnerabilidadCompleted');
      
      final bothCompleted = amenazaCompleted && vulnerabilidadCompleted;
      print('bothCompleted: $bothCompleted');
      print('=== FIN _isBothCompleted DEBUG ===');
      
      return bothCompleted;
    } catch (e) {
      print('Error al verificar completitud: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        return FutureBuilder<bool>(
          future: _isBothCompleted(),
          builder: (context, snapshot) {
            final bothCompleted = snapshot.data ?? false;
            print('ResultsRiskSectionWidget - bothCompleted: $bothCompleted');
    
    return GestureDetector(
      onTap: bothCompleted ? () {
        // Navegar a la pantalla de análisis de riesgo con navigationData
        final navigationData = {
          'event': selectedEvent,
          'finalResults': true,
          'targetIndex': 3,
        };
        context.go('/risk_threat_analysis', extra: navigationData);
      } : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: bothCompleted 
            ? const Color(0xFFFFCC00)// Amarillo claro cuando está habilitado
            : const Color(0xFFE5E7EB), // Gris cuando está deshabilitado
          borderRadius: BorderRadius.circular(8),
          border: bothCompleted 
            ? Border.all(color: const Color(0xFFFFCC00), width: 1)
            : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(9.882),
              decoration: BoxDecoration(
                color: bothCompleted 
                  ? const Color(0xFF232B48) // AzulDAGRD cuando está habilitado
                  : const Color(0xFFC6C6C6), // Gris cuando está deshabilitado
                borderRadius: BorderRadius.circular(24),
              ),
              child: SvgPicture.asset(
                AppIcons.warning,
                width: 24.707,
                height: 22.059,
                colorFilter: ColorFilter.mode(
                  bothCompleted 
                    ? const Color(0xFFFFCC00) // Amarillo cuando está habilitado
                    : const Color(0xFF706F6F), // Gris oscuro cuando está deshabilitado
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Resultados Riesgo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bothCompleted 
                        ? const Color(0xFF1E1E1E) // Negro cuando está habilitado
                        : const Color(0xFF706F6F), // Gris cuando está deshabilitado
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 24 / 18,
                    ),
                  ),
                  Text(
                    selectedEvent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bothCompleted 
                        ? const Color(0xFF1E1E1E) // Negro cuando está habilitado
                        : const Color(0xFF706F6F), // Gris cuando está deshabilitado
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 24 / 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
          },
        );
      },
    );
  }
}