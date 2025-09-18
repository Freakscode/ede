import 'package:caja_herramientas/app/modules/tutorial/home_tutorial_overlay.dart';

// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/presentation/pages/login_screen.dart';
import '../modules/splash/presentation/pages/splash_screen.dart';
import '../modules/home/ui/pages/home_screen.dart' as home;

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

// Routes
import 'routes.dart';

/// Creates and configures the application router with clean architecture
GoRouter getAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/splash',
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
        builder: (context, state) => const home.HomeScreen(),
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
