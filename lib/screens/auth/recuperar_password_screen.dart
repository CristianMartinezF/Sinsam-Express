import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/misc_widgets.dart';

/// 5.3 Recuperar contraseña.
/// Inicia el proceso de recuperación mediante el correo registrado.
class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _correoCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _enviar() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushNamed(AppRoutes.verificarOtp, arguments: _correoCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Recuperar contraseña'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(color: AppColors.infoBg, shape: BoxShape.circle),
                    child: const Icon(Icons.mail_outline_rounded, color: AppColors.secondary, size: 24),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Ingresa el correo registrado en la plataforma. Te enviaremos un código de verificación.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: AppColors.neutral, height: 1.5),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              AppTextField(
                label: 'Correo electrónico',
                controller: _correoCtrl,
                hint: 'nombre@correo.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 6),
              AppButton(label: 'Enviar código OTP', loading: _loading, onPressed: _enviar),
              AppButton(
                label: 'Volver al inicio de sesión',
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
