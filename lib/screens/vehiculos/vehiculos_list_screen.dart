import 'package:flutter/material.dart';
import '../../models/vehiculo.dart';
import '../../routes/app_routes.dart';
import '../../services/vehiculos_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'vehiculo_detail_screen.dart';
import 'vehiculo_form_screen.dart';

/// 5.11.1 Listado de vehículos.
class VehiculosListScreen extends StatefulWidget {
  const VehiculosListScreen({super.key});

  @override
  State<VehiculosListScreen> createState() => _VehiculosListScreenState();
}

class _VehiculosListScreenState extends State<VehiculosListScreen> {
  final _service = VehiculosService();
  final _searchCtrl = TextEditingController();
  String _tipo = 'Todos';
  bool _forzarError = false;
  late Future<List<Vehiculo>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() {
        _future = _service.listar(placa: _searchCtrl.text, tipo: _tipo, forzarError: _forzarError);
      });

  ChipType _chip(EstadoVehiculo e) => e == EstadoVehiculo.activo
      ? ChipType.active
      : (e == EstadoVehiculo.mantenimiento ? ChipType.warn : ChipType.inactive);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Vehículos',
        showBack: false,
        action: IconButton(
          tooltip: 'Mantenimiento',
          icon: const Icon(Icons.build_outlined),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.vehiculoMantenimiento),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            SearchBarField(hint: 'Buscar por placa', controller: _searchCtrl, onChanged: (_) => _load()),
            FilterChipsRow<String>(
              selected: _tipo,
              options: const [
                FilterOption('Todos', 'Todos'),
                FilterOption('Bus', 'Bus'),
                FilterOption('Buseta', 'Buseta'),
                FilterOption('Automóvil', 'Automóvil'),
              ],
              onSelected: (t) {
                _tipo = t;
                _load();
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Vehiculo>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SingleChildScrollView(child: LoadingStateView());
                  }
                  if (snap.hasError) {
                    return ErrorStateView(onRetry: () {
                      _forzarError = false;
                      _load();
                    });
                  }
                  final lista = snap.data ?? [];
                  if (lista.isEmpty) {
                    return EmptyStateView(
                      title: 'No encontramos vehículos',
                      message: 'Prueba con otra placa o cambia el tipo de vehículo.',
                      actionLabel: 'Limpiar filtros',
                      onAction: () {
                        _searchCtrl.clear();
                        _tipo = 'Todos';
                        _load();
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, i) {
                      final v = lista[i];
                      return ListItemCard(
                        title: '${v.placa} · ${v.tipo}',
                        subtitle: '${v.marca} · ${v.modelo}',
                        avatarText: v.tipo == 'Automóvil' ? '🚗' : '🚐',
                        trailing: StatusChip(label: v.estado.label, type: _chip(v.estado)),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => VehiculoDetailScreen(vehiculoId: v.id)),
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
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VehiculoFormScreen()));
          _load();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.vehiculosList),
    );
  }
}
