import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';
import '../../widgets/status_badge.dart';
import 'fare_detail_screen.dart';

class FaresListScreen extends StatelessWidget {
  const FaresListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fares = context.watch<AppProvider>().fares;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.registerFare),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: fares.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final f = fares[i];
          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(child: Text('\$')),
            title: Text(f.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('Total: \$${f.total}'),
            trailing: StatusBadge(
              label: f.activa ? 'Activo' : 'Inactiva',
              type: f.activa ? BadgeType.success : BadgeType.danger,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FareDetailScreen(fareId: f.id))),
          );
        },
      ),
    );
  }
}
