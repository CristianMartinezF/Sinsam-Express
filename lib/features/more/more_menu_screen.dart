import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_states.dart';
import '../affiliations/affiliations_list_screen.dart';
import '../dispatches/dispatches_list_screen.dart';
import '../drivers/driver_detail_screen.dart';
import '../drivers/register_driver_screen.dart';
import '../fares/fares_list_screen.dart';
import '../routes/routes_list_screen.dart';
import '../sanctions/sanctions_history_screen.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Afiliaciones', Icons.handshake_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AffiliationsListScreen()))),
      ('Detalle de Conductor', Icons.badge_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverDetailScreen()))),
      ('Registrar Conductor', Icons.person_add_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDriverScreen()))),
      ('Historial de Sanciones', Icons.gavel_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SanctionsHistoryScreen()))),
      ('Rutas Operativas', Icons.alt_route_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutesListScreen()))),
      ('Tarifas y Aportes', Icons.attach_money_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaresListScreen()))),
      ('Despachos y Mis Viajes', Icons.departure_board_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DispatchesListScreen()))),
      ('Simular Error de Servidor (API)', Icons.wifi_off_rounded, () => context.read<AppProvider>().fetchInitialData(simulateError: true)),
      ('Simular Sesión Expirada', Icons.lock_outline, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SessionExpiredScreen()))),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Más módulos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final (title, icon, onTap) = items[i];
          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            leading: Icon(icon, color: AppColors.navyPrimary),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
