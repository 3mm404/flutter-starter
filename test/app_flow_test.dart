import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_1/app/app.dart';
import 'package:app_1/core/settings/settings_controller.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/features/auth/domain/auth_user.dart';
import 'package:app_1/features/auth/presentation/controllers/session_controller.dart';

import 'support/fakes.dart';

void main() {
  setUpAll(() async {
    for (final lang in ['es', 'en', 'fr', 'pt']) {
      await initializeDateFormatting(lang);
    }
  });
  tearDown(() async {
    Get.reset();
  });

  testWidgets(
    'login validates, blocks duplicates, navigates four tabs and logs out',
    (tester) async {
      final preferences = MemoryPreferences()..values['language'] = 'es';
      final repository = FakeAuthRepository();
      Get.put(SettingsController(preferences), permanent: true);
      Get.put(SessionController(repository), permanent: true);
      await tester.pumpWidget(const DeliApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Este campo es obligatorio.'), findsNWidgets(2));
      await tester.enterText(find.byKey(const Key('login-email')), 'invalid');
      await tester.enterText(
        find.byKey(const Key('login-password')),
        'private',
      );
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Ingresa un correo válido.'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('login-email')),
        'test@example.invalid',
      );
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(repository.logins, 1);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      expect(find.text('Hola, Test Person'), findsOneWidget);
      for (var i = 1; i < 4; i++) {
        await tester.tap(find.byType(NavigationDestination).at(i));
        await tester.pumpAndSettle();
        expect(find.text('Destino provisional'), findsOneWidget);
      }
      await tester.tap(find.byType(NavigationDestination).first);
      await tester.pumpAndSettle();
      expect(find.text('Hola, Test Person'), findsOneWidget);
      await tester.tap(find.byKey(const Key('logout')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login-email')), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(Get.find<SessionController>().signedIn, isFalse);
      expect(Get.key.currentState!.canPop(), isFalse);
    },
  );

  testWidgets(
    'restored Home updates language, theme and palette; preferences survive restart',
    (tester) async {
      tester.view.resetPhysicalSize();
      tester.view.physicalSize = const Size(1000, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final preferences = MemoryPreferences()..values['language'] = 'es';
      final repository = FakeAuthRepository()
        ..saved = const RestoredSession(testUser, confirmed: false);
      final settings = Get.put(
        SettingsController(preferences),
        permanent: true,
      );
      final session = Get.put(SessionController(repository), permanent: true);
      await session.restore();
      await tester.pumpWidget(const DeliApp());
      await tester.pumpAndSettle();
      expect(
        find.text('Sesión local: pendiente de confirmar con el servidor.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('English'));
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(find.text('Hello, Test Person'), findsOneWidget);
      await tester.ensureVisible(find.text('Dark'));
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Forest'));
      await tester.tap(find.text('Forest'));
      await tester.pumpAndSettle();
      expect(settings.mode.value, ThemeMode.dark);
      expect(settings.palette.value, AppPalette.forest);
      expect(
        Theme.of(tester.element(find.byType(NavigationBar))).brightness,
        Brightness.dark,
      );
      final recreatedSettings = SettingsController(preferences);
      expect(recreatedSettings.language.value, 'en');
      expect(recreatedSettings.mode.value, ThemeMode.dark);
      expect(recreatedSettings.palette.value, AppPalette.forest);
      final recreatedSession = SessionController(repository);
      await recreatedSession.restore();
      expect(recreatedSession.user.value?.id, 7);
      await session.logout();
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(preferences.read<String>('language'), 'en');
      expect(preferences.read<String>('theme'), 'dark');
    },
  );
}
