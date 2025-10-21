import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';

/// Interfaz del repositorio de WebView
abstract class WebViewRepositoryInterface {
  /// Obtener configuración de WebView por tipo
  Future<WebViewEntity> getWebViewConfig(String webViewType);
}
