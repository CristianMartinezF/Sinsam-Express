import '../models/user_session.dart';

/// Simula el manejo de sesión de autenticación (sin backend real).
/// Expone si existe una sesión válida, utilizada por el Splash
/// y por la detección de "sesión no válida".
class SessionService {
  SessionService._internal();
  static final SessionService instance = SessionService._internal();

  UserSession? _currentSession;

  bool get hasValidSession => _currentSession != null;
  UserSession? get currentUser => _currentSession;

  Future<UserSession> login({
    required String usuario,
    required String password,
    required AppRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final nombres = {
      AppRole.gerente: 'Laura Restrepo',
      AppRole.asistente: 'Ana Gómez',
      AppRole.conductor: 'Diego Torres Múnera',
      AppRole.asociado: 'Camilo Restrepo Ávila',
    };
    _currentSession = UserSession(
      usuario: usuario.isEmpty ? 'usuario@sinsamexpress.co' : usuario,
      nombre: nombres[role] ?? 'Usuario SinSam',
      role: role,
    );
    return _currentSession!;
  }

  void logout() {
    _currentSession = null;
  }

  /// Simula la expiración / invalidez de la sesión actual.
  void invalidateSession() {
    _currentSession = null;
  }
}
