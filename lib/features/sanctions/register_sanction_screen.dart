import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/app_models.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class RegisterSanctionScreen extends StatefulWidget {
  const RegisterSanctionScreen({super.key});

  @override
  State<RegisterSanctionScreen> createState() => _RegisterSanctionScreenState();
}

class _RegisterSanctionScreenState extends State<RegisterSanctionScreen> {
  final _driverCtrl = TextEditingController(text: 'Diego Torres Múnera');
  final _startCtrl = TextEditingController(text: '19/09/2026');
  final _endCtrl = TextEditingController(text: '28/09/2026');
  final _reasonCtrl = TextEditingController(text: 'Documentacion vencida');
  final _obsCtrl = TextEditingController();

  void _confirmSanction(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: AppColors.dangerText, size: 42),
        title: const Text('¿Confirmar Sancion?'),
        content: Text(
          '${_driverCtrl.text} no podra ser asignado a operaciones entre el ${_startCtrl.text} y el ${_endCtrl.text}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerText, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<AppProvider>().addSanction(
                    SanctionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      conductor: _driverCtrl.text.trim(),
                      identificacion: '1.002.334.552',
                      fechaInicio: _startCtrl.text.trim(),
                      fechaFin: _endCtrl.text.trim(),
                      motivo: _reasonCtrl.text.trim(),
                      observaciones: _obsCtrl.text.trim(),
                      estado: 'Vigente',
                    ),
                  );
              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Si, registrar sancion'),
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
            CustomInput(label: 'Conductor', hint: 'Diego Torres Munera', controller: _driverCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha inicial', hint: '19/09/2026', controller: _startCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha final', hint: '28/09/2026', controller: _endCtrl),
            const SizedBox(height: 6),
            const Text(
              'La fecha final debe ser igual o posterior a la inicial.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            CustomInput(label: 'Motivo de la sanción', hint: 'Documentacion vencida', controller: _reasonCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Observaciones (opcional)', hint: 'Añadir observaciones...', maxLines: 3, controller: _obsCtrl),
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
