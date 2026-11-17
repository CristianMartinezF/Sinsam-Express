import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../services/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class FareDetailScreen extends StatelessWidget {
  final String fareId;
  const FareDetailScreen({super.key, required this.fareId});

  void _confirmDeactivate(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Inactivar esta tarifa?'),
        content: const Text(
          'Al inactivar esta tarifa, los socios asociados dejarán de ser cobrados con estos valores. Esta acción puede revertirse activando la tarifa nuevamente.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerText, foregroundColor: Colors.white),
            onPressed: () {
              provider.toggleFareStatus(fareId);
              Navigator.pop(context);
            },
            child: const Text('Sí, inactivar tarifa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final fare = provider.fares.firstWhere((f) => f.id == fareId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarifa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _FRow('Aportes gastos varios', '\$${fare.gastosVarios}'),
                  _FRow('Fondo de reposición', '\$${fare.fondoReposicion}'),
                  _FRow('Aporte social del socio', '\$${fare.aporteSocial}'),
                  const Divider(),
                  _FRow('Total', '\$${fare.total}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado', style: TextStyle(color: AppColors.textSecondary)),
                      StatusBadge(
                        label: fare.activa ? 'Activa' : 'Inactiva',
                        type: fare.activa ? BadgeType.success : BadgeType.danger,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: fare.activa ? 'Inactivar tarifa' : 'Activar tarifa',
              color: fare.activa ? AppColors.dangerText : AppColors.successText,
              onPressed: () => fare.activa ? _confirmDeactivate(context, provider) : provider.toggleFareStatus(fareId),
            ),
          ],
        ),
      ),
    );
  }
}

class _FRow extends StatelessWidget {
  final String k, v;
  const _FRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
