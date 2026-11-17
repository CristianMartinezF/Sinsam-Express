import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class SheetPaymentScreen extends StatelessWidget {
  final SheetModel sheet;
  const SheetPaymentScreen({super.key, required this.sheet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago de planilla')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _PRow('Número', sheet.numero),
                  _PRow('Conductor', sheet.conductor),
                  _PRow('Vehículo', sheet.placa),
                  _PRow('Valor', '\$${sheet.valor}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const CustomInput(label: 'Fecha de pago', hint: '19/09/2026'),
            const SizedBox(height: 12),
            const CustomInput(label: 'Método de pago', hint: 'Efectivo'),
            const Spacer(),
            PrimaryButton(
              text: 'Registrar pago',
              onPressed: () {
                context.read<AppProvider>().paySheet(sheet.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pago registrado con éxito')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PRow extends StatelessWidget {
  final String k, v;
  const _PRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
