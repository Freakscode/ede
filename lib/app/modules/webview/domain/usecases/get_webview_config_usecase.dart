import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';
import 'package:caja_herramientas/app/modules/webview/domain/repositories/webview_repository_interface.dart';

/// Caso de uso para obtener configuración de WebView
class GetWebViewConfigUseCase {
  final WebViewRepositoryInterface _repository;

  GetWebViewConfigUseCase(this._repository);

  /// Ejecutar el caso de uso para obtener configuración
  Future<WebViewEntity> execute(String webViewType) async {
    return await _repository.getWebViewConfig(webViewType);
  }

  /// Obtener configuración del portal SIRMED
  Future<WebViewEntity> getSirmedPortalConfig() async {
    return await execute('sirmed_portal');
  }
}
