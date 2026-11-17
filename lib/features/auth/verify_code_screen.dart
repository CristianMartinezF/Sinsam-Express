import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import 'new_password_screen.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const digits = ['4', '6', '1', '7', '', ''];
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Verificar codigo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Revisa tu correo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Enviamos un codigo de 6 digitos a\nn***@gmail.com',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (i) => SizedBox(
                  width: 44,
                  child: TextField(
                    controller: TextEditingController(text: digits[i]),
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('¿No te llego ? Reenviar en 00:45', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Verificar codigo',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
              ),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver')),
          ],
        ),
      ),
    );
  }
}
