import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/formatters.dart';
import '../../models/tarifa.dart';
import '../../services/tarifas_service.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import 'tarifa_detail_screen.dart';
import 'tarifa_form_screen.dart';

/// 5.12.1 Listado de tarifas.
class TarifasListScreen extends StatefulWidget {
  const TarifasListScreen({super.key});

  @override
  State<TarifasListScreen> createState() => _TarifasListScreenState();
}

class _TarifasListScreenState extends State<TarifasListScreen> {
  final _service = TarifasService();
  late Future<List<Tarifa>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _future = _service.listar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Tarifas'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Tarifa>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SingleChildScrollView(child: LoadingStateView());
              }
              final lista = snap.data ?? [];
              if (lista.isEmpty) {
                return const EmptyStateView(title: 'Sin tarifas registradas', message: 'Registra una tarifa para poder asignarla a vehículos.');
              }
              return ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, i) {
                  final t = lista[i];
                  return ListItemCard(
                    title: t.nombre,
                    subtitle: 'Gastos varios + fondo + aporte social',
                    avatarText: '\$',
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusChip(label: t.activo ? 'Activa' : 'Inactiva', type: t.activo ? ChipType.active : ChipType.inactive),
                        const SizedBox(height: 4),
                        Text(fmtMoney(t.total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.primary)),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TarifaDetailScreen(tarifaId: t.id)));
                      _load();
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TarifaFormScreen()));
          _load();
        },
      ),
    );
  }
}
