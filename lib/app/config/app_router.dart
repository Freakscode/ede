
// ignore_for_file: unused_import

import 'dart:async';

import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/pages/risk_threat_analysis_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/pages/final_risk_results_screen.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/pages/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/ui/pages/login_screen.dart';
import '../modules/splash/presentation/pages/splash_screen.dart';
import '../modules/home/presentation/pages/home_screen.dart' as home;
import '../modules/home/presentation/pages/home_forms_screen.dart';
import '../modules/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/evaluacion/presentation/pages/home_screen.dart'
    as evaluacion;
import '../modules/evaluacion/presentation/pages/sect_1/id_evaluacion_page.dart';
import '../modules/evaluacion/presentation/pages/sect_2/id_edificacion_page.dart';
import '../modules/evaluacion/presentation/pages/sect_3/descripcion_edificacion_page.dart';
import '../modules/evaluacion/presentation/pages/sect_4/riesgos_externos_page.dart';
import '../modules/evaluacion/presentation/pages/sect_5/evaluacion_danos_page.dart';
import '../modules/evaluacion/presentation/pages/sect_6/nivel_dano_page.dart';
import '../modules/evaluacion/presentation/pages/sect_7/habitabilidad_page.dart';
import '../modules/evaluacion/presentation/pages/sect_8/acciones_page.dart';
import '../modules/evaluacion/presentation/pages/resumen_evaluacion_page.dart';
import '../modules/data_registration/ui/pages/data_registration_screen.dart';
import '../modules/webview/presentation/presentation.dart';

// Routes
import 'routes.dart';

/// Creates and configures the application router with clean architecture
GoRouter getAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),

      // Home - Pantalla principal
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return home.HomeScreen(navigationData: extra);
        },
      ),
      
      // Home Forms - Formularios en proceso y finalizados
      GoRoute(
        path: '/home_forms',
        builder: (context, state) => const HomeFormsScreen(),
      ),
      // Risk Threat Analysis - Análisis de riesgo y amenazas
      GoRoute(
        path: '/risk-threat-analysis',
        builder: (context, state) {
          // Manejar tanto String (compatibilidad) como Map (nuevo formato)
          if (state.extra is Map<String, dynamic>) {
            final navigationData = state.extra as Map<String, dynamic>;
            
            // Determinar el modo basándose en los datos de navegación
            final isNewForm = navigationData['isNewForm'] as bool? ?? false;
            final loadSavedForm = navigationData['loadSavedForm'] as bool? ?? false;
            
            // Determinar el modo del formulario
            String formMode;
            if (isNewForm) {
              formMode = 'create';
            } else if (loadSavedForm) {
              formMode = 'edit';
            } else {
              // Verificar si hay un formulario activo
              final homeBloc = context.read<HomeBloc>();
              final homeState = homeBloc.state;
              formMode = (homeState.activeFormId != null && homeState.activeFormId!.isNotEmpty) 
                  ? 'edit' 
                  : 'create';
            }
            
            return RiskThreatAnalysisScreen(
              event: navigationData['event'] as String?,
              targetIndex: navigationData['targetIndex'] as int? ?? 0,
              formId: navigationData['formId'] as String?,
              formMode: formMode,
            );
          } else {
            final selectedEvent = state.extra as String?;
            return RiskThreatAnalysisScreen(
              event: selectedEvent,
              targetIndex: 0,
              formId: null,
              formMode: 'create', // Por defecto para compatibilidad
            );
          }
        },
      ),
      
      // Data Registration - Registro de datos
      GoRoute(
        path: '/data_registration',
        builder: (context, state) => const DataRegistrationScreen(),
      ),
      
      // WebView - Portal SIRMED
      GoRoute(
        path: '/sirmed_portal',
        builder: (context, state) => const SirmedPortalScreen(),
      ),
      




      // EDE - Configuración rutas
      // Evaluación - Sección 1: Identificación de Evaluación
      
      GoRoute(
        path: '/home_ede',
        builder: (context, state) => const evaluacion.HomeEdeScreen(),
      ),
      GoRoute(
        path: '/id_evaluacion',
        builder: (context, state) => const EvaluacionWizardPage(),
      ),

      // Evaluación - Sección 2: Identificación de Edificación
      GoRoute(
        path: '/id_edificacion',
        builder: (context, state) => const EdificacionPageWrapper(),
      ),

      // Evaluación - Sección 3: Descripción de Edificación
      GoRoute(
        path: '/descripcion_edificacion',
        builder: (context, state) => const DescripcionEdificacionPage(),
      ),

      // Evaluación - Sección 4: Riesgos Externos
      GoRoute(
        path: '/riesgos_externos',
        builder: (context, state) => const RiesgosExternosPage(),
      ),

      // Evaluación - Sección 5: Evaluación de Daños
      GoRoute(
        path: '/evaluacion_danos',
        builder: (context, state) => const EvaluacionDanosPage(),
      ),

      // Evaluación - Sección 6: Nivel de Daño
      GoRoute(
        path: '/nivel_dano',
        builder: (context, state) => const NivelDanoPage(),
      ),

      // Evaluación - Sección 7: Habitabilidad
      GoRoute(
        path: '/habitabilidad',
        builder: (context, state) => const HabitabilidadPage(),
      ),

      // Evaluación - Sección 8: Acciones
      GoRoute(
        path: '/acciones',
        builder: (context, state) => const AccionesPage(),
      ),

      // Resumen de Evaluación
      GoRoute(
        path: '/resumen',
        builder: (context, state) => const ResumenEvaluacionPage(),
      ),
    ],
    redirect: (context, state) {
      return null; // No redirect needed
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
