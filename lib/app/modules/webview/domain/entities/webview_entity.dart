/// Entidad simple para configuración de WebView
class WebViewEntity {
  final String url;
  final String title;
  final List<String> allowedDomains;

  const WebViewEntity({
    required this.url,
    required this.title,
    this.allowedDomains = const [],
  });

  /// Factory constructor para crear entidad del portal SIRMED
  factory WebViewEntity.sirmedPortal() {
    return const WebViewEntity(
      url: 'https://www.medellin.gov.co/sirmed',
      title: 'Portal SIRMED',
      allowedDomains: ['medellin.gov.co'],
    );
  }

  /// Verificar si una URL está permitida
  bool isUrlAllowed(String url) {
    return allowedDomains.any((domain) => url.contains(domain));
  }
}