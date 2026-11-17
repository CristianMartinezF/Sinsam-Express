import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';
import '../../widgets/status_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final activeAssociates = provider.associates.where((a) => a.activo).length;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.navyPrimary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Buenos dias,', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Text(
                  'Maria Pedrozo',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _KpiBox('$activeAssociates', 'Asociados activos'),
                    _KpiBox('${provider.drivers.length}', 'Conductores'),
                    _KpiBox('${provider.vehicles.length}', 'Vehiculos afiliados'),
                    _KpiBox('${provider.sheets.length}', 'Planillas este mes'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text('Accesorios rapidos', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuickCard(
                      icon: Icons.add,
                      label: 'Afiliar\nasociado',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.registerAssociate),
                    ),
                    const SizedBox(width: 10),
                    _QuickCard(
                      icon: Icons.edit_document,
                      label: 'Generar\nPlanilla',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.generateSheets),
                    ),
                    const SizedBox(width: 10),
                    _QuickCard(
                      icon: Icons.local_taxi,
                      label: 'Registrar\nvehiculos',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.registerVehicle),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'DESPACHOS RECIENTES',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                ...provider.dispatches.take(3).map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RecentDispatchCard(
                          'Ruta ${d.ruta}',
                          '${d.placa}  ${d.hora}',
                          d.estado,
                          d.estado == 'Despachado' ? BadgeType.success : BadgeType.warning,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiBox extends StatelessWidget {
  final String number;
  final String title;
  const _KpiBox(this.number, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColors.textPrimary),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentDispatchCard extends StatelessWidget {
  final String route;
  final String detail;
  final String status;
  final BadgeType type;
  const _RecentDispatchCard(this.route, this.detail, this.status, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_taxi, color: AppColors.navyPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(route, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(detail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          StatusBadge(label: status, type: type),
        ],
      ),
    );
  }
}
