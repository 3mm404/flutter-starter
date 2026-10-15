import '../../../../core/network/app_failure.dart';
import '../../../../core/storage/preferences_store.dart';
import '../../../../core/storage/token_store.dart';
import '../../domain/auth_repository.dart';
import '../../domain/auth_user.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';
import '../sources/auth_remote_source.dart';

/// Coordina la API, el token seguro y la caché local para gestionar la sesión.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this.remote, this.tokens, this.preferences);
  final AuthRemoteSource remote;
  final TokenStore tokens;
  final PreferencesStore preferences;
  static const userKey = 'cached_user';

  @override
  /// Autentica, guarda el token separado del perfil y devuelve la entidad de usuario.
  Future<AuthUser> login(String email, String password) async {
    final result = await remote.login(
      LoginRequestModel(email: email, password: password),
    );
    try {
      await tokens.write(result.token);
      await preferences.write(userKey, result.user.toJson());
    } catch (_) {
      await clear();
      throw const AppFailure(FailureKind.storage);
    }
    return result.user.toEntity();
  }

  @override
  /// Valida la sesión guardada o conserva la caché como pendiente si el servidor falla.
  Future<RestoredSession?> restore() async {
    UserModel? cached;
    try {
      final token = await tokens.read();
      if (token == null || token.isEmpty) {
        await preferences.remove(userKey);
        return null;
      }
      final json = preferences.read<dynamic>(userKey);
      if (json is Map) {
        try {
          cached = UserModel.fromJson(Map<String, dynamic>.from(json));
        } catch (_) {
          await preferences.remove(userKey);
        }
      }
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
    try {
      final user = await remote.profile(fallbackRoles: cached?.roles ?? []);
      await preferences.write(userKey, user.toJson());
      return RestoredSession(user.toEntity(), confirmed: true);
    } on AppFailure catch (error) {
      if (error.kind == FailureKind.unauthorized) {
        await clear();
        return null;
      }
      if (cached != null) {
        return RestoredSession(cached.toEntity(), confirmed: false);
      }
      // Conserva el token para reintentar sin dar la sesión por confirmada.
      rethrow;
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }

  @override
  /// Elimina token y perfil local conservando las preferencias de la aplicación.
  Future<void> clear() async {
    try {
      await tokens.clear();
    } finally {
      await preferences.remove(userKey);
    }
  }
}
