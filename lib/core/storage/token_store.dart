import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Define el acceso al token sin depender de un plugin concreto.
abstract interface class TokenStore {
  /// Recupera el token guardado, si existe.
  Future<String?> read();
  /// Guarda el token recibido al iniciar sesión.
  Future<void> write(String token);
  /// Elimina el token local al cerrar o invalidar la sesión.
  Future<void> clear();
}

/// Conserva el token en el almacenamiento seguro de la plataforma.
class SecureTokenStore implements TokenStore {
  const SecureTokenStore(this.storage);
  final FlutterSecureStorage storage;
  static const _key = 'session_token';
  @override
  /// Recupera el token guardado, si existe.
  Future<String?> read() => storage.read(key: _key);
  @override
  /// Guarda el token recibido al iniciar sesión.
  Future<void> write(String token) => storage.write(key: _key, value: token);
  @override
  /// Elimina el token local al cerrar o invalidar la sesión.
  Future<void> clear() => storage.delete(key: _key);
}
