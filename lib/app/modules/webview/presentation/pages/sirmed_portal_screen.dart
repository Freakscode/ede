import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/layouts/custom_app_bar.dart';
import 'package:caja_herramientas/app/modules/webview/presentation/bloc/webview_bloc.dart';
import 'package:caja_herramientas/app/modules/webview/domain/usecases/get_webview_config_usecase.dart';
import 'package:caja_herramientas/app/modules/webview/data/repositories_impl/webview_repository_implementation.dart';

/// Pantalla del portal SIRMED con Clean Architecture
class SirmedPortalScreen extends StatefulWidget {
  const SirmedPortalScreen({super.key});

  @override
  State<SirmedPortalScreen> createState() => _SirmedPortalScreenState();
}

class _SirmedPortalScreenState extends State<SirmedPortalScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = error.description.isNotEmpty 
                    ? error.description 
                    : 'Error al cargar la página';
              });
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains('medellin.gov.co')) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
          ),
        );
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error al inicializar WebView: $e';
      });
    }
  }

  void _loadUrl(String url) {
    if (_hasError) {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }
    _controller.loadRequest(Uri.parse(url));
  }

  void _refreshWebView() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _controller.reload();
  }

  void _goBack() {
    _controller.goBack();
  }

  void _goForward() {
    _controller.goForward();
  }

  void _goHome(String url) {
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewBloc(
        getWebViewConfigUseCase: GetWebViewConfigUseCase(
          WebViewRepositoryImplementation(),
        ),
      )..loadSirmedPortalConfig(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          showBack: true,
          onBack: () => context.go('/home'),
          showInfo: true,
          showProfile: true,
          onProfile: () {},
          onInfo: () {},
        ),
        body: BlocListener<WebViewBloc, WebViewState>(
          listener: (context, state) {
            if (state is WebViewLoaded) {
              _loadUrl(state.config.url);
            }
          },
          child: BlocBuilder<WebViewBloc, WebViewState>(
            builder: (context, state) {
              if (state is WebViewLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.azulDAGRD),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando configuración...',
                        style: TextStyle(
                          color: ThemeColors.azulDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is WebViewError) {
                return _buildErrorWidget(state.message);
              } else if (state is WebViewLoaded) {
                return _buildWebViewContent(state.config);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWebViewContent(dynamic config) {
    return Column(
      children: [
        // Barra de navegación
        Container(
          height: 48,
          color: ThemeColors.azulDAGRD.withOpacity(0.1),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _goBack();
                  }
                },
                tooltip: 'Atrás',
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _goForward();
                  }
                },
                tooltip: 'Adelante',
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.home, size: 20),
                onPressed: () => _goHome(config.url),
                tooltip: 'Inicio',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: _refreshWebView,
                tooltip: 'Recargar',
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.azulDAGRD),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        
        // Contenido WebView
        Expanded(
          child: _hasError
              ? _buildErrorWidget(_errorMessage)
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.azulDAGRD),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando portal SIRMED...',
                              style: TextStyle(
                                color: ThemeColors.azulDAGRD,
                                fontFamily: 'Work Sans',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
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
              message,
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
                backgroundColor: ThemeColors.azulDAGRD,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}