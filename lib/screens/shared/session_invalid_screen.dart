import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/session_service.dart';

/// Estado obligatorio "Sesión no válida": redirección al login
/// y limpieza de los datos de autenticación.
class SessionInvalidScreen extends StatelessWidget {
  const SessionInvalidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 18),
              const Text(
                'Tu sesión ha expirado',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Por seguridad cerramos tu sesión. Vuelve a iniciar sesión para continuar.',
                style: TextStyle(color: Color(0xFFC7D7EA), fontSize: 12.5, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  ),
                  onPressed: () {
                    SessionService.instance.invalidateSession();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                  },
                  child: const Text('Ir al inicio de sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
