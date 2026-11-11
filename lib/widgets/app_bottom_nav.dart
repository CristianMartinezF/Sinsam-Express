import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/user_session.dart';
import '../routes/app_routes.dart';
import '../services/session_service.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.label, this.route);
}

/// Barra de navegación inferior cuyos ítems cambian según el rol de la
/// sesión activa (Administrador = Gerente/Asistente, Conductor, Asociado).
class AppBottomNav extends StatelessWidget {
  final String currentRoute;

  const AppBottomNav({super.key, required this.currentRoute});

  List<_NavItem> _itemsFor(AppRole role) {
    if (role.isAdmin) {
      return const [
        _NavItem(Icons.home_rounded, 'Inicio', AppRoutes.dashboard),
        _NavItem(Icons.groups_rounded, 'Asociados', AppRoutes.asociadosList),
        _NavItem(Icons.airport_shuttle_rounded, 'Vehículos', AppRoutes.vehiculosList),
        _NavItem(Icons.receipt_long_rounded, 'Planillas', AppRoutes.planillasList),
        _NavItem(Icons.badge_rounded, 'Conductores', AppRoutes.conductoresList),
      ];
    } else if (role == AppRole.conductor) {
      return const [
        _NavItem(Icons.home_rounded, 'Inicio', AppRoutes.dashboard),
        _NavItem(Icons.map_rounded, 'Viajes', AppRoutes.misViajes),
        _NavItem(Icons.airport_shuttle_rounded, 'Vehículo', AppRoutes.misVehiculos),
        _NavItem(Icons.person_rounded, 'Mi cuenta', AppRoutes.miPerfil),
      ];
    } else {
      return const [
        _NavItem(Icons.home_rounded, 'Inicio', AppRoutes.dashboard),
        _NavItem(Icons.airport_shuttle_rounded, 'Mis vehículos', AppRoutes.misVehiculos),
        _NavItem(Icons.map_rounded, 'Viajes', AppRoutes.misViajes),
        _NavItem(Icons.person_rounded, 'Mi cuenta', AppRoutes.miPerfil),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = SessionService.instance.currentUser?.role ?? AppRole.asociado;
    final items = _itemsFor(role);
    final currentIndex = items.indexWhere((i) => i.route == currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.neutral,
      selectedFontSize: 10.5,
      unselectedFontSize: 10.5,
      showUnselectedLabels: true,
      onTap: (index) {
        final target = items[index].route;
        if (target == currentRoute) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          target,
          (route) => route.settings.name == AppRoutes.dashboard || route.isFirst,
        );
      },
      items: items
          .map((i) => BottomNavigationBarItem(icon: Icon(i.icon), label: i.label))
          .toList(),
    );
  }
}
