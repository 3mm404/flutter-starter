import 'auth_user.dart';

/// Define las operaciones de autenticación que utilizan los controladores.
abstract interface class AuthRepository {
  /// Inicia sesión y devuelve los datos del usuario autenticado.
  Future<AuthUser> login(String email, String password);
  /// Recupera una sesión persistida y su estado de confirmación.
  Future<RestoredSession?> restore();
  /// Elimina los datos locales asociados a la sesión.
  Future<void> clear();
}
