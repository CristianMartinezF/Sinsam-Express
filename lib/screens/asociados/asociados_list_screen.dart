import 'package:flutter/material.dart';
import '../../models/asociado.dart';
import '../../routes/app_routes.dart';
import '../../services/asociados_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'asociado_detail_screen.dart';
import 'asociado_form_screen.dart';

/// 5.7.1 Listado de asociados.
/// Permite consultar los asociados registrados mediante búsqueda y filtros.
class AsociadosListScreen extends StatefulWidget {
  const AsociadosListScreen({super.key});

  @override
  State<AsociadosListScreen> createState() => _AsociadosListScreenState();
}

enum _Filtro { todos, activos, inactivos }

class _AsociadosListScreenState extends State<AsociadosListScreen> {
  final _service = AsociadosService();
  final _searchCtrl = TextEditingController();
  _Filtro _filtro = _Filtro.todos;
  bool _forzarError = false;
  late Future<List<Asociado>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    bool? soloActivos;
    if (_filtro == _Filtro.activos) soloActivos = true;
    if (_filtro == _Filtro.inactivos) soloActivos = false;
    setState(() {
      _future = _service.listar(
        query: _searchCtrl.text,
        soloActivos: soloActivos,
        forzarError: _forzarError,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Asociados',
        showBack: false,
        action: IconButton(
          tooltip: 'Simular error de carga (demostración)',
          icon: Icon(_forzarError ? Icons.bug_report : Icons.bug_report_outlined),
          onPressed: () {
            _forzarError = !_forzarError;
            _load();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarField(
                hint: 'Buscar por identificación o nombre',
                controller: _searchCtrl,
                onChanged: (_) => _load(),
              ),
              FilterChipsRow<_Filtro>(
                selected: _filtro,
                options: const [
                  FilterOption('Todos', _Filtro.todos),
                  FilterOption('Activos', _Filtro.activos),
                  FilterOption('Inactivos', _Filtro.inactivos),
                ],
                onSelected: (f) {
                  _filtro = f;
                  _load();
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Asociado>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SingleChildScrollView(child: LoadingStateView());
                    }
                    if (snapshot.hasError) {
                      return SingleChildScrollView(
                        child: ErrorStateView(onRetry: () {
                          _forzarError = false;
                          _load();
                        }),
                      );
                    }
                    final asociados = snapshot.data ?? [];
                    if (asociados.isEmpty) {
                      return SingleChildScrollView(
                        child: EmptyStateView(
                          title: 'No encontramos asociados',
                          message: 'Prueba con otro nombre o número de identificación, o ajusta los filtros aplicados.',
                          actionLabel: 'Limpiar filtros',
                          onAction: () {
                            _searchCtrl.clear();
                            _filtro = _Filtro.todos;
                            _load();
                          },
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: asociados.length,
                      itemBuilder: (context, index) {
                        final a = asociados[index];
                        final iniciales = a.nombreCompleto.trim().split(' ').map((e) => e[0]).take(2).join();
                        return ListItemCard(
                          title: a.nombreCompleto,
                          subtitle: 'CC ${a.identificacion}',
                          avatarText: iniciales.toUpperCase(),
                          trailing: StatusChip(
                            label: a.activo ? 'Activo' : 'Inactivo',
                            type: a.activo ? ChipType.active : ChipType.inactive,
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AsociadoDetailScreen(asociadoId: a.id)),
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
      floatingActionButton: AppFab(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AsociadoFormScreen()),
          );
          _load();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.asociadosList),
    );
  }
}
