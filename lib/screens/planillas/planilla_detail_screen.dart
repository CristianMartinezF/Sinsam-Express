import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/formatters.dart';
import '../../models/planilla.dart';
import '../../services/mock_database.dart';
import '../../services/planillas_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/status_chip.dart';

/// 5.13.3 Descargar PDF, 5.13.4 Anular planilla y 5.13.5 Pago de planillas.
class PlanillaDetailScreen extends StatefulWidget {
  final String planillaId;
  const PlanillaDetailScreen({super.key, required this.planillaId});

  @override
  State<PlanillaDetailScreen> createState() => _PlanillaDetailScreenState();
}

class _PlanillaDetailScreenState extends State<PlanillaDetailScreen> {
  final _service = PlanillasService();
  late Planilla _p;
  String _metodo = 'Efectivo';
  String? _motivo;
  bool _loading = false;

  static const _motivos = [
    'Vehículo fuera de servicio',
    'Error de digitación',
    'Conductor sancionado',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _p = MockDatabase.instance.planillas.firstWhere((x) => x.id == widget.planillaId);
  }

  Future<void> _pagar() async {
    setState(() => _loading = true);
    await _service.registrarPago(_p.id, metodoPago: _metodo);
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.success(context, 'Pago registrado con éxito.');
  }

  Future<void> _anular() async {
    if (_motivo == null) {
      AppSnackBar.error(context, 'Selecciona el motivo de anulación.');
      return;
    }
    final ok = await ConfirmDialog.show(
      context,
      title: '¿Anular la planilla #${_p.numero}?',
      message: 'El estado de la planilla pasará a “Anulada” y no podrá revertirse.',
      confirmLabel: 'Sí, anular planilla',
    );
    if (!ok) return;
    await _service.anular(_p.id, _motivo!);
    if (!mounted) return;
    setState(() {});
    AppSnackBar.success(context, 'Planilla anulada correctamente.');
  }

  void _descargar() {
    // En una fase con backend aquí se descargaría el PDF generado.
    AppSnackBar.success(context, 'Planilla planilla_${_p.numero}.pdf descargada correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final v = db.vehiculoById(_p.vehiculoId);
    final c = db.conductorById(_p.conductorId);
    final t = db.tarifaById(_p.tarifaId);
    final chip = _p.estado == EstadoPlanilla.pagada
        ? ChipType.active
        : (_p.estado == EstadoPlanilla.pendiente ? ChipType.warn : ChipType.danger);

    return Scaffold(
      appBar: AppTopBar(title: 'Planilla #${_p.numero}'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Align(alignment: Alignment.centerLeft, child: StatusChip(label: _p.estado.label, type: chip)),
            const SectionLabel('Planilla'),
            DetailBlock(rows: [
              DetailRow(label: 'Número', value: '#${_p.numero}'),
              DetailRow(label: 'Fecha', value: '${fmtDate(_p.fecha)} · ${_p.hora}'),
              DetailRow(label: 'Vehículo', value: v?.placa ?? '—'),
              DetailRow(label: 'Conductor', value: c?.nombres ?? '—'),
              DetailRow(label: 'Tipo', value: _p.tipo),
              DetailRow(label: 'Sentido', value: _p.sentido == SentidoRuta.ida ? 'Sincelejo → Sampués' : 'Sampués → Sincelejo'),
              DetailRow(label: 'Valor', value: t == null ? '—' : fmtMoney(t.total)),
            ]),
            if (_p.estado == EstadoPlanilla.pagada) ...[
              const SectionLabel('Pago'),
              DetailBlock(rows: [
                DetailRow(label: 'Fecha de pago', value: fmtDate(_p.fechaPago)),
                DetailRow(label: 'Método', value: _p.metodoPago ?? '—'),
              ]),
            ],
            if (_p.estado == EstadoPlanilla.anulada) ...[
              const SectionLabel('Anulación'),
              DetailBlock(rows: [DetailRow(label: 'Motivo', value: _p.motivoAnulacion ?? '—')]),
            ],
            const SizedBox(height: 16),
            AppButton(label: 'Descargar PDF', variant: AppButtonVariant.secondary, icon: Icons.download_rounded, onPressed: _descargar),
            if (_p.estado == EstadoPlanilla.pendiente) ...[
              const SectionLabel('Registrar pago'),
              AppDropdownField<String>(
                label: 'Método de pago',
                value: _metodo,
                items: const ['Efectivo', 'Transferencia']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (m) => setState(() => _metodo = m ?? 'Efectivo'),
              ),
              AppButton(label: 'Registrar pago', variant: AppButtonVariant.success, loading: _loading, onPressed: _pagar),
              const Divider(height: 28, color: AppColors.border),
              const SectionLabel('Anular planilla'),
              AppDropdownField<String>(
                label: 'Motivo de anulación',
                hint: 'Seleccionar motivo',
                value: _motivo,
                items: _motivos.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (m) => setState(() => _motivo = m),
              ),
              AppButton(label: 'Anular planilla', variant: AppButtonVariant.danger, onPressed: _anular),
            ],
          ]),
        ),
      ),
    );
  }
}
