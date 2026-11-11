import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.4 Verificar código OTP.
/// Valida la identidad del usuario mediante un código de 5–6 dígitos
/// enviado al correo electrónico ingresado.
class VerificarOtpScreen extends StatefulWidget {
  final String? correo;
  const VerificarOtpScreen({super.key, this.correo});

  @override
  State<VerificarOtpScreen> createState() => _VerificarOtpScreenState();
}

class _VerificarOtpScreenState extends State<VerificarOtpScreen> {
  final List<TextEditingController> _digits = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;

  String get _code => _digits.map((c) => c.text).join();

  Future<void> _verificar() async {
    if (_code.length < 6) {
      AppSnackBar.error(context, 'Ingresa el código completo de 6 dígitos.');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushNamed(AppRoutes.nuevaPassword);
  }

  @override
  void dispose() {
    for (final c in _digits) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final correo = widget.correo ?? '';
    final arroba = correo.indexOf('@');
    final correoOculto =
        arroba > 1 ? correo.replaceRange(1, arroba, '***') : 'n***@correo.com';

    return Scaffold(
      appBar: const AppTopBar(title: 'Verificar código'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Revisa tu correo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Enviamos un código de 6 dígitos a $correoOculto',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.neutral)),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 44,
                    height: 54,
                    child: TextField(
                      controller: _digits[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(counterText: ''),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < 5) {
                          _nodes[i + 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text.rich(
                  TextSpan(
                    text: '¿No llegó el código? ',
                    style: TextStyle(fontSize: 11.5, color: AppColors.neutral),
                    children: [
                      TextSpan(
                        text: 'Reenviar en 00:42',
                        style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              AppButton(label: 'Verificar código', loading: _loading, onPressed: _verificar),
              AppButton(
                label: 'Volver',
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
