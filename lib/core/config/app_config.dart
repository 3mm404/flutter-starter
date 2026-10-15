import 'package:flutter/foundation.dart';

/// Centraliza la dirección del backend según el entorno de ejecución.
abstract final class AppConfig {
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Prioriza la URL configurada; en Android debug usa la dirección del equipo anfitrión.
  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
    if (kDebugMode &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1/';
    }
    return 'http://localhost:8000/api/v1/';
  }

  /// Valida la URL y asegura la barra final para construir los endpoints.
  static String get normalizedBaseUrl {
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw StateError('API_BASE_URL must be an absolute HTTP(S) base URL.');
    }
    return apiBaseUrl.endsWith('/') ? apiBaseUrl : '$apiBaseUrl/';
  }
}
