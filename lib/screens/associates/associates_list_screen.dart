import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';
import '../../widgets/app_states.dart';
import '../../widgets/status_badge.dart';
import 'associate_detail_screen.dart';

class AssociatesListScreen extends StatefulWidget {
  const AssociatesListScreen({super.key});

  @override
  State<AssociatesListScreen> createState() => _AssociatesListScreenState();
}

class _AssociatesListScreenState extends State<AssociatesListScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.isLoading) {
      return Scaffold(appBar: AppBar(title: const Text('Asociados')), body: const SkeletonListView());
    }
    if (provider.hasServerError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asociados')),
        body: ServerErrorState(onRetry: () => provider.fetchInitialData()),
      );
    }

    final filtered = provider.associates.where((e) {
      final q = _searchCtrl.text.toLowerCase();
      final match = e.nombre.toLowerCase().contains(q) || e.identificacion.toLowerCase().contains(q);
      if (_filter == 'Activos') return match && e.activo;
      if (_filter == 'Inactivos') return match && !e.activo;
      return match;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asociados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.registerAssociate),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por identificacion o nombre',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['Todos', 'Activos', 'Inactivos'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('"${_searchCtrl.text}" - Sin coincidencias', style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          const Text(
                            'No encontramos asociados\nPrueba con otro nombre o otro numero de identificacion',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _filter = 'Todos');
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final item = filtered[i];
                        final initials = item.nombre.trim().split(' ').take(2).map((s) => s.isNotEmpty ? s[0] : '').join().toUpperCase();
                        return ListTile(
                          tileColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          leading: CircleAvatar(child: Text(initials)),
                          title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: Text('CC ${item.identificacion}', style: const TextStyle(fontSize: 12)),
                          trailing: StatusBadge(
                            label: item.activo ? 'Activo' : 'Inactivo',
                            type: item.activo ? BadgeType.success : BadgeType.danger,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AssociateDetailScreen(associateId: item.id)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
