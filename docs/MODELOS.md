# Cómo leer los modelos

Solo editas tres archivos:

| Archivo | Representa | Campos principales |
| --- | --- | --- |
| login_request_model.dart | Lo que envía la aplicación al iniciar sesión | email, password |
| login_response_model.dart | Lo que devuelve el backend en un login exitoso | status, message, user, token |
| user_model.dart | Los datos del usuario | id, name, email, phoneNumber, dateOfBirth, roles |

La relación es composición: LoginResponseModel tiene un UserModel. La contraseña solo pertenece al request; el token solo a la respuesta y al servicio de sesión. El perfil no contiene el token.

## Archivos generados

- .freezed.dart: implementación inmutable, copyWith y comparación por valores.
- .g.dart: conversión entre JSON y el modelo, incluidos nombres como phone_number.
- No debes leerlos para usar el modelo ni editarlos manualmente.
- La configuración de .vscode/settings.json los agrupa debajo del archivo fuente en el Explorador. Abre app_1 como carpeta o raíz del workspace para aplicar estos ajustes.

Vista esperada:

```text
models/
  > login_request_model.dart
  > login_response_model.dart
  > user_model.dart
```

Al desplegar una flecha puedes ver sus dos archivos generados. Esta agrupación no elimina ni mueve archivos.

## Ejemplo de uso

```dart
final request = LoginRequestModel(email: email, password: password);
final body = request.toJson();

final response = LoginResponseModel.fromJson(json);
final user = response.user;
final renamed = user.copyWith(name: 'Nuevo nombre');
```

Los controladores trabajan con AuthUser, la entidad del dominio. Los modelos y su conversión JSON se usan en la capa de datos.

## Qué significan las anotaciones

- @freezed: genera la implementación inmutable a partir de los campos declarados.
- @JsonKey(name: 'phone_number'): el JSON usa phone_number y Dart usa phoneNumber.
- @Default([]): roles toma una lista vacía si el backend no lo proporciona.
- toStringOverride: false evita que Freezed genere una representación que incluya la contraseña o el token.

Después de agregar o cambiar un campo:

```powershell
dart run build_runner build
```

Freezed y json_serializable forman parte de la especificación solicitada. Si más adelante se decide usar clases Dart manuales, habrá que sustituir también la serialización, copyWith y la comparación; ocultar los archivos generados no cambia esa decisión de arquitectura.

[Configuración de agrupación de VS Code](https://code.visualstudio.com/updates/v1_67#_explorer-file-nesting).
