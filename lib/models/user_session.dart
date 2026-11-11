/// Roles disponibles en el sistema según la actividad SITRAMIX.
/// Administrador = Gerente o Asistente.
enum AppRole { gerente, asistente, conductor, asociado }

extension AppRoleX on AppRole {
  String get label {
    switch (this) {
      case AppRole.gerente:
        return 'Gerente';
      case AppRole.asistente:
        return 'Asistente';
      case AppRole.conductor:
        return 'Conductor';
      case AppRole.asociado:
        return 'Asociado';
    }
  }

  /// Gerente y Asistente conforman el perfil "Administrador".
  bool get isAdmin => this == AppRole.gerente || this == AppRole.asistente;
}

class UserSession {
  final String usuario;
  final String nombre;
  final AppRole role;

  const UserSession({
    required this.usuario,
    required this.nombre,
    required this.role,
  });
}
