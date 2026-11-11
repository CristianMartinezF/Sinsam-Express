import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/tarifa.dart';
import '../../services/mock_database.dart';
import '../../services/tarifas_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/status_chip.dart';

/// 5.12.3 Detalle de tarifa / inactivar.
class TarifaDetailScreen extends StatefulWidget {
  final String tarifaId;
  const TarifaDetailScreen({super.key, required this.tarifaId});

  @override
  State<TarifaDetailScreen> createState() => _TarifaDetailScreenState();
}

class _TarifaDetailScreenState extends State<TarifaDetailScreen> {
  late Tarifa _t;

  @override
  void initState() {
    super.initState();
    _t = MockDatabase.instance.tarifaById(widget.tarifaId)!;
  }

  Future<void> _inactivar() async {
    final ok = await ConfirmDialog.show(
      context,
      title: '¿Inactivar esta tarifa?',
      message: '${_t.nombre} dejará de estar disponible para generar nuevas planillas. Las planillas existentes no se verán afectadas.',
      confirmLabel: 'Sí, inactivar tarifa',
    );
    if (!ok) return;
    await TarifasService().inactivar(_t.id);
    if (!mounted) return;
    setState(() {});
    AppSnackBar.success(context, 'Tarifa inactivada correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Detalle de tarifa'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(_t.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(label: _t.activo ? 'Activa' : 'Inactiva', type: _t.activo ? ChipType.active : ChipType.inactive),
            ),
            const SectionLabel('Componentes'),
            DetailBlock(rows: [
              DetailRow(label: 'Aportes gastos varios', value: fmtMoney(_t.aportesGastosVarios)),
              DetailRow(label: 'Fondo de reposición', value: fmtMoney(_t.fondoReposicion)),
              DetailRow(label: 'Aporte social del socio', value: fmtMoney(_t.aporteSocial)),
            ]),
            const SectionLabel('Resumen'),
            DetailBlock(rows: [
              DetailRow(label: 'Total', value: fmtMoney(_t.total)),
              DetailRow(label: 'Fecha de registro', value: fmtDate(_t.fechaRegistro), readOnly: true),
            ]),
            const SizedBox(height: 16),
            if (_t.activo) AppButton(label: 'Inactivar tarifa', variant: AppButtonVariant.danger, onPressed: _inactivar),
          ]),
        ),
      ),
    );
  }
}
