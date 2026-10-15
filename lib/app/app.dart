import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../core/localization/app_translations.dart';
import '../core/settings/settings_controller.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/controllers/session_controller.dart';
import 'routes.dart';

/// Configura las rutas, traducciones y temas reactivos de toda la aplicación.
class DeliApp extends StatelessWidget {
  const DeliApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final initialRoute = Get.find<SessionController>().signedIn
        ? '/home'
        : '/login';
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Deli',
        theme: AppTheme.build(settings.palette.value, Brightness.light),
        darkTheme: AppTheme.build(settings.palette.value, Brightness.dark),
        themeMode: settings.mode.value,
        locale: Locale(settings.language.value),
        fallbackLocale: const Locale('es'),
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
          Locale('fr'),
          Locale('pt'),
        ],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        translations: AppTranslations(),
        initialRoute: initialRoute,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
