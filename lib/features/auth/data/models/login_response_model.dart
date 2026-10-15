import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';
part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Respuesta exitosa de POST /login. Contiene un UserModel y el token de sesión.
/// Edita este archivo y regenera sus partes con dart run build_runner build.
@Freezed(toStringOverride: false)
abstract class LoginResponseModel with _$LoginResponseModel {
  /// Agrupa el resultado exitoso del login, su usuario y el token recibido.
  const factory LoginResponseModel({
    required bool status,
    required String message,
    required UserModel user,
    required String token,
  }) = _LoginResponseModel;
  /// Convierte la respuesta JSON exitosa, incluido el usuario anidado.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
