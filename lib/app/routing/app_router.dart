// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/evaluacion/presentation/bloc/evaluacion/evaluacion_bloc.dart';

import '../../features/evaluacion/presentation/pages/home_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/evaluacion/presentation/pages/sect_1/id_evaluacion_page.dart';
import '../../features/evaluacion/presentation/pages/sect_2/id_edificacion_page.dart';
import '../../features/evaluacion/presentation/pages/sect_3/descripcion_edificacion_page.dart';
import '../../features/evaluacion/presentation/pages/sect_4/riesgos_externos_page.dart';
import '../../features/evaluacion/presentation/pages/sect_5/evaluacion_danos_page.dart';
import '../../features/evaluacion/presentation/pages/sect_6/nivel_dano_page.dart';
import '../../features/evaluacion/presentation/pages/sect_7/habitabilidad_page.dart';
import '../../features/evaluacion/presentation/pages/sect_8/acciones_page.dart';
import '../../features/evaluacion/presentation/pages/resumen_evaluacion_page.dart';

import 'routes.dart';

GoRouter getAppRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/id_evaluacion',
            builder: (context, state) => const EvaluacionWizardPage(),
          ),
          GoRoute(
            path: '/id_edificacion',
            builder: (context, state) => const EdificacionPageWrapper(),
          ),
          GoRoute(
            path: '/descripcion_edificacion',
            builder: (context, state) => const DescripcionEdificacionPage(),
          ),
          GoRoute(
            path: '/riesgos_externos',
            builder: (context, state) => const RiesgosExternosPage(),
          ),
          GoRoute(
            path: '/evaluacion_danos',
            builder: (context, state) => const EvaluacionDanosPage(),
          ),
          GoRoute(
            path: '/nivel_dano',
            builder: (context, state) => const NivelDanoPage(),
          ),
          GoRoute(
            path: '/habitabilidad',
            builder: (context, state) => const HabitabilidadPage(),
          ),
          GoRoute(
            path: '/acciones',
            builder: (context, state) => const AccionesPage(),
          ),
          GoRoute(
            path: '/resumen',
            builder: (context, state) => const ResumenEvaluacionPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final bool isLoginRoute = state.matchedLocation == '/login';

      if (authBloc.state is AuthUnauthenticated && !isLoginRoute) {
        return '/login';
      }

      if (authBloc.state is AuthAuthenticated && isLoginRoute) {
        return '/home';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      context.read<AuthBloc>().stream,
    ),
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