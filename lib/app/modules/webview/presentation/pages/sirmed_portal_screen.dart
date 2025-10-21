import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/modules/webview/presentation/bloc/webview_bloc.dart';
import 'package:caja_herramientas/app/modules/webview/domain/usecases/get_webview_config_usecase.dart';
import 'package:caja_herramientas/app/modules/webview/data/repositories_impl/webview_repository_implementation.dart';
import 'package:caja_herramientas/app/modules/webview/presentation/pages/webview_screen.dart';

/// Pantalla del portal SIRMED con Clean Architecture
class SirmedPortalScreen extends StatelessWidget {
  const SirmedPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewBloc(
        getWebViewConfigUseCase: GetWebViewConfigUseCase(
          WebViewRepositoryImplementation(),
        ),
      )..loadSirmedPortalConfig(),
      child: const WebViewScreen(webViewType: 'sirmed_portal'),
    );
  }
}