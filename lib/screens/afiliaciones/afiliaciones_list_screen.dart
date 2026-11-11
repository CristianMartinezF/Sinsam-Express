import 'package:flutter/material.dart';
import '../../models/afiliacion.dart';
import '../../services/afiliaciones_service.dart';
import '../../services/mock_database.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'afiliacion_detail_screen.dart';

/// 5.8.1 Listado de afiliaciones.
/// Consulta y filtra las relaciones entre asociados y vehículos.
class AfiliacionesListScreen extends StatefulWidget {
  const AfiliacionesListScreen({super.key});

  @override
  State<AfiliacionesListScreen> createState() => _AfiliacionesListScreenState();
}

class _AfiliacionesListScreenState extends State<AfiliacionesListScreen> {
  final _service = AfiliacionesService();
  EstadoAfiliacion? _filtro;
  late Future<List<Afiliacion>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar(estado: _filtro));

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    return Scaffold(
      appBar: const AppTopBar(title: 'Afiliaciones'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FilterChipsRow<EstadoAfiliacion?>(
                selected: _filtro,
                options: const [
                  FilterOption('Todas', null),
                  FilterOption('Vigentes', EstadoAfiliacion.vigente),
                  FilterOption('Finalizadas', EstadoAfiliacion.finalizada),
                ],
                onSelected: (f) {
                  _filtro = f;
                  _load();
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Afiliacion>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SingleChildScrollView(child: LoadingStateView());
                    }
                    final lista = snapshot.data ?? [];
                    if (lista.isEmpty) {
                      return const SingleChildScrollView(
                        child: EmptyStateView(
                          title: 'No hay afiliaciones para mostrar',
                          message: 'Ajusta los filtros para ver otras afiliaciones.',
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final af = lista[index];
                        final asociado = db.asociadoById(af.asociadoId);
                        final vehiculo = db.vehiculoById(af.vehiculoId);
                        return ListItemCard(
                          title: '${asociado?.nombreCompleto ?? '—'} · ${vehiculo?.placa ?? '—'}',
                          subtitle: 'Desde ${_fmt(af.fechaAfiliacion)}',
                          avatarText: '🔗',
                          trailing: StatusChip(
                            label: af.estado.label,
                            type: af.estado == EstadoAfiliacion.vigente ? ChipType.active : ChipType.inactive,
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AfiliacionDetailScreen(afiliacionId: af.id)),
                            );
                            _load();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
