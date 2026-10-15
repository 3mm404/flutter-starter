import 'package:app_1/core/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('Android debug reaches the host instead of emulator localhost', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(AppConfig.normalizedBaseUrl, 'http://10.0.2.2:8000/api/v1/');
  });

  test('Windows development keeps host localhost', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(AppConfig.normalizedBaseUrl, 'http://localhost:8000/api/v1/');
  });
}
