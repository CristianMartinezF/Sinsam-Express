import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

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
              onPressed: () => Navigator.pushNamed(context, AppRoutes.verifyCode),
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
