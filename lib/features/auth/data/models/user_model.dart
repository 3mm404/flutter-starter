import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth_user.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Datos del usuario recibidos de la API. No contiene token ni contraseña.
/// Edita este archivo y regenera sus partes con dart run build_runner build.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();
  /// Declara los campos del usuario y su correspondencia con el JSON del backend.
  const factory UserModel({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    @Default([]) List<String> roles,
  }) = _UserModel;
  /// Construye el modelo a partir de los datos JSON de la API o de la caché.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  /// Entrega al dominio los datos del usuario sin detalles de serialización.
  AuthUser toEntity() => AuthUser(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
    roles: roles,
  );
}
