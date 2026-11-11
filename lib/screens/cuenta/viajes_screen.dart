import 'package:flutter/material.dart';
import '../../models/despacho.dart';
import '../../models/planilla.dart';
import '../../routes/app_routes.dart';
import '../../services/despachos_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';

/// 5.16 Viajes (Despachos).
/// Los conductores y asociados consultan sus viajes con filtro
/// por periodo y placa.
class ViajesScreen extends StatelessWidget {
  const ViajesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis viajes'), automaticallyImplyLeading: false),
      body: const SafeArea(child: ViajesContent(embedded: false)),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.misViajes),
    );
  }
}

class ViajesContent extends StatefulWidget {
  final bool embedded;
  const ViajesContent({super.key, required this.embedded});

  @override
  State<ViajesContent> createState() => _ViajesContentState();
}

class _ViajesContentState extends State<ViajesContent> {
  final _service = DespachosService();
  late Future<List<Despacho>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.listar(placaVehiculo: 'ABC-123');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Despacho>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingStateView();
        }
        final viajes = snapshot.data ?? [];
        if (viajes.isEmpty) {
          return const EmptyStateView(
            title: 'No se encontraron viajes',
            message: 'Aún no hay despachos registrados para este vehículo.',
          );
        }
        final content = Column(
          children: viajes.map((d) {
            final esIda = d.sentido == SentidoRuta.ida;
            final titulo = esIda ? 'Sincelejo → Sampués' : 'Sampués → Sincelejo';
            return ListItemCard(
              title: titulo,
              subtitle: '${esIda ? 'Ida' : 'Vuelta'} · ${d.hora} · ${d.numeroPasajeros} pasajeros',
              avatarText: '🗺️',
              trailing: const StatusChip(label: 'Completado', type: ChipType.active),
            );
          }).toList(),
        );
        return widget.embedded ? content : Padding(padding: const EdgeInsets.all(16), child: content);
      },
    );
  }
}
