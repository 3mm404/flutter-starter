import 'package:app_1/core/storage/preferences_store.dart';
import 'package:app_1/core/storage/token_store.dart';
import 'package:app_1/features/auth/domain/auth_repository.dart';
import 'package:app_1/features/auth/domain/auth_user.dart';

class MemoryPreferences implements PreferencesStore {
  final values = <String, dynamic>{};
  @override
  T? read<T>(String key) => values[key] as T?;
  @override
  Future<void> write(String key, dynamic value) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }
}

class MemoryTokens implements TokenStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async {
    value = token;
  }

  @override
  Future<void> clear() async {
    value = null;
  }
}

const testUser = AuthUser(
  id: 7,
  name: 'Test Person',
  email: 'test@example.invalid',
  roles: ['client'],
);

class FakeAuthRepository implements AuthRepository {
  RestoredSession? saved;
  int logins = 0;
  @override
  Future<AuthUser> login(String email, String password) async {
    logins++;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    saved = const RestoredSession(testUser, confirmed: true);
    return testUser;
  }

  @override
  Future<RestoredSession?> restore() async => saved;
  @override
  Future<void> clear() async {
    saved = null;
  }
}
