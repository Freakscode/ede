import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/blocs/form/evaluacion/evaluacion_bloc.dart' as form;
import 'presentation/blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import 'presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import 'presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import 'presentation/blocs/form/acciones/acciones_bloc.dart';
import 'presentation/blocs/evaluacion_global/evaluacion_global_bloc.dart';
import 'presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import 'config/router/router_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/evaluacion_repository.dart';
import 'core/providers.dart';
import 'config/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final EvaluacionRepository evaluacionRepository;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.evaluacionRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: evaluacionRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          ...getGlobalProviders(evaluacionRepository, authRepository),
          BlocProvider<form.EvaluacionBloc>(
            create: (context) => form.EvaluacionBloc(repository: evaluacionRepository),
          ),
          BlocProvider<EdificacionBloc>(
            create: (context) => EdificacionBloc(),
          ),
          BlocProvider<DescripcionEdificacionBloc>(
            create: (context) => DescripcionEdificacionBloc(),
          ),
          BlocProvider<RiesgosExternosBloc>(
            create: (context) => RiesgosExternosBloc(),
          ),
          BlocProvider<EvaluacionDanosBloc>(
            create: (context) => EvaluacionDanosBloc(),
          ),
          BlocProvider<NivelDanoBloc>(
            create: (context) => NivelDanoBloc(),
          ),
          BlocProvider<HabitabilidadBloc>(
            create: (context) => HabitabilidadBloc(),
          ),
          BlocProvider<AccionesBloc>(
            create: (context) => AccionesBloc(),
          ),
          BlocProvider<EvaluacionGlobalBloc>(
            create: (context) => EvaluacionGlobalBloc(
              evaluacionBloc: context.read<form.EvaluacionBloc>(),
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
          builder: (context) => MaterialApp.router(
            title: 'EDE App',
            theme: AppTheme.theme,
            routerConfig: getAppRouter(context),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
