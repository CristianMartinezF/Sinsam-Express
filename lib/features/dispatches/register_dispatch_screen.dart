import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/app_models.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class RegisterDispatchScreen extends StatefulWidget {
  const RegisterDispatchScreen({super.key});

  @override
  State<RegisterDispatchScreen> createState() => _RegisterDispatchScreenState();
}

class _RegisterDispatchScreenState extends State<RegisterDispatchScreen> {
  final _plateCtrl = TextEditingController(text: 'ABC-123');
  final _dateCtrl = TextEditingController(text: '19/09/2026');
  final _paxCtrl = TextEditingController(text: '14');
  final _hourCtrl = TextEditingController(text: '09:30 a.m.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Despacho')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Sincelejo → Sampués\nRuta operada por SinSam Express. Verifique disponibilidad antes de despachar.',
                style: TextStyle(color: AppColors.infoText, fontSize: 12),
              ),
            ),
            const SizedBox(height: 14),
            CustomInput(label: 'Vehículo', hint: 'Seleccionar vehículo', controller: _plateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha', hint: 'dd/mm/aaaa', controller: _dateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Número de pasajeros', hint: 'Ej. 14', keyboardType: TextInputType.number, controller: _paxCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Hora', hint: '--:--', controller: _hourCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                await context.read<AppProvider>().addDispatch(
                      DispatchModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        codigo: 'DSP-${1044 + DateTime.now().second}',
                        ruta: 'Sincelejo - Sampués',
                        placa: _plateCtrl.text.trim().toUpperCase(),
                        pasajeros: int.tryParse(_paxCtrl.text) ?? 10,
                        fecha: _dateCtrl.text.trim(),
                        hora: _hourCtrl.text.trim(),
                        estado: 'Despachado',
                      ),
                    );
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
