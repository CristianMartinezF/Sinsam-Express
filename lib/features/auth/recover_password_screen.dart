import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';
import 'verify_code_screen.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Ingrese el correo registrado en la plataforma. Te enviaremos un codigo de verificacion',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 22),
            const CustomInput(label: 'Correo electronico', hint: 'nombre@gmail.com'),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Enviar codigo',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VerifyCodeScreen()),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver al inicio sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
