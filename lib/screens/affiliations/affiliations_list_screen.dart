import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../services/app_provider.dart';
import '../../widgets/status_badge.dart';
import 'affiliation_detail_screen.dart';

class AffiliationsListScreen extends StatefulWidget {
  const AffiliationsListScreen({super.key});

  @override
  State<AffiliationsListScreen> createState() => _AffiliationsListScreenState();
}

class _AffiliationsListScreenState extends State<AffiliationsListScreen> {
  String _tab = 'Todos';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final list = provider.affiliations.where((a) {
      if (_tab == 'Vigentes') return a.vigente;
      if (_tab == 'Finalizadas') return !a.vigente;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Afiliados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: ['Todos', 'Vigentes', 'Finalizadas'].map((t) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: _tab == t,
                    onSelected: (_) => setState(() => _tab = t),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final aff = list[i];
                  return ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text('${aff.asociado} • ${aff.vehiculo}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(aff.vigente ? 'Desde ${aff.fechaInicio}' : '${aff.fechaInicio} - ${aff.fechaFin}'),
                    trailing: StatusBadge(
                      label: aff.vigente ? 'Vigente' : 'Finalizada',
                      type: aff.vigente ? BadgeType.success : BadgeType.danger,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AffiliationDetailScreen(affiliationId: aff.id)),
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
