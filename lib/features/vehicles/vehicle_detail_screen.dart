import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_badge.dart';
import 'edit_vehicle_screen.dart';
import 'vehicle_maintenance_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final v = context.watch<AppProvider>().vehicles.firstWhere((item) => item.id == vehicleId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del vehiculo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('${v.placa}  •  ${v.tipo}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              trailing: StatusBadge(
                label: v.estado,
                type: v.estado == 'Activa' ? BadgeType.success : BadgeType.warning,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _VRow('Marca/Modelo', v.marcaModelo),
                  _VRow('Capacidad', '${v.capacidad} Pasajeros'),
                  _VRow('Conductor asignado', v.conductor),
                  const Divider(),
                  _VRow('Tarjeta de propiedad', v.tarjetaPropiedad),
                  _VRow('Vigencia Soat', v.soat),
                  _VRow('Vigencia TRM', v.trm),
                  const Divider(),
                  _VRow('Tarifa asignada', v.tarifa),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Editar vehiculo',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditVehicleScreen(vehicle: v))),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: 'Mantenimiento de vehiculo',
              isOutlined: true,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleMaintenanceScreen(vehicle: v))),
            ),
          ],
        ),
      ),
    );
  }
}

class _VRow extends StatelessWidget {
  final String k, v;
  const _VRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
