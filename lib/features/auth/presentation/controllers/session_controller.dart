import 'package:get/get.dart';

import '../../../../core/network/app_failure.dart';
import '../../domain/auth_repository.dart';
import '../../domain/auth_user.dart';

/// Mantiene el usuario y el estado de sesión compartidos por las pantallas.
class SessionController extends GetxService {
  SessionController(this.repository);
  final AuthRepository repository;
  final user = Rxn<AuthUser>();
  final confirmed = false.obs;
  final restoring = false.obs;
  final errorKey = RxnString();
  /// Indica si hay un usuario local; no sustituye la validación del servidor.
  bool get signedIn => user.value != null;
  /// Evita aplicar una restauración antigua después de cambiar la sesión.
  int _revision = 0;

  /// Recupera el usuario persistido y actualiza su estado de confirmación.
  Future<void> restore() async {
    final revision = _revision;
    restoring.value = true;
    errorKey.value = null;
    try {
      final result = await repository.restore();
      if (revision != _revision) return;
      user.value = result?.user;
      confirmed.value = result?.confirmed ?? false;
    } on AppFailure catch (error) {
      if (revision == _revision) errorKey.value = error.translationKey;
    } catch (_) {
      if (revision == _revision) errorKey.value = 'error.unexpected';
    } finally {
      restoring.value = false;
    }
  }

  /// Inicia sesión y abre Home retirando el login del historial.
  Future<void> login(String email, String password) async {
    final result = await repository.login(email, password);
    _revision++;
    user.value = result;
    confirmed.value = true;
    errorKey.value = null;
    Get.offAllNamed('/home');
  }

  /// Limpia la sesión local y regresa al login sin permitir volver a Home.
  Future<void> logout({bool expired = false}) async {
    _revision++;
    user.value = null;
    confirmed.value = false;
    try {
      await repository.clear();
      errorKey.value = expired ? 'error.unauthorized' : null;
    } catch (_) {
      errorKey.value = 'error.storage';
    }
    if (Get.key.currentState != null) Get.offAllNamed('/login');
  }
}
