import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';

/// Interfaz del repositorio de WebView
/// Define los contratos para el manejo de WebViews
abstract class WebViewRepositoryInterface {
  /// Obtener configuración de WebView por tipo
  Future<WebViewEntity> getWebViewConfig(String webViewType);
  
  /// Verificar si una URL está permitida
  bool isUrlAllowed(String url, List<String> allowedDomains);
  
  /// Obtener lista de dominios permitidos por defecto
  List<String> getDefaultAllowedDomains();
}
