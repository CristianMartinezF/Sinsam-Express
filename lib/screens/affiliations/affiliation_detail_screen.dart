import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../services/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class AffiliationDetailScreen extends StatelessWidget {
  final String affiliationId;
  const AffiliationDetailScreen({super.key, required this.affiliationId});

  void _confirmEndAffiliation(BuildContext context, AppProvider provider, String asociado, String vehiculo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Finalizar esta afiliacion?'),
        content: Text(
          'El vehiculo $vehiculo dejara de estar vinculado a $asociado. Esta accion quedara registrada.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerText, foregroundColor: Colors.white),
            onPressed: () {
              provider.endAffiliation(affiliationId);
              Navigator.pop(context);
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final aff = provider.affiliations.firstWhere((a) => a.id == affiliationId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de afiliacion')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('VINCULO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _RowItem('ID', aff.codigo),
                  _RowItem('Asociado', aff.asociado),
                  _RowItem('Vehiculo', aff.vehiculo),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado', style: TextStyle(color: AppColors.textSecondary)),
                      StatusBadge(
                        label: aff.vigente ? 'Vigente' : 'Finalizada',
                        type: aff.vigente ? BadgeType.success : BadgeType.danger,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('FECHAS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _RowItem('Fecha de afiliacion', aff.fechaInicio),
                  _RowItem('Fecha de fin', aff.fechaFin),
                  _RowItem('Fecha de registro', aff.fechaInicio),
                ],
              ),
            ),
            const Spacer(),
            if (aff.vigente)
              PrimaryButton(
                text: 'Finalizar afiliacion',
                isOutlined: true,
                color: AppColors.dangerText,
                onPressed: () => _confirmEndAffiliation(context, provider, aff.asociado, aff.vehiculo),
              ),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String k, v;
  const _RowItem(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
