import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
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
    if (homeState.activeFormId == null) return false;
    
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
      
      if (completeForm == null) return false;
      
      // Verificar si Amenaza está completa
      final amenazaCompleted = completeForm.amenazaProbabilidadSelections.isNotEmpty && 
                              completeForm.amenazaIntensidadSelections.isNotEmpty;
      
      // Verificar si Vulnerabilidad está completa (tiene al menos una subclasificación con datos)
      final vulnerabilidadCompleted = completeForm.vulnerabilidadSelections.isNotEmpty;
      
      return amenazaCompleted && vulnerabilidadCompleted;
    } catch (e) {
      print('Error al verificar completitud: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isBothCompleted(),
      builder: (context, snapshot) {
        final bothCompleted = snapshot.data ?? false;
    
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
  }
}