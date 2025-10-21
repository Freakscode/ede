import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/webview/presentation/bloc/webview_bloc.dart';
import 'package:caja_herramientas/app/modules/webview/presentation/widgets/webview_widget.dart';

/// Pantalla WebView genérica que puede mostrar cualquier URL configurada
class WebViewScreen extends StatelessWidget {
  final String webViewType;

  const WebViewScreen({super.key, required this.webViewType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBack: true,
        onBack: () {},
        showInfo: true,
        showProfile: true,
        onProfile: () {},
        onInfo: () {},
      ),

      body: BlocBuilder<WebViewBloc, WebViewState>(
        builder: (context, state) {
          if (state is WebViewLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      DAGRDColors.azulDAGRD,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando configuración...',
                    style: TextStyle(
                      color: DAGRDColors.azulDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WebViewLoaded) {
            return WebViewWidget(config: state.config);
          } else if (state is WebViewError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Error al cargar el portal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontFamily: 'Work Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Work Sans',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<WebViewBloc>().loadSirmedPortalConfig();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DAGRDColors.azulDAGRD,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
