import 'package:flutter_test/flutter_test.dart';
import 'package:app_1/features/auth/data/models/login_request_model.dart';
import 'package:app_1/features/auth/data/models/login_response_model.dart';
import 'package:app_1/features/auth/data/models/user_model.dart';
import 'package:app_1/core/localization/app_translations.dart';

void main() {
  test('nested user, optional fields, dates, equality and copyWith', () {
    final response = LoginResponseModel.fromJson({
      'status': true,
      'message': 'ok',
      'token': 'test-token',
      'user': {
        'id': 7,
        'name': 'Test',
        'email': 'test@example.invalid',
        'phone_number': null,
        'date_of_birth': '2003-08-24',
        'roles': ['client'],
      },
    });
    expect(response.user.dateOfBirth, DateTime(2003, 8, 24));
    expect(response.user.phoneNumber, isNull);
    expect(response.toJson()['user'], isA<Map<String, dynamic>>());
    expect(LoginResponseModel.fromJson(response.toJson()), response);
    expect(
      response
          .copyWith(user: response.user.copyWith(name: 'Changed'))
          .user
          .name,
      'Changed',
    );
    expect(response.toString(), isNot(contains('test-token')));
    expect(
      const LoginRequestModel(
        email: 'test@example.invalid',
        password: 'private',
      ).toString(),
      isNot(contains('private')),
    );
    final user = UserModel.fromJson({
      'id': 1,
      'name': 'N',
      'email': 'n@example.invalid',
    });
    expect(user.roles, isEmpty);
    expect(user.dateOfBirth, isNull);
    expect(() => user.roles.add('driver'), throwsUnsupportedError);
  });
  test(
    'request sends email and password only; malformed success is rejected',
    () {
      const request = LoginRequestModel(
        email: 'test@example.invalid',
        password: 'private',
      );
      expect(request.toJson().keys, unorderedEquals(['email', 'password']));
      expect(
        () =>
            LoginResponseModel.fromJson({'status': false, 'message': 'error'}),
        throwsA(anything),
      );
    },
  );
  test(
    'all four locales have identical nonempty keys and preserve parameters',
    () {
      final maps = AppTranslations().keys;
      expect(maps.keys, unorderedEquals(['es', 'en', 'fr', 'pt']));
      for (final translations in maps.values) {
        expect(translations.keys, unorderedEquals(maps['es']!.keys));
        expect(translations.values.every((v) => v.isNotEmpty), isTrue);
        expect(translations['home.greeting'], contains('@name'));
        expect(translations['role.many'], contains('@count'));
      }
    },
  );
}
