/// Representa al usuario para el dominio y la interfaz, sin token ni conversión JSON.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.roles = const [],
  });
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final List<String> roles;
}

/// Indica qué usuario se restauró y si el servidor confirmó su sesión.
class RestoredSession {
  const RestoredSession(this.user, {required this.confirmed});
  final AuthUser user;
  final bool confirmed;
}
