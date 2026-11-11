import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/sancion.dart';
import '../../services/mock_database.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';

/// 5.9.7 Detalle de sanción.
class SancionDetailScreen extends StatelessWidget {
  final String sancionId;
  const SancionDetailScreen({super.key, required this.sancionId});

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final s = db.sanciones.firstWhere((x) => x.id == sancionId);
    final c = db.conductorById(s.conductorId);
    final estado = s.estadoActual();
    return Scaffold(
      appBar: const AppTopBar(title: 'Detalle de sanción'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (estado == EstadoSancion.vigente)
              const InlineAlertBanner(
                title: 'Sanción vigente',
                message: 'El conductor no está disponible para nuevas asignaciones hasta que finalice el periodo.',
              ),
            const SectionLabel('Sanción'),
            DetailBlock(rows: [
              DetailRow(label: 'Conductor', value: c?.nombres ?? '—'),
              DetailRow(label: 'Identificación', value: c?.identificacion ?? '—'),
              DetailRow(label: 'Periodo', value: '${fmtDate(s.fechaInicial)} – ${fmtDate(s.fechaFinal)}'),
            ]),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(
                label: estado.label,
                type: estado == EstadoSancion.vigente
                    ? ChipType.danger
                    : (estado == EstadoSancion.programada ? ChipType.warn : ChipType.inactive),
              ),
            ),
            const SectionLabel('Detalle'),
            DetailBlock(rows: [
              DetailRow(label: 'Motivo', value: s.motivo),
              DetailRow(label: 'Observaciones', value: s.observaciones.isEmpty ? '—' : s.observaciones),
              DetailRow(label: 'Registrado por', value: s.registradoPor),
              DetailRow(label: 'Fecha de registro', value: fmtDate(s.fechaRegistro), readOnly: true),
            ]),
          ]),
        ),
      ),
    );
  }
}
