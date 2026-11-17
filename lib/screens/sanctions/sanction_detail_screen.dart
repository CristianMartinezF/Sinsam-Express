import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/app_models.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class SanctionDetailScreen extends StatelessWidget {
  final SanctionModel sanction;
  const SanctionDetailScreen({super.key, required this.sanction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de sanción')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Sanción vigente\nEl conductor no está disponible para nuevas asignaciones hasta que finalice el período.',
                style: TextStyle(color: AppColors.dangerText, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _SRow('Conductor', sanction.conductor),
                  _SRow('Identificación', sanction.identificacion),
                  _SRow('Período', '${sanction.fechaInicio} - ${sanction.fechaFin}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado', style: TextStyle(color: AppColors.textSecondary)),
                      StatusBadge(label: sanction.estado, type: BadgeType.danger),
                    ],
                  ),
                  const Divider(),
                  _SRow('Motivo', sanction.motivo),
                  _SRow('Observaciones', sanction.observaciones.isEmpty ? 'Sin observaciones' : sanction.observaciones),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(text: 'Volver', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

class _SRow extends StatelessWidget {
  final String k, v;
  const _SRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
