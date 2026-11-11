import 'package:flutter/material.dart';
import '../../models/user_session.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/session_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// Pantalla "Mi cuenta": datos de la sesión activa y cierre de sesión
/// (flujo 13 de la actividad: "Cambio de contraseña o cierre de sesión").
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi cuenta'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: InitialsAvatar(
                text: (session?.nombre ?? 'US').split(' ').map((e) => e[0]).take(2).join(),
                size: 64,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(session?.nombre ?? 'Usuario',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            Center(
              child: Text(session?.role.label ?? '',
                  style: const TextStyle(fontSize: 12, color: AppColors.neutral)),
            ),
            const SectionLabel('Información de la cuenta'),
            DetailBlock(rows: [
              DetailRow(label: 'Usuario', value: session?.usuario ?? '-'),
              DetailRow(label: 'Rol', value: session?.role.label ?? '-'),
            ]),
            const SizedBox(height: 20),
            AppButton(
              label: 'Cambiar contraseña',
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.nuevaPassword),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Cerrar sesión',
              variant: AppButtonVariant.danger,
              onPressed: () async {
                final ok = await ConfirmDialog.show(
                  context,
                  title: '¿Cerrar sesión?',
                  message: 'Deberás volver a iniciar sesión para acceder a SinSam Express.',
                  confirmLabel: 'Cerrar sesión',
                );
                if (ok && context.mounted) {
                  SessionService.instance.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.miPerfil),
    );
  }
}
