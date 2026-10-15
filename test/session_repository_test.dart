import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_1/core/network/api_client.dart';
import 'package:app_1/core/network/app_failure.dart';
import 'package:app_1/features/auth/data/repositories/api_auth_repository.dart';
import 'package:app_1/features/auth/data/sources/auth_remote_source.dart';

import 'support/fakes.dart';

class StubAdapter implements HttpClientAdapter {
  StubAdapter(this.respond);
  final FutureOr<ResponseBody> Function(RequestOptions) respond;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => respond(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object body, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

final userJson = {
  'id': 7,
  'name': 'Test Person',
  'email': 'test@example.invalid',
  'date_of_birth': null,
  'phone_number': null,
  'roles': ['client'],
};

void main() {
  late MemoryPreferences preferences;
  late MemoryTokens tokens;
  late Dio dio;
  late ApiClient client;
  late ApiAuthRepository repository;
  setUp(() {
    preferences = MemoryPreferences();
    tokens = MemoryTokens();
    dio = Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1/'));
    client = ApiClient(dio, tokens);
    repository = ApiAuthRepository(
      AuthRemoteSource(client),
      tokens,
      preferences,
    );
    client.onUnauthorized = repository.clear;
  });
  tearDown(() => dio.close(force: true));

  test('login stores token separately; new repository restores via actual profile contract', () async {
    dio.httpClientAdapter = StubAdapter((request) {
      if (request.path == 'login') {
        expect(request.data, {
          'email': 'test@example.invalid',
          'password': 'private',
        });
        expect(request.headers.containsKey('Authorization'), isFalse);
        return jsonBody({
          'status': true,
          'message': 'ok',
          'user': userJson,
          'token': 'secret',
        });
      }
      expect(request.path, 'profile');
      expect(request.headers['Authorization'], 'Bearer secret');
      return jsonBody({
        'data': {...userJson, 'roles': null, 'role': 'client'},
      });
    });
    await preferences.write('language', 'fr');
    final user = await repository.login('test@example.invalid', 'private');
    expect(user.id, 7);
    expect(tokens.value, 'secret');
    expect(jsonEncode(preferences.values), isNot(contains('secret')));
    expect(jsonEncode(preferences.values), isNot(contains('private')));
    final recreated = ApiAuthRepository(
      AuthRemoteSource(client),
      tokens,
      preferences,
    );
    final restored = await recreated.restore();
    expect(restored?.confirmed, isTrue);
    expect(restored?.user.roles, ['client']);
    await recreated.clear();
    expect(tokens.value, isNull);
    expect(preferences.values.containsKey(ApiAuthRepository.userKey), isFalse);
    expect(preferences.read<String>('language'), 'fr');
  });

  test(
    'offline restoration retains cached session, pending server confirmation',
    () async {
      tokens.value = 'existing-token';
      preferences.values[ApiAuthRepository.userKey] = userJson;
      dio.httpClientAdapter = StubAdapter(
        (request) => throw DioException(
          requestOptions: request,
          type: DioExceptionType.connectionError,
        ),
      );
      final restored = await repository.restore();
      expect(restored?.user.id, 7);
      expect(restored?.confirmed, isFalse);
      expect(tokens.value, 'existing-token');
    },
  );

  test(
    'authenticated 401 clears session and cached user, preserving preferences',
    () async {
      tokens.value = 'expired';
      preferences.values.addAll({
        ApiAuthRepository.userKey: userJson,
        'theme': 'dark',
      });
      dio.httpClientAdapter = StubAdapter(
        (_) => jsonBody({'message': 'Unauthenticated'}, 401),
      );
      expect(await repository.restore(), isNull);
      expect(tokens.value, isNull);
      expect(preferences.values, {'theme': 'dark'});
    },
  );

  test(
    'incorrect credentials do not expire an existing authenticated session',
    () async {
      tokens.value = 'existing';
      dio.httpClientAdapter = StubAdapter(
        (_) => jsonBody({'status': false, 'message': 'no'}, 401),
      );
      await expectLater(
        repository.login('x@example.invalid', 'invalid'),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.kind,
            'kind',
            FailureKind.credentials,
          ),
        ),
      );
      expect(tokens.value, 'existing');
    },
  );

  test('malformed success never persists token or profile', () async {
    dio.httpClientAdapter = StubAdapter(
      (_) => jsonBody({'status': true, 'token': 'secret'}),
    );
    await expectLater(
      repository.login('x@example.invalid', 'private'),
      throwsA(
        isA<AppFailure>().having((e) => e.kind, 'kind', FailureKind.unexpected),
      ),
    );
    expect(tokens.value, isNull);
    expect(preferences.values, isEmpty);
  });

  for (final kind in [
    FailureKind.timeout,
    FailureKind.offline,
    FailureKind.server,
  ]) {
    test('maps ${kind.name} without logging out', () async {
      tokens.value = 'existing';
      dio.httpClientAdapter = StubAdapter((request) {
        if (kind == FailureKind.server) {
          return jsonBody({'message': 'private internals'}, 500);
        }
        throw DioException(
          requestOptions: request,
          type: kind == FailureKind.timeout
              ? DioExceptionType.receiveTimeout
              : DioExceptionType.connectionError,
        );
      });
      await expectLater(
        client.request('profile', authenticated: true),
        throwsA(isA<AppFailure>().having((e) => e.kind, 'kind', kind)),
      );
      expect(tokens.value, 'existing');
    });
  }
}
