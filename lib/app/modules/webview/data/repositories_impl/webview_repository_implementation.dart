import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';
import 'package:caja_herramientas/app/modules/webview/domain/repositories/webview_repository_interface.dart';

/// Implementación del repositorio de WebView
class WebViewRepositoryImplementation implements WebViewRepositoryInterface {
  @override
  Future<WebViewEntity> getWebViewConfig(String webViewType) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 100));
    
    switch (webViewType) {
      case 'sirmed_portal':
        return WebViewEntity.sirmedPortal();
      default:
        throw Exception('Tipo de WebView no soportado: $webViewType');
    }
  }
}
