import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/ruta.dart';
import '../../services/rutas_service.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';

/// 5.10 Consulta de rutas.
/// SinSam Express opera una única ruta: Sincelejo ↔ Sampués.
class RutasScreen extends StatelessWidget {
  const RutasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Ruta autorizada'),
      body: SafeArea(
        child: FutureBuilder<List<Ruta>>(
          future: RutasService().listar(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SingleChildScrollView(padding: EdgeInsets.all(16), child: LoadingStateView());
            }
            final rutas = snap.data ?? [];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...rutas.map((r) => ListItemCard(
                      title: r.nombre,
                      subtitle: 'Sentido de ${r.sentido.name} · Tarifa: ${fmtMoney(r.tarifa)} COP',
                      avatarText: '🛣️',
                      trailing: StatusChip(
                        label: r.activa ? 'Activa' : 'Inactiva',
                        type: r.activa ? ChipType.active : ChipType.inactive,
                      ),
                    )),
                const SizedBox(height: 8),
                const Text(
                  'SinSam Express opera una única ruta, en ambos sentidos: Sincelejo ↔ Sampués.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
