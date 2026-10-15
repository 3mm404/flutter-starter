# Validación de la base Flutter

## Resultado del código Dart

- Modelos Freezed y JSON generados con build_runner, sin editar manualmente sus archivos generados.
- dart format lib test completado.
- flutter analyze: sin problemas.
- flutter test: 25 pruebas aprobadas.

Cobertura funcional:
- Composición de LoginResponseModel con UserModel, fechas, campos opcionales, igualdad y copyWith.
- Request con email/password únicamente y rechazo de respuestas incompletas.
- Claves y parámetros de las cuatro traducciones.
- Login, token separado de la caché y restauración mediante el contrato real de profile.
- Sesión sin red pendiente de confirmación; limpieza ante 401 autenticado sin perder preferencias.
- Errores de credenciales, red, timeout y servidor.
- Validación del formulario, bloqueo de envíos duplicados, navegación por los cuatro destinos y logout sin volver a Home con Atrás.
- Cambio de idioma, tema y paleta, y persistencia al recrear controladores.

## Backend real

Se probaron POST /api/v1/login y GET /api/v1/profile contra localhost:8000 con las credenciales de desarrollo del usuario. Ambas respuestas fueron correctas. El token de prueba se revocó mediante POST /api/v1/logout y no se guardó en archivos.

Esta comprobación valida disponibilidad y contrato HTTP; no representa una prueba completa desde un dispositivo Android.

## Android

El NDK 28.2.13676358 y Android SDK Platform 36 ya están instalados. El proyecto fija esa versión NDK.

Los primeros intentos de APK encontraron conflictos de archivos y cachés Kotlin mientras se modificaba el mismo directorio build. Tras limpiar y repetir sin otra ejecución Gradle activa, flutter build apk --debug terminó correctamente. APK generado: build/app/outputs/flutter-apk/app-debug.apk. La URL incluida en este APK de desarrollo es http://10.0.2.2:8000/api/v1/. No se instaló ni se ejecutó el APK en el emulador durante esta validación.

## Pendiente de comprobar en dispositivos

Los tests usan adaptadores HTTP y almacenamiento en memoria. Falta verificar la persistencia real de Keychain/Keystore/Windows tras terminar y reabrir el proceso de la app, así como una sesión UI completa contra el backend en el dispositivo. iOS no se compila en Windows.

Para Android selecciona la configuración Deli · Android emulator en VS Code o ejecuta:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1/
```

Para leer los modelos sin archivos generados desplegados, consulta [MODELOS.md](MODELOS.md).

## Conectividad Android

Se verificó HTTP 200 en /up desde el emulador usando 10.0.2.2:8000. La configuración de Android debug ahora usa esa dirección por defecto cuando no se proporciona API_BASE_URL. Tras modificar esta configuración realiza Hot Restart o detén y vuelve a ejecutar la app; Hot Reload conserva el cliente Dio inicializado.

## Paletas y contraste

Se modernizaron las tres paletas existentes y se añadieron violeta y coral sin cambiar los identificadores ya persistidos. Diez pruebas verifican las cinco paletas en modo claro y oscuro, con contraste mínimo 4.5:1 entre los pares de texto y fondo comprobados: contenido, tarjetas, botones, contenedores de selección, extremos del degradado de Home, errores y estados de sesión. El análisis estático y las 25 pruebas finalizaron correctamente. Para cargar los nuevos valores de paleta realiza Hot Restart.
