/// Clasifica los errores que la interfaz puede presentar al usuario.
enum FailureKind {
  credentials,
  unauthorized,
  validation,
  offline,
  timeout,
  server,
  unexpected,
  storage,
}

/// Representa un fallo de la aplicación sin exponer excepciones internas.
class AppFailure implements Exception {
  const AppFailure(this.kind);
  final FailureKind kind;
  /// Obtiene la clave traducible del mensaje asociado al tipo de error.
  String get translationKey => 'error.${kind.name}';
}
