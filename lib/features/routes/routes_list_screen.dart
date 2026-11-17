import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Sincelejo - Sampués', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text('Sentido de ida - Tarifa: \$8.500'),
            trailing: const StatusBadge(label: 'Activa', type: BadgeType.success),
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Sampués - Sincelejo', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text('Sentido de vuelta - Tarifa: \$8.500'),
            trailing: const StatusBadge(label: 'Activa', type: BadgeType.success),
          ),
        ],
      ),
    );
  }
}
