import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';

class EvalWrapper extends StatelessWidget {
  final Widget child;

  const EvalWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EdificacionBloc>(
      create: (context) => EdificacionBloc(),
      child: child,
    );
  }
} 