import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/user_session.dart';
import '../../routes/app_routes.dart';
import '../../services/session_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';

/// 5.2 Inicio de sesión.
/// Autentica al usuario y obtiene la información de la sesión.
/// Como no hay backend en esta fase, se incluye un selector de rol
/// de demostración (Gerente, Asistente, Conductor, Asociado).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioCtrl = TextEditingController(text: 'usuario@sinsamexpress.co');
  final _passwordCtrl = TextEditingController(text: '••••••••');
  bool _obscure = true;
  bool _loading = false;
  AppRole _role = AppRole.gerente;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await SessionService.instance.login(
        usuario: _usuarioCtrl.text,
        password: _passwordCtrl.text,
        role: _role,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.dashboard, (r) => false);
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Usuario o contraseña incorrectos.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.directions_bus_filled_rounded, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Bienvenido de nuevo', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                'Ingresa tus credenciales para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppColors.neutral),
              ),
              const SizedBox(height: 26),
              AppTextField(label: 'Usuario', controller: _usuarioCtrl, hint: 'usuario@sinsamexpress.co'),
              AppTextField(
                label: 'Contraseña',
                controller: _passwordCtrl,
                obscureText: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              AppDropdownField<AppRole>(
                label: 'Rol (demostración sin backend)',
                value: _role,
                items: AppRole.values
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
                    .toList(),
                onChanged: (r) => setState(() => _role = r ?? AppRole.gerente),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.recuperarPassword),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              const SizedBox(height: 8),
              AppButton(label: 'Iniciar sesión', loading: _loading, onPressed: _login),
              const SizedBox(height: 14),
              const Text(
                'Al continuar aceptas las políticas de uso de la cooperativa.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.neutral),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
