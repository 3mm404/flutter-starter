import 'package:get_storage/get_storage.dart';

/// Define cómo leer, guardar y eliminar datos locales no secretos.
abstract interface class PreferencesStore {
  /// Lee un dato local con el tipo esperado.
  T? read<T>(String key);
  /// Guarda un dato local y permite esperar su escritura.
  Future<void> write(String key, dynamic value);
  /// Elimina un dato local por su clave.
  Future<void> remove(String key);
}

/// Implementa las preferencias y la caché del usuario con GetStorage.
class LocalPreferences implements PreferencesStore {
  LocalPreferences(this.box);
  final GetStorage box;
  @override
  /// Lee un dato local con el tipo esperado.
  T? read<T>(String key) => box.read<T>(key);
  @override
  /// Guarda un dato local y permite esperar su escritura.
  Future<void> write(String key, dynamic value) => box.write(key, value);
  @override
  /// Elimina un dato local por su clave.
  Future<void> remove(String key) => box.remove(key);
}
