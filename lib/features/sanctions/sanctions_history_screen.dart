import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import 'register_sanction_screen.dart';
import 'sanction_detail_screen.dart';

class SanctionsHistoryScreen extends StatelessWidget {
  const SanctionsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sanctions = context.watch<AppProvider>().sanctions;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de sanciones')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.navyPrimary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterSanctionScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sanctions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final item = sanctions[i];
          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(item.conductor, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: Text('${item.fechaInicio} - ${item.fechaFin}\nIdentificación: CC ${item.identificacion}', style: const TextStyle(fontSize: 12)),
            isThreeLine: true,
            trailing: StatusBadge(
              label: item.estado,
              type: item.estado == 'Vigente' ? BadgeType.success : BadgeType.warning,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SanctionDetailScreen(sanction: item))),
          );
        },
      ),
    );
  }
}
