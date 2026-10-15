import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../localization/app_translations.dart';
import '../storage/preferences_store.dart';
import '../theme/app_theme.dart';

/// Restaura y administra el idioma, la apariencia y la paleta del usuario.
class SettingsController extends GetxController {
  /// Carga las preferencias guardadas y aplica valores iniciales válidos.
  SettingsController(this.store) {
    final savedLanguage = store.read<dynamic>('language');
    final deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
    language.value = AppTranslations.languages.contains(savedLanguage)
        ? savedLanguage as String
        : (AppTranslations.languages.contains(deviceLanguage)
              ? deviceLanguage
              : 'es');
    final savedTheme = store.read<dynamic>('theme');
    mode.value = ThemeMode.values.firstWhere(
      (v) => v.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
    final savedPalette = store.read<dynamic>('palette');
    palette.value = AppPalette.values.firstWhere(
      (v) => v.name == savedPalette,
      orElse: () => AppPalette.ocean,
    );
  }
  final PreferencesStore store;
  final language = 'es'.obs;
  final mode = ThemeMode.system.obs;
  final palette = AppPalette.ocean.obs;
  final errorKey = RxnString();
  /// Guarda una preferencia y expone un mensaje si falla el almacenamiento.
  Future<void> _persist(String key, String value) async {
    errorKey.value = null;
    try {
      await store.write(key, value);
    } catch (_) {
      errorKey.value = 'error.storage';
    }
  }

  /// Actualiza el idioma visible y conserva la selección en el dispositivo.
  Future<void> setLanguage(String value) async {
    if (!AppTranslations.languages.contains(value)) return;
    // Actualiza las traducciones mediante la reconstrucción reactiva de DeliApp.
    Get.locale = Locale(value);
    language.value = value;
    await _persist('language', value);
  }

  /// Aplica y guarda el modo claro, oscuro o del sistema.
  Future<void> setMode(ThemeMode value) async {
    mode.value = value;
    await _persist('theme', value.name);
  }

  /// Aplica y guarda la paleta de colores seleccionada.
  Future<void> setPalette(AppPalette value) async {
    palette.value = value;
    await _persist('palette', value.name);
  }
}
