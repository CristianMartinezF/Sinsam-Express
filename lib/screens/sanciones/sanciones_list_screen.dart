import 'package:flutter/material.dart';
import '../../models/user_session.dart';
import '../../config/formatters.dart';
import '../../models/sancion.dart';
import '../../services/mock_database.dart';
import '../../services/sanciones_service.dart';
import '../../services/session_service.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'sancion_detail_screen.dart';
import 'sancion_form_screen.dart';

/// 5.9.5 Listado / historial de sanciones (opcionalmente de un conductor).
class SancionesListScreen extends StatefulWidget {
  final String? conductorId;
  const SancionesListScreen({super.key, this.conductorId});

  @override
  State<SancionesListScreen> createState() => _SancionesListScreenState();
}

class _SancionesListScreenState extends State<SancionesListScreen> {
  final _service = SancionesService();
  EstadoSancion? _filtro;
  late Future<List<Sancion>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar(estado: _filtro));

  ChipType _type(EstadoSancion e) => e == EstadoSancion.vigente
      ? ChipType.danger
      : (e == EstadoSancion.programada ? ChipType.warn : ChipType.inactive);

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final puedeRegistrar = SessionService.instance.currentUser?.role.isAdmin ?? false;
    return Scaffold(
      appBar: const AppTopBar(title: 'Historial de sanciones'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            FilterChipsRow<EstadoSancion?>(
              selected: _filtro,
              options: const [
                FilterOption('Todas', null),
                FilterOption('Vigentes', EstadoSancion.vigente),
                FilterOption('Programadas', EstadoSancion.programada),
                FilterOption('Finalizadas', EstadoSancion.finalizada),
              ],
              onSelected: (f) {
                _filtro = f;
                _load();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Sancion>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SingleChildScrollView(child: LoadingStateView());
                  }
                  final lista = (snap.data ?? [])
                      .where((s) => widget.conductorId == null || s.conductorId == widget.conductorId)
                      .toList();
                  if (lista.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.gavel_rounded,
                      title: 'Sin sanciones registradas',
                      message: 'No hay sanciones que coincidan con el filtro seleccionado.',
                    );
                  }
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final s = lista[i];
                      final estado = s.estadoActual();
                      return ListItemCard(
                        title: db.conductorById(s.conductorId)?.nombres ?? '—',
                        subtitle: '${fmtDate(s.fechaInicial)} – ${fmtDate(s.fechaFinal)} · ${s.motivo}',
                        avatarText: '⛔',
                        alert: estado == EstadoSancion.vigente,
                        trailing: StatusChip(label: estado.label, type: _type(estado)),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SancionDetailScreen(sancionId: s.id)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: puedeRegistrar
          ? AppFab(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SancionFormScreen(conductorId: widget.conductorId)),
                );
                _load();
              },
            )
          : null,
    );
  }
}
