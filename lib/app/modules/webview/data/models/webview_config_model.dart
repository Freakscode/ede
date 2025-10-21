import 'package:equatable/equatable.dart';
import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';

/// Modelo de datos para la configuración de WebView
class WebViewConfigModel extends Equatable {
  final String url;
  final String title;
  final bool enableJavaScript;
  final bool allowExternalNavigation;
  final List<String> allowedDomains;
  final bool useInAppBrowser;

  const WebViewConfigModel({
    required this.url,
    required this.title,
    this.enableJavaScript = true,
    this.allowExternalNavigation = false,
    this.allowedDomains = const [],
    this.useInAppBrowser = true,
  });

  /// Factory constructor desde JSON
  factory WebViewConfigModel.fromJson(Map<String, dynamic> json) {
    return WebViewConfigModel(
      url: json['url'] as String,
      title: json['title'] as String,
      enableJavaScript: json['enableJavaScript'] as bool? ?? true,
      allowExternalNavigation: json['allowExternalNavigation'] as bool? ?? false,
      allowedDomains: (json['allowedDomains'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      useInAppBrowser: json['useInAppBrowser'] as bool? ?? true,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'enableJavaScript': enableJavaScript,
      'allowExternalNavigation': allowExternalNavigation,
      'allowedDomains': allowedDomains,
      'useInAppBrowser': useInAppBrowser,
    };
  }

  /// Convertir a entidad de dominio
  WebViewEntity toEntity() {
    return WebViewEntity(
      url: url,
      title: title,
      enableJavaScript: enableJavaScript,
      allowExternalNavigation: allowExternalNavigation,
      allowedDomains: allowedDomains,
      useInAppBrowser: useInAppBrowser,
    );
  }

  /// Factory constructor desde entidad
  factory WebViewConfigModel.fromEntity(WebViewEntity entity) {
    return WebViewConfigModel(
      url: entity.url,
      title: entity.title,
      enableJavaScript: entity.enableJavaScript,
      allowExternalNavigation: entity.allowExternalNavigation,
      allowedDomains: entity.allowedDomains,
      useInAppBrowser: entity.useInAppBrowser,
    );
  }

  @override
  List<Object?> get props => [
        url,
        title,
        enableJavaScript,
        allowExternalNavigation,
        allowedDomains,
        useInAppBrowser,
      ];
}
