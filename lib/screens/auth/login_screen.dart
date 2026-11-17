import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/sinsam_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController(text: 'usuario@gmail.com');
  final _passCtrl = TextEditingController(text: '12345678');
  bool _obscure = true;
  bool _loading = false;

  Future<void> _handleLogin() async {
    setState(() => _loading = true);
    final ok = await ApiService.login(_userCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      context.read<AppProvider>().fetchInitialData();
      Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 28),
              const SinSamLogoIcon(size: 82),
              const SizedBox(height: 24),
              const Text(
                'Bienvenido de nuevo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresa tus credenciales para continuar',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 30),
              CustomInput(
                label: 'Usuario',
                hint: 'usuario@gmail.com',
                controller: _userCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomInput(
                label: 'Contraseña',
                hint: '***********',
                controller: _passCtrl,
                obscureText: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 19),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.recoverPassword),
                  child: const Text(
                    '¿Olvidate tu contraseña?',
                    style: TextStyle(color: AppColors.logoBlue, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _loading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: 'Iniciar sesion',
                      onPressed: _handleLogin,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
