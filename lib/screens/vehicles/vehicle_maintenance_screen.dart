import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class VehicleMaintenanceScreen extends StatelessWidget {
  final VehicleModel vehicle;
  const VehicleMaintenanceScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimiento de vehiculo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _MRow('Vehiculo', '${vehicle.placa} ${vehicle.tipo}'),
                  const _MRow('Fecha de ingreso', '-'),
                  const _MRow('Motivo de mantenimiento', 'Revisión preventiva'),
                  const _MRow('Observaciones', 'Sin observaciones'),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estado', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      StatusBadge(label: 'En mantenimiento', type: BadgeType.warning),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _MRow('Fecha de salida', 'Pendiente'),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(text: 'Registrar salida', onPressed: () => Navigator.pop(context)),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

class _MRow extends StatelessWidget {
  final String k, v;
  const _MRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
        ],
      ),
    );
  }
}
