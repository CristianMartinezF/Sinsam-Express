import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterDispatchScreen extends StatefulWidget {
  const RegisterDispatchScreen({super.key});

  @override
  State<RegisterDispatchScreen> createState() => _RegisterDispatchScreenState();
}

class _RegisterDispatchScreenState extends State<RegisterDispatchScreen> {
  final _plateCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _paxCtrl = TextEditingController();
  final _hourCtrl = TextEditingController();

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
            CustomInput(label: 'Vehículo', hint: 'Ej. ABC-123', controller: _plateCtrl),
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
                if (_plateCtrl.text.trim().isEmpty) return;
                final navigator = Navigator.of(context);
                await context.read<AppProvider>().addDispatch(
                      DispatchModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        codigo: 'DSP-${1000 + DateTime.now().second}',
                        ruta: 'Sincelejo - Sampués',
                        placa: _plateCtrl.text.trim().toUpperCase(),
                        pasajeros: int.tryParse(_paxCtrl.text) ?? 0,
                        fecha: _dateCtrl.text.trim(),
                        hora: _hourCtrl.text.trim(),
                        estado: 'Despachado',
                      ),
                    );
                navigator.pop();
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
