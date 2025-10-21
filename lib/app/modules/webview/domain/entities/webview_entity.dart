import 'package:equatable/equatable.dart';

/// Entidad que representa la configuración de una WebView
class WebViewEntity extends Equatable {
  final String url;
  final String title;
  final bool enableJavaScript;
  final bool allowExternalNavigation;
  final List<String> allowedDomains;
  final bool useInAppBrowser;

  const WebViewEntity({
    required this.url,
    required this.title,
    this.enableJavaScript = true,
    this.allowExternalNavigation = false,
    this.allowedDomains = const [],
    this.useInAppBrowser = true,
  });

  /// Factory constructor para crear entidad del portal SIRMED
  factory WebViewEntity.sirmedPortal() {
    return const WebViewEntity(
      url: 'https://www.medellin.gov.co/sirmed',
      title: 'Portal SIRMED',
      enableJavaScript: true,
      allowExternalNavigation: false,
      allowedDomains: ['medellin.gov.co'],
      useInAppBrowser: true,
    );
  }

  /// Verificar si una URL está permitida
  bool isUrlAllowed(String url) {
    if (allowExternalNavigation) return true;
    
    return allowedDomains.any((domain) => url.contains(domain));
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
