import 'package:flutter/material.dart';
import '../../models/afiliacion.dart';
import '../../services/afiliaciones_service.dart';
import '../../services/mock_database.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/status_chip.dart';

/// 5.8.2 Ver detalle / 5.8.3 Desafiliar.
class AfiliacionDetailScreen extends StatefulWidget {
  final String afiliacionId;
  const AfiliacionDetailScreen({super.key, required this.afiliacionId});

  @override
  State<AfiliacionDetailScreen> createState() => _AfiliacionDetailScreenState();
}

class _AfiliacionDetailScreenState extends State<AfiliacionDetailScreen> {
  final _service = AfiliacionesService();
  late Afiliacion _afiliacion;

  @override
  void initState() {
    super.initState();
    _afiliacion = MockDatabase.instance.afiliaciones.firstWhere((a) => a.id == widget.afiliacionId);
  }

  String _fmt(DateTime? d) => d == null
      ? '—'
      : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _finalizar() async {
    final db = MockDatabase.instance;
    final vehiculo = db.vehiculoById(_afiliacion.vehiculoId);
    final asociado = db.asociadoById(_afiliacion.asociadoId);
    final ok = await ConfirmDialog.show(
      context,
      title: '¿Finalizar esta afiliación?',
      message: 'El vehículo ${vehiculo?.placa ?? ''} dejará de estar vinculado a ${asociado?.nombreCompleto ?? ''}. Esta acción quedará registrada.',
      confirmLabel: 'Sí, finalizar afiliación',
    );
    if (!ok) return;
    await _service.finalizar(_afiliacion.id);
    if (!mounted) return;
    setState(() {});
    AppSnackBar.success(context, 'Afiliación finalizada correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final asociado = db.asociadoById(_afiliacion.asociadoId);
    final vehiculo = db.vehiculoById(_afiliacion.vehiculoId);
    final vigente = _afiliacion.estado == EstadoAfiliacion.vigente;

    return Scaffold(
      appBar: const AppTopBar(title: 'Detalle de afiliación'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('Vínculo'),
              DetailBlock(rows: [
                DetailRow(label: 'ID', value: _afiliacion.id.toUpperCase()),
                DetailRow(label: 'Asociado', value: asociado?.nombreCompleto ?? '—'),
                DetailRow(label: 'Vehículo', value: vehiculo?.placa ?? '—'),
              ]),
              const SectionLabel('Fechas y estado'),
              DetailBlock(rows: [
                DetailRow(label: 'Fecha de afiliación', value: _fmt(_afiliacion.fechaAfiliacion)),
                DetailRow(label: 'Fecha de fin', value: _fmt(_afiliacion.fechaFin)),
                DetailRow(label: 'Fecha de registro', value: _fmt(_afiliacion.fechaRegistro), readOnly: true),
                DetailRow(label: 'Última actualización', value: _fmt(_afiliacion.ultimaActualizacion), readOnly: true),
              ]),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: StatusChip(
                  label: _afiliacion.estado.label,
                  type: vigente ? ChipType.active : ChipType.inactive,
                ),
              ),
              const SizedBox(height: 16),
              if (vigente)
                AppButton(label: 'Finalizar afiliación', variant: AppButtonVariant.danger, onPressed: _finalizar),
            ],
          ),
        ),
      ),
    );
  }
}
