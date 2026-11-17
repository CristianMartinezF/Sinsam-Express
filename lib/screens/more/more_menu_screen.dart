import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Afiliaciones', Icons.handshake_outlined, () => Navigator.pushNamed(context, AppRoutes.affiliations)),
      ('Detalle de Conductor', Icons.badge_outlined, () => Navigator.pushNamed(context, AppRoutes.driverDetail)),
      ('Registrar Conductor', Icons.person_add_outlined, () => Navigator.pushNamed(context, AppRoutes.registerDriver)),
      ('Historial de Sanciones', Icons.gavel_outlined, () => Navigator.pushNamed(context, AppRoutes.sanctions)),
      ('Rutas Operativas', Icons.alt_route_rounded, () => Navigator.pushNamed(context, AppRoutes.routesList)),
      ('Tarifas y Aportes', Icons.attach_money_rounded, () => Navigator.pushNamed(context, AppRoutes.fares)),
      ('Despachos y Mis Viajes', Icons.departure_board_rounded, () => Navigator.pushNamed(context, AppRoutes.dispatches)),
      ('Recargar datos desde API', Icons.sync_rounded, () => context.read<AppProvider>().fetchInitialData()),
      ('Cerrar sesión', Icons.logout_rounded, () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Más módulos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
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
