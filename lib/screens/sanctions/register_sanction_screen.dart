import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterSanctionScreen extends StatefulWidget {
  const RegisterSanctionScreen({super.key});

  @override
  State<RegisterSanctionScreen> createState() => _RegisterSanctionScreenState();
}

class _RegisterSanctionScreenState extends State<RegisterSanctionScreen> {
  final _idCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  void _confirmSanction(BuildContext context) {
    if (_idCtrl.text.trim().isEmpty || _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa identificación del conductor y motivo')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: AppColors.dangerText, size: 42),
        title: const Text('¿Confirmar Sanción?'),
        content: Text(
          'El conductor con CC ${_idCtrl.text.trim()} no podrá ser asignado a operaciones entre el ${_startCtrl.text.trim()} y el ${_endCtrl.text.trim()}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerText, foregroundColor: Colors.white),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogCtx);
              try {
                await context.read<AppProvider>().addSanction(
                      SanctionModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        conductor: _idCtrl.text.trim(),
                        identificacion: _idCtrl.text.trim(),
                        fechaInicio: _startCtrl.text.trim(),
                        fechaFin: _endCtrl.text.trim(),
                        motivo: _reasonCtrl.text.trim(),
                        estado: 'Vigente',
                      ),
                    );
                navigator.pop();
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Error al registrar sanción: $e')));
              }
            },
            child: const Text('Sí, registrar sanción'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar sanción')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'Identificación del conductor', hint: 'Ej. 1102899321', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha inicial', hint: 'AAAA-MM-DD (Ej. 2026-11-18)', controller: _startCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha final', hint: 'AAAA-MM-DD (Ej. 2026-11-21)', controller: _endCtrl),
            const SizedBox(height: 6),
            const Text(
              'La fecha final debe ser igual o posterior a la inicial.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            CustomInput(label: 'Motivo de la sanción', hint: 'Ej. Incumplimiento de horario', maxLines: 3, controller: _reasonCtrl),
            const SizedBox(height: 22),
            PrimaryButton(text: 'Guardar sanción', onPressed: () => _confirmSanction(context)),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}