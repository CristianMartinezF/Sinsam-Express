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
  final _driverCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();

  void _confirmSanction(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: AppColors.dangerText, size: 42),
        title: const Text('¿Confirmar Sancion?'),
        content: Text(
          '${_driverCtrl.text} no podra ser asignado a operaciones entre el ${_startCtrl.text} y el ${_endCtrl.text}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerText, foregroundColor: Colors.white),
            onPressed: () async {
              final navigator = Navigator.of(context);
              Navigator.pop(dialogCtx);
              await context.read<AppProvider>().addSanction(
                    SanctionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      conductor: _driverCtrl.text.trim(),
                      identificacion: _idCtrl.text.trim(),
                      fechaInicio: _startCtrl.text.trim(),
                      fechaFin: _endCtrl.text.trim(),
                      motivo: _reasonCtrl.text.trim(),
                      observaciones: _obsCtrl.text.trim(),
                      estado: 'Vigente',
                    ),
                  );
              navigator.pop();
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
            CustomInput(label: 'Conductor', hint: 'Nombre completo del conductor', controller: _driverCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Identificación', hint: 'Número de documento', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha inicial', hint: 'dd/mm/aaaa', controller: _startCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha final', hint: 'dd/mm/aaaa', controller: _endCtrl),
            const SizedBox(height: 6),
            const Text(
              'La fecha final debe ser igual o posterior a la inicial.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            CustomInput(label: 'Motivo de la sanción', hint: 'Ej. Documentación vencida', controller: _reasonCtrl),
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
