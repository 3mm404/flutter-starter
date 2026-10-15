import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// Cuerpo enviado a POST /login: solamente correo y contraseña.
/// Edita este archivo y regenera sus partes con dart run build_runner build.
@Freezed(toStringOverride: false)
abstract class LoginRequestModel with _$LoginRequestModel {
  /// Declara las credenciales que se envían al endpoint de login.
  const factory LoginRequestModel({
    required String email,
    required String password,
  }) = _LoginRequestModel;
  /// Convierte un objeto JSON de credenciales en el modelo de solicitud.
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}
