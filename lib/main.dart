import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/settings/settings_controller.dart';
import 'core/storage/preferences_store.dart';
import 'core/storage/token_store.dart';
import 'features/auth/data/repositories/api_auth_repository.dart';
import 'features/auth/data/sources/auth_remote_source.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/controllers/session_controller.dart';

/// Inicializa servicios, preferencias y sesión antes de mostrar la aplicación.
Future<void> main() async {
  /// Prepara los plugins nativos y el almacenamiento local.
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  for (final language in ['es', 'en', 'fr', 'pt']) {
    await initializeDateFormatting(language);
  }
  /// Registra el almacenamiento de preferencias y el almacén seguro del token.
  final preferences = Get.put<PreferencesStore>(
    LocalPreferences(GetStorage()),
    permanent: true,
  );
  final tokens = Get.put<TokenStore>(
    const SecureTokenStore(FlutterSecureStorage()),
    permanent: true,
  );
  Get.put(SettingsController(preferences), permanent: true);
  /// Configura Dio con la URL de la API, encabezados y tiempos de espera.
  final client = Get.put(
    ApiClient(
      Dio(
        BaseOptions(
          baseUrl: AppConfig.normalizedBaseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 12),
          sendTimeout: const Duration(seconds: 8),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ),
      tokens,
    ),
    permanent: true,
  );
  /// Conecta los datos de autenticación con el estado global de sesión.
  final repository = Get.put<AuthRepository>(
    ApiAuthRepository(AuthRemoteSource(client), tokens, preferences),
    permanent: true,
  );
  final session = Get.put(SessionController(repository), permanent: true);
  client.onUnauthorized = () => session.logout(expired: true);
  /// Recupera la sesión guardada antes de decidir la pantalla inicial.
  await session.restore();
  runApp(const DeliApp());
}
