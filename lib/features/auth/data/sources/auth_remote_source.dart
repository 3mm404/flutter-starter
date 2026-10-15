import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_failure.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

/// Realiza las llamadas de autenticación y adapta el contrato JSON del backend.
class AuthRemoteSource {
  AuthRemoteSource(this.client);
  final ApiClient client;
  /// Envía las credenciales y valida que la respuesta incluya usuario y token.
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final json = await client.request(
      'login',
      method: 'POST',
      data: request.toJson(),
    );
    if (json['status'] != true) throw const AppFailure(FailureKind.credentials);
    try {
      final result = LoginResponseModel.fromJson(json);
      if (result.token.trim().isEmpty) throw const FormatException();
      return result;
    } catch (_) {
      throw const AppFailure(FailureKind.unexpected);
    }
  }

  /// Consulta el perfil autenticado y adapta el rol singular a la lista de roles.
  Future<UserModel> profile({List<String> fallbackRoles = const []}) async {
    final json = await client.request('profile', authenticated: true);
    try {
      final user = Map<String, dynamic>.from(json['data'] as Map);
      // El perfil devuelve un rol singular y el login devuelve una lista de roles.
      user['roles'] ??= user['role'] is String ? [user['role']] : fallbackRoles;
      return UserModel.fromJson(user);
    } catch (_) {
      throw const AppFailure(FailureKind.unexpected);
    }
  }
}
