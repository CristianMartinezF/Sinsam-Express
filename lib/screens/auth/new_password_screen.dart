import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomInput(label: 'Nueva contraseña', hint: '**********', obscureText: true),
            const SizedBox(height: 16),
            const CustomInput(label: 'Confirmar contraseña', hint: '**********', obscureText: true),
            const SizedBox(height: 8),
            const Text(
              'Minimo 8 caracteres, una mayuscula y un numero.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (r) => false,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
