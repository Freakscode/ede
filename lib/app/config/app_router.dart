// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


// Layout
import '../shared/widgets/layouts/app_scaffold.dart';
import '../shared/widgets/layouts/app_header.dart';

// Auth pages
import '../modules/auth/presentation/pages/login_screen.dart';

// Evaluacion pages
import '../modules/evaluacion/presentation/pages/home_screen.dart';
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
    initialLocation: '/login',
    routes: [
      // Rutas SIN header (login, onboarding, etc.)
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Shell con layout global (AppScaffold + AppHeader)
      ShellRoute(
        builder: (context, state, child) {
          // Determinar el tipo de header según la ruta
          final AppBarType headerType = _getHeaderTypeFromPath(
            state.matchedLocation,
          );
          final Map<String, String> titleSubtitle = _getTitleSubtitleFromPath(
            state.matchedLocation,
          );

          return AppScaffold(
            headerType: headerType,
            title: titleSubtitle['title'],
            subtitle: titleSubtitle['subtitle'],
            onBackPressed: () =>
                _handleBackNavigation(context, state.matchedLocation),
            onInfoPressed: () => _handleInfoPressed(context),
            onUserPressed: () => _handleUserPressed(context),
            onLogoutPressed: () => {},
            showBackButton: _shouldShowBackButton(state.matchedLocation),
            showLogoutButton: _shouldShowLogoutButton(state.matchedLocation),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LoginScreen(),
          ),

          // Home
          // GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

          // Evaluación - Sección 1: Identificación de Evaluación
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
      ),
    ],
    redirect: (context, state) {
      

      return null; // No redirect needed
    },
  );
}

/// Determina el tipo de header según la ruta actual
AppBarType _getHeaderTypeFromPath(String path) {
  switch (path) {
    // Login con header "Caja de Herramientas"
    case '/':
      return AppBarType.cajaHerramientas;
    
    // Home podría usar logos completos
    case '/home':
      return AppBarType.logosCompletos;
    
    // Rutas de evaluación con "Metodología de Análisis"
    case '/id_evaluacion':
    case '/id_edificacion':
    case '/descripcion_edificacion':
      return AppBarType.metodologiaAnalisis;
    
    // Rutas de riesgos con logos simples
    case '/riesgos_externos':
    case '/evaluacion_danos':
      return AppBarType.logosSimples;
    
    // Rutas finales con un solo logo
    case '/nivel_dano':
    case '/habitabilidad':
    case '/acciones':
    case '/resumen':
      return AppBarType.logoSingle;
    
    // Por defecto usar metodología
    default:
      return AppBarType.metodologiaAnalisis;
  }
}

/// Obtiene título y subtítulo según la ruta actual
Map<String, String> _getTitleSubtitleFromPath(String path) {
  switch (path) {
    case '/':
      return {'title': 'Caja de', 'subtitle': 'Herramientas DAGRD'};
    case '/id_evaluacion':
      return {'title': 'Identificación de la', 'subtitle': 'Evaluación'};
    case '/id_edificacion':
      return {'title': 'Identificación de la', 'subtitle': 'Edificación'};
    case '/descripcion_edificacion':
      return {'title': 'Descripción de la', 'subtitle': 'Edificación'};
    case '/riesgos_externos':
      return {'title': 'Riesgos', 'subtitle': 'Externos'};
    case '/evaluacion_danos':
      return {'title': 'Evaluación de', 'subtitle': 'Daños'};
    case '/nivel_dano':
      return {'title': 'Nivel de', 'subtitle': 'Daño'};
    case '/habitabilidad':
      return {'title': 'Evaluación de', 'subtitle': 'Habitabilidad'};
    case '/acciones':
      return {'title': 'Acciones', 'subtitle': 'Recomendadas'};
    case '/resumen':
      return {'title': 'Resumen de', 'subtitle': 'Evaluación'};
    default:
      return {'title': 'Metodología de', 'subtitle': 'Análisis del Riesgo'};
  }
}

/// Maneja la navegación hacia atrás
void _handleBackNavigation(BuildContext context, String currentPath) {
  // Implementar lógica de navegación personalizada según sea necesario
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    context.go('/');
  }
}

/// Maneja el botón de información
void _handleInfoPressed(BuildContext context) {
  // Implementar lógica de información
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Información'),
      content: const Text('Información sobre la sección actual'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

/// Maneja el botón de usuario
void _handleUserPressed(BuildContext context) {
  // Implementar lógica de perfil de usuario
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Usuario'),
      content: const Text('Perfil del usuario'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

/// Maneja el botón de logout


/// Determina si mostrar el botón de retroceso
bool _shouldShowBackButton(String path) {
  return path != '/';
}

/// Determina si mostrar el botón de logout
bool _shouldShowLogoutButton(String path) {
  return path == '/';
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
