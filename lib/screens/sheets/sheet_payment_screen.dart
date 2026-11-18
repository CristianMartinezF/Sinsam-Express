import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class SheetPaymentScreen extends StatefulWidget {
  final SheetModel sheet;
  const SheetPaymentScreen({super.key, required this.sheet});

  @override
  State<SheetPaymentScreen> createState() => _SheetPaymentScreenState();
}

class _SheetPaymentScreenState extends State<SheetPaymentScreen> {
  final _dateCtrl = TextEditingController(text: DateTime.now().toString().split(' ').first);
  final _methodCtrl = TextEditingController(text: 'Efectivo');

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
                  _PRow('Número', widget.sheet.numero),
                  _PRow('Conductor', widget.sheet.conductor.isEmpty ? 'Sin asignar' : widget.sheet.conductor),
                  _PRow('Vehículo', widget.sheet.placa),
                  _PRow('Valor', '\$${widget.sheet.valor}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomInput(label: 'Fecha de pago', hint: 'AAAA-MM-DD', controller: _dateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Método de pago', hint: 'Efectivo', controller: _methodCtrl),
            const Spacer(),
            PrimaryButton(
              text: 'Registrar pago',
              onPressed: () {
                context.read<AppProvider>().paySheet(widget.sheet.id);
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
          Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
        ],
      ),
    );
  }
}