import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';

/// Widget WebView genérico y reutilizable
class WebViewWidget extends StatefulWidget {
  final WebViewEntity config;
  final VoidCallback? onNavigationRequest;

  const WebViewWidget({
    super.key,
    required this.config,
    this.onNavigationRequest,
  });

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late final webview_flutter.WebViewController _controller;
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
      _controller = webview_flutter.WebViewController()
        ..setJavaScriptMode(
          widget.config.enableJavaScript 
              ? webview_flutter.JavaScriptMode.unrestricted 
              : webview_flutter.JavaScriptMode.disabled,
        )
        ..setNavigationDelegate(
          webview_flutter.NavigationDelegate(
            onProgress: (int progress) {
              // Actualizar progreso de carga si es necesario
            },
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
            onWebResourceError: (webview_flutter.WebResourceError error) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = error.description.isNotEmpty 
                    ? error.description 
                    : 'Error al cargar la página';
              });
            },
            onNavigationRequest: (webview_flutter.NavigationRequest request) {
              if (widget.config.isUrlAllowed(request.url)) {
                return webview_flutter.NavigationDecision.navigate;
              }
              // Para enlaces externos, prevenir navegación
              return webview_flutter.NavigationDecision.prevent;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.config.url));
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error al inicializar WebView: $e';
      });
    }
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

  void _goHome() {
    _controller.loadRequest(Uri.parse(widget.config.url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de navegación
        Container(
          height: 48,
          color: DAGRDColors.azulDAGRD.withOpacity(0.1),
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
                onPressed: _goHome,
                tooltip: 'Inicio',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: _refreshWebView,
                tooltip: 'Recargar',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        
        // Contenido WebView
        Expanded(
          child: _hasError
              ? _buildErrorWidget()
              : Stack(
                  children: [
                        webview_flutter.WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(DAGRDColors.azulDAGRD),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando...',
                              style: TextStyle(
                                color: DAGRDColors.azulDAGRD,
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

  Widget _buildErrorWidget() {
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
              'Error al cargar el contenido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontFamily: 'Work Sans',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Work Sans',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshWebView,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DAGRDColors.azulDAGRD,
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
