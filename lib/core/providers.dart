// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../data/repositories/evaluacion_repository.dart';
// import '../data/repositories/auth_repository.dart';
// import '../presentation/blocs/auth/auth_bloc.dart';
// import '../presentation/blocs/form/evaluacion/evaluacion_bloc.dart';
// import '../presentation/blocs/form/identificacionEdificacion/id_edificacion_bloc.dart';
// import '../presentation/blocs/form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
// import '../presentation/blocs/form/riesgosExternos/riesgos_externos_bloc.dart';
// import '../presentation/blocs/form/evaluacionDanos/evaluacion_danos_bloc.dart';
// import '../presentation/blocs/form/nivelDano/nivel_dano_bloc.dart';
// import '../presentation/blocs/form/habitabilidad/habitabilidad_bloc.dart';
// import '../presentation/blocs/form/acciones/acciones_bloc.dart';

// List<BlocProvider> getGlobalProviders(EvaluacionRepository evaluacionRepository, AuthRepository authRepository) {
//   return [
//     BlocProvider<AuthBloc>(
//       create: (context) => AuthBloc(authRepository: authRepository),
//     ),
//     BlocProvider<EvaluacionBloc>(
//       create: (context) => EvaluacionBloc(repository: evaluacionRepository),
//     ),
//     BlocProvider<EdificacionBloc>(
//       create: (context) => EdificacionBloc(),
//     ),
//     BlocProvider<DescripcionEdificacionBloc>(
//       create: (context) => DescripcionEdificacionBloc(),
//     ),
//     BlocProvider<RiesgosExternosBloc>(
//       create: (context) => RiesgosExternosBloc(),
//     ),
//     BlocProvider<EvaluacionDanosBloc>(
//       create: (context) => EvaluacionDanosBloc(),
//     ),
//     BlocProvider<NivelDanoBloc>(
//       create: (context) => NivelDanoBloc(),
//     ),
//     BlocProvider<HabitabilidadBloc>(
//       create: (context) => HabitabilidadBloc(),
//     ),
//     BlocProvider<AccionesBloc>(
//       create: (context) => AccionesBloc(),
//     ),
//   ];
// } 