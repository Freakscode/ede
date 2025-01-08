import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../presentation/blocs/form/identificacionEvaluacion/id_evaluacion_bloc.dart';
import '../presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import '../presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
import '../presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
import '../presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
import '../presentation/blocs/form/acciones/acciones_bloc.dart';

final List<BlocProvider> globalProviders = [
  BlocProvider<EdificacionBloc>(
    create: (context) => EdificacionBloc(),
  ),
  BlocProvider<EvaluacionBloc>(
    create: (context) => EvaluacionBloc(),
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
]; 