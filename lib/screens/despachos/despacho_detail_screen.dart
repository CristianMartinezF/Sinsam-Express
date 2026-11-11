import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/planilla.dart';
import '../../services/mock_database.dart';
import '../../widgets/misc_widgets.dart';

/// 5.14.3 Detalle de despacho.
class DespachoDetailScreen extends StatelessWidget {
  final String despachoId;
  const DespachoDetailScreen({super.key, required this.despachoId});

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final d = db.despachos.firstWhere((x) => x.id == despachoId);
    final ida = d.sentido == SentidoRuta.ida;
    return Scaffold(
      appBar: const AppTopBar(title: 'Detalle de despacho'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SectionLabel('Despacho'),
            DetailBlock(rows: [
              DetailRow(label: 'ID', value: d.id.toUpperCase()),
              DetailRow(label: 'Ruta', value: ida ? 'Sincelejo → Sampués (ida)' : 'Sampués → Sincelejo (vuelta)'),
              DetailRow(label: 'Vehículo', value: db.vehiculoById(d.vehiculoId)?.placa ?? '—'),
              DetailRow(label: 'Pasajeros', value: '${d.numeroPasajeros}'),
            ]),
            const SectionLabel('Fecha y hora'),
            DetailBlock(rows: [
              DetailRow(label: 'Fecha', value: fmtDate(d.fecha)),
              DetailRow(label: 'Hora', value: d.hora),
              DetailRow(label: 'Fecha de registro', value: fmtDate(d.fechaRegistro), readOnly: true),
            ]),
          ]),
        ),
      ),
    );
  }
}
