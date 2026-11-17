import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_states.dart';
import '../../core/widgets/status_badge.dart';
import 'register_vehicle_screen.dart';
import 'vehicle_detail_screen.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.isLoading) {
      return Scaffold(appBar: AppBar(title: const Text('Vehiculos')), body: const SkeletonListView());
    }
    if (provider.hasServerError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vehiculos')),
        body: ServerErrorState(onRetry: () => provider.fetchInitialData()),
      );
    }

    final list = provider.vehicles
        .where((v) => v.placa.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Vehiculos')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.navyPrimary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterVehicleScreen())),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por placa',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final v = list[i];
                  return ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(
                      v.tipo.toLowerCase().contains('bus') ? Icons.directions_bus : Icons.local_taxi,
                      color: AppColors.navyPrimary,
                    ),
                    title: Text('${v.placa}  •  ${v.tipo}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${v.marcaModelo} • ${v.conductor}'),
                    trailing: StatusBadge(
                      label: v.estado,
                      type: v.estado == 'Activa' ? BadgeType.success : BadgeType.warning,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicleId: v.id)),
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
