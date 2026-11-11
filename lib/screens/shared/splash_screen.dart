import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/session_service.dart';

/// 5.1 Splash / carga inicial.
/// Muestra la identidad de SinSam Express y determina si existe
/// una sesión válida antes de continuar.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    final hasSession = SessionService.instance.hasValidSession;
    Navigator.of(context).pushReplacementNamed(
      hasSession ? AppRoutes.dashboard : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2544), AppColors.primary],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.directions_bus_filled_rounded, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 18),
            const Text(
              'SinSam Express',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Transporte Mixto · Sincelejo ↔ Sampués',
              style: TextStyle(color: Color(0xFFB9CBE2), fontSize: 12.5),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.6, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
