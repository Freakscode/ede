import 'package:caja_herramientas/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'modules/evaluacion/presentation/bloc/form/evaluacion/evaluacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/nivelDano/nivel_dano_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/habitabilidad/habitabilidad_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/acciones/acciones_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/evaluacion_global_bloc.dart';
import 'modules/risk_threat_analysis/bloc/risk_threat_analysis_bloc.dart';
import 'modules/home/bloc/home_bloc.dart';
import 'modules/home/bloc/home_event.dart';
import 'modules/auth/bloc/auth_bloc.dart';
import 'modules/auth/services/auth_service.dart';
import 'modules/data_registration/bloc/data_registration_bloc.dart';
import '../injection_container.dart' as di;
import 'config/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
       
        // Evaluacion BLoCs
        BlocProvider<EvaluacionBloc>(
          create: (context) => di.sl<EvaluacionBloc>(),
        ),
        BlocProvider<EdificacionBloc>(
          create: (context) => di.sl<EdificacionBloc>(),
        ),
        BlocProvider<RiesgosExternosBloc>(
          create: (context) => di.sl<RiesgosExternosBloc>(),
        ),
        BlocProvider<NivelDanoBloc>(
          create: (context) => di.sl<NivelDanoBloc>(),
        ),
        BlocProvider<HabitabilidadBloc>(
          create: (context) => di.sl<HabitabilidadBloc>(),
        ),
        BlocProvider<AccionesBloc>(
          create: (context) => di.sl<AccionesBloc>(),
        ),
        BlocProvider<EvaluacionDanosBloc>(
          create: (context) => di.sl<EvaluacionDanosBloc>(),
        ),
        BlocProvider<DescripcionEdificacionBloc>(
          create: (context) => di.sl<DescripcionEdificacionBloc>(),
        ),
        // Risk Threat Analysis BLoC
        BlocProvider<RiskThreatAnalysisBloc>(
          create: (context) => di.sl<RiskThreatAnalysisBloc>(),
        ),
        // Home BLoC
        BlocProvider<HomeBloc>(
          create: (context) => di.sl<HomeBloc>()..add(HomeCheckAndShowTutorial()),
        ),
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: AuthService()),
        ),
        // Data Registration BLoC (unified)
        BlocProvider<DataRegistrationBloc>(
          create: (context) => DataRegistrationBloc(),
        ),
        // EvaluacionGlobalBloc must be last as it depends on all other evaluacion BLoCs
        BlocProvider<EvaluacionGlobalBloc>(
          create: (context) => EvaluacionGlobalBloc(
            evaluacionBloc: context.read<EvaluacionBloc>(),
            idEdificacionBloc: context.read<EdificacionBloc>(),
            riesgosExternosBloc: context.read<RiesgosExternosBloc>(),
            evaluacionDanosBloc: context.read<EvaluacionDanosBloc>(),
            nivelDanoBloc: context.read<NivelDanoBloc>(),
            habitabilidadBloc: context.read<HabitabilidadBloc>(),
            accionesBloc: context.read<AccionesBloc>(),
            descripcionEdificacionBloc: context.read<DescripcionEdificacionBloc>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: AppConstants.appName,
            routerConfig: getAppRouter(context),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme.copyWith(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: _FadePageTransitionsBuilder(),
                  TargetPlatform.iOS: _FadePageTransitionsBuilder(),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Transición personalizada de fade suave
class _FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(
        Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      ),
      child: child,
    );
  }
}
