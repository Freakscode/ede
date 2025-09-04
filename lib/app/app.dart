import 'package:caja_herramientas/app/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/auth/presentation/bloc/auth_event.dart';
import 'modules/evaluacion/presentation/bloc/form/evaluacion/evaluacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/nivelDano/nivel_dano_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/habitabilidad/habitabilidad_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/acciones/acciones_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'modules/evaluacion/presentation/bloc/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import 'modules/evaluacion/presentation/bloc/evaluacion_global_bloc.dart';
import '../injection_container.dart' as di;
import 'config/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
        ),
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
            theme: AppTheme.theme,
          );
        },
      ),
    );
  }
}
