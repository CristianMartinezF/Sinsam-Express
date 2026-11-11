import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/tarifa.dart';
import '../../services/tarifas_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.12.2 Registrar tarifa.
class TarifaFormScreen extends StatefulWidget {
  const TarifaFormScreen({super.key});

  @override
  State<TarifaFormScreen> createState() => _TarifaFormScreenState();
}

class _TarifaFormScreenState extends State<TarifaFormScreen> {
  final _nombreCtrl = TextEditingController();
  final _gastosCtrl = TextEditingController();
  final _fondoCtrl = TextEditingController();
  final _socialCtrl = TextEditingController();
  bool _activo = true;
  bool _loading = false;

  double _n(TextEditingController c) => double.tryParse(c.text.replaceAll('.', '')) ?? 0;
  double get _total => _n(_gastosCtrl) + _n(_fondoCtrl) + _n(_socialCtrl);

  Future<void> _guardar() async {
    if (_nombreCtrl.text.isEmpty || _total <= 0) {
      AppSnackBar.error(context, 'Indica un nombre y al menos un valor mayor a cero.');
      return;
    }
    setState(() => _loading = true);
    await TarifasService().registrar(Tarifa(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      nombre: _nombreCtrl.text,
      aportesGastosVarios: _n(_gastosCtrl),
      fondoReposicion: _n(_fondoCtrl),
      aporteSocial: _n(_socialCtrl),
      activo: _activo,
      fechaRegistro: DateTime.now(),
    ));
    if (!mounted) return;
    AppSnackBar.success(context, 'Tarifa registrada exitosamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar tarifa'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AppTextField(label: 'Nombre de la tarifa', controller: _nombreCtrl, hint: 'Ej. Tarifa estándar'),
            AppTextField(label: 'Aportes gastos varios', controller: _gastosCtrl, hint: '\$0', keyboardType: TextInputType.number),
            AppTextField(label: 'Fondo de reposición', controller: _fondoCtrl, hint: '\$0', keyboardType: TextInputType.number),
            AppTextField(label: 'Aporte social del socio', controller: _socialCtrl, hint: '\$0', keyboardType: TextInputType.number),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => setState(() {}), child: const Text('Calcular total')),
            ),
            DetailBlock(rows: [DetailRow(label: 'Total calculado', value: fmtMoney(_total))]),
            SwitchListTile(
              value: _activo,
              onChanged: (v) => setState(() => _activo = v),
              title: const Text('Tarifa activa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              contentPadding: EdgeInsets.zero,
            ),
            AppButton(label: 'Guardar', loading: _loading, onPressed: _guardar),
            AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
