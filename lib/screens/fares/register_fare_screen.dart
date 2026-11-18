import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterFareScreen extends StatefulWidget {
  const RegisterFareScreen({super.key});

  @override
  State<RegisterFareScreen> createState() => _RegisterFareScreenState();
}

class _RegisterFareScreenState extends State<RegisterFareScreen> {
  final _nameCtrl = TextEditingController();
  final _gastosCtrl = TextEditingController();
  final _fondoCtrl = TextEditingController();
  final _socialCtrl = TextEditingController();
  bool _isActive = true;

  int get _total =>
      (int.tryParse(_gastosCtrl.text) ?? 0) +
      (int.tryParse(_fondoCtrl.text) ?? 0) +
      (int.tryParse(_socialCtrl.text) ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar tarifa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(label: 'Nombre de tarifa', hint: 'Ej. Tarifa estándar', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Aportes gastos varios', hint: '0', controller: _gastosCtrl, keyboardType: TextInputType.number, onChanged: (_) => setState(() {})),
            const SizedBox(height: 12),
            CustomInput(label: 'Fondo de reposición', hint: '0', controller: _fondoCtrl, keyboardType: TextInputType.number, onChanged: (_) => setState(() {})),
            const SizedBox(height: 12),
            CustomInput(label: 'Aporte social del socio', hint: '0', controller: _socialCtrl, keyboardType: TextInputType.number, onChanged: (_) => setState(() {})),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total calculado', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('\$$_total', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.navyPrimary)),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Tarifa activa'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                if (_nameCtrl.text.trim().isEmpty) return;
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await context.read<AppProvider>().addFare(
                        FareModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          nombre: _nameCtrl.text.trim(),
                          gastosVarios: int.tryParse(_gastosCtrl.text) ?? 0,
                          fondoReposicion: int.tryParse(_fondoCtrl.text) ?? 0,
                          aporteSocial: int.tryParse(_socialCtrl.text) ?? 0,
                          activa: _isActive,
                        ),
                      );
                  navigator.pop();
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('Error al crear tarifa: $e')));
                }
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