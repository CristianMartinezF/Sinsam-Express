import 'package:flutter/material.dart';
import '../../models/conductor.dart';
import '../../routes/app_routes.dart';
import '../../services/conductores_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'conductor_detail_screen.dart';
import 'conductor_form_screen.dart';

/// Listado de conductores (soporte de navegación para 5.9.x).
class ConductoresListScreen extends StatefulWidget {
  const ConductoresListScreen({super.key});

  @override
  State<ConductoresListScreen> createState() => _ConductoresListScreenState();
}

class _ConductoresListScreenState extends State<ConductoresListScreen> {
  final _service = ConductoresService();
  final _searchCtrl = TextEditingController();
  late Future<List<Conductor>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar(query: _searchCtrl.text));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Conductores', showBack: false),
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
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Conductor>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SingleChildScrollView(child: LoadingStateView());
                    }
                    final lista = snapshot.data ?? [];
                    if (lista.isEmpty) {
                      return EmptyStateView(
                        title: 'No encontramos conductores',
                        message: 'Prueba con otro nombre o identificación.',
                        actionLabel: 'Limpiar búsqueda',
                        onAction: () {
                          _searchCtrl.clear();
                          _load();
                        },
                      );
                    }
                    return ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final c = lista[index];
                        final sancionado = _service.estaSancionado(c.id);
                        final iniciales = c.nombres.trim().split(' ').map((e) => e[0]).take(2).join();
                        return ListItemCard(
                          title: c.nombres,
                          subtitle: 'CC ${c.identificacion} · Lic. ${c.categoriaLicencia}',
                          avatarText: iniciales.toUpperCase(),
                          alert: sancionado,
                          trailing: StatusChip(
                            label: sancionado ? 'Sancionado' : 'Activo',
                            type: sancionado ? ChipType.danger : ChipType.active,
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ConductorDetailScreen(conductorId: c.id)),
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
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConductorFormScreen()));
          _load();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.conductoresList),
    );
  }
}
