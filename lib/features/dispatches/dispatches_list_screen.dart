import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import 'dispatch_detail_screen.dart';
import 'register_dispatch_screen.dart';

class DispatchesListScreen extends StatelessWidget {
  const DispatchesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatches = context.watch<AppProvider>().dispatches;

    return Scaffold(
      appBar: AppBar(title: const Text('Despachos y Mis Viajes')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.navyPrimary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDispatchScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dispatches.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final d = dispatches[i];
          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(d.ruta, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${d.placa}  •  ${d.hora}'),
            trailing: StatusBadge(
              label: d.estado,
              type: d.estado == 'Despachado' ? BadgeType.success : BadgeType.warning,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DispatchDetailScreen(dispatch: d))),
          );
        },
      ),
    );
  }
}
