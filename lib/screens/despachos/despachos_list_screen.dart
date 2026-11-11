import 'package:flutter/material.dart';
import '../../models/despacho.dart';
import '../../models/planilla.dart';
import '../../services/despachos_service.dart';
import '../../services/mock_database.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'despacho_detail_screen.dart';
import 'despacho_form_screen.dart';

/// 5.14.1 Listado de despachos.
class DespachosListScreen extends StatefulWidget {
  const DespachosListScreen({super.key});

  @override
  State<DespachosListScreen> createState() => _DespachosListScreenState();
}

class _DespachosListScreenState extends State<DespachosListScreen> {
  final _service = DespachosService();
  late Future<List<Despacho>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar());

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    return Scaffold(
      appBar: const AppTopBar(title: 'Despachos'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Despacho>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SingleChildScrollView(child: LoadingStateView());
              }
              final lista = snap.data ?? [];
              if (lista.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.alt_route_rounded,
                  title: 'Sin despachos registrados',
                  message: 'Registra el primer despacho del día.',
                );
              }
              return ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, i) {
                  final d = lista[i];
                  final ida = d.sentido == SentidoRuta.ida;
                  return ListItemCard(
                    title: ida ? 'Sincelejo → Sampués' : 'Sampués → Sincelejo',
                    subtitle: '${db.vehiculoById(d.vehiculoId)?.placa ?? '—'} · ${d.hora} · ${d.numeroPasajeros} pasajeros',
                    avatarText: '🚦',
                    trailing: StatusChip(label: ida ? 'Ida' : 'Vuelta', type: ChipType.info),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DespachoDetailScreen(despachoId: d.id)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DespachoFormScreen()));
          _load();
        },
      ),
    );
  }
}
