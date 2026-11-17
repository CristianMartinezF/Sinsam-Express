import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';
import '../../widgets/status_badge.dart';
import 'sheet_detail_screen.dart';
import 'sheet_payment_screen.dart';

class SheetsListScreen extends StatelessWidget {
  const SheetsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sheets = context.watch<AppProvider>().sheets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planillas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.generateSheets),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sheets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = sheets[i];
          final badgeType = s.estado == 'Pagada'
              ? BadgeType.success
              : s.estado == 'Pendiente'
                  ? BadgeType.warning
                  : BadgeType.danger;

          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('Planilla ${s.numero}  •  ${s.placa}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${s.fecha} • \$${s.valor}'),
            trailing: StatusBadge(label: s.estado, type: badgeType),
            onTap: () {
              if (s.estado == 'Pendiente') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SheetPaymentScreen(sheet: s)));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SheetDetailScreen(sheet: s)));
              }
            },
          );
        },
      ),
    );
  }
}
