import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/planilla.dart';
import '../../routes/app_routes.dart';
import '../../services/mock_database.dart';
import '../../services/planillas_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'generar_planillas_screen.dart';
import 'planilla_detail_screen.dart';

/// 5.13.1 Listado de planillas.
class PlanillasListScreen extends StatefulWidget {
  const PlanillasListScreen({super.key});

  @override
  State<PlanillasListScreen> createState() => _PlanillasListScreenState();
}

class _PlanillasListScreenState extends State<PlanillasListScreen> {
  final _service = PlanillasService();
  EstadoPlanilla? _filtro;
  late Future<List<Planilla>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar(estado: _filtro));

  ChipType _chip(EstadoPlanilla e) => e == EstadoPlanilla.pagada
      ? ChipType.active
      : (e == EstadoPlanilla.pendiente ? ChipType.warn : ChipType.danger);

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    return Scaffold(
      appBar: const AppTopBar(title: 'Planillas', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            FilterChipsRow<EstadoPlanilla?>(
              selected: _filtro,
              options: const [
                FilterOption('Todas', null),
                FilterOption('Pagadas', EstadoPlanilla.pagada),
                FilterOption('Pendientes', EstadoPlanilla.pendiente),
                FilterOption('Anuladas', EstadoPlanilla.anulada),
              ],
              onSelected: (f) {
                _filtro = f;
                _load();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Planilla>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SingleChildScrollView(child: LoadingStateView());
                  }
                  final lista = snap.data ?? [];
                  if (lista.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.receipt_long_rounded,
                      title: 'No hay planillas para mostrar',
                      message: 'Genera planillas para los vehículos del día.',
                      actionLabel: 'Generar planillas',
                      onAction: () => Navigator.of(context).pushNamed(AppRoutes.planillasGenerar),
                    );
                  }
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final p = lista[i];
                      final v = db.vehiculoById(p.vehiculoId);
                      final c = db.conductorById(p.conductorId);
                      return ListItemCard(
                        title: 'Planilla #${p.numero} · ${v?.placa ?? '—'}',
                        subtitle: '${fmtDate(p.fecha)} · ${p.hora} · ${c?.nombres ?? '—'}',
                        avatarText: '🧾',
                        trailing: StatusChip(label: p.estado.label, type: _chip(p.estado)),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => PlanillaDetailScreen(planillaId: p.id)),
                          );
                          _load();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GenerarPlanillasScreen()));
          _load();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.planillasList),
    );
  }
}
