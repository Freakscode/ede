import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import '../../blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';

class EvalWrapper extends StatelessWidget {
  final Widget child;

  const EvalWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EvaluacionBloc>(
          create: (context) => EvaluacionBloc(),
        ),
        BlocProvider<EdificacionBloc>(
          create: (context) => EdificacionBloc(),
        ),
      ],
      child: child,
    );
  }
} 