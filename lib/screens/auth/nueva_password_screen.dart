import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.5 Crear nueva contraseña.
/// Permite establecer una nueva contraseña tras validar el OTP.
class NuevaPasswordScreen extends StatefulWidget {
  const NuevaPasswordScreen({super.key});

  @override
  State<NuevaPasswordScreen> createState() => _NuevaPasswordScreenState();
}

class _NuevaPasswordScreenState extends State<NuevaPasswordScreen> {
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;
  bool _loading = false;

  Future<void> _guardar() async {
    if (_nuevaCtrl.text.length < 8) {
      AppSnackBar.error(context, 'La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    if (_nuevaCtrl.text != _confirmarCtrl.text) {
      AppSnackBar.error(context, 'Las contraseñas no coinciden.');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.success(context, 'Contraseña actualizada correctamente.');
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Nueva contraseña'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nueva contraseña',
                controller: _nuevaCtrl,
                obscureText: _obscure1,
                suffixIcon: IconButton(
                  icon: Icon(_obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
              ),
              AppTextField(
                label: 'Confirmar contraseña',
                controller: _confirmarCtrl,
                obscureText: _obscure2,
                suffixIcon: IconButton(
                  icon: Icon(_obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
                helperText: 'Mínimo 8 caracteres, una mayúscula y un número.',
              ),
              const SizedBox(height: 6),
              AppButton(label: 'Guardar', loading: _loading, onPressed: _guardar),
              AppButton(
                label: 'Cancelar',
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
