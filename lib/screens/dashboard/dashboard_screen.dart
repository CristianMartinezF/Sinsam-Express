import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/user_session.dart';
import '../../routes/app_routes.dart';
import '../../services/mock_database.dart';
import '../../services/session_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/status_chip.dart';
import '../cuenta/mis_vehiculos_screen.dart';
import '../cuenta/viajes_screen.dart';

/// 5.6 Inicio / Dashboard.
/// Pantalla principal que se muestra después del inicio de sesión;
/// el contenido varía según el rol de la sesión activa.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.instance.currentUser;
    final role = session?.role ?? AppRole.asociado;

    Widget body;
    if (role.isAdmin) {
      body = const _AdminDashboard();
    } else if (role == AppRole.conductor) {
      body = const _ConductorDashboard();
    } else {
      body = const _AsociadoDashboard();
    }

    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.dashboard),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String role;
  const _DashboardHeader({required this.role});

  @override
  Widget build(BuildContext context) {
    final session = SessionService.instance.currentUser;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Buenos días,', style: TextStyle(color: Color(0xFFB9CBE2), fontSize: 12)),
                Text(session?.nombre ?? 'Usuario',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(role, style: const TextStyle(color: Color(0xFF8FAAC9), fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final ok = await ConfirmDialog.show(
                context,
                title: '¿Cerrar sesión?',
                message: 'Deberás volver a iniciar sesión para acceder a SinSam Express.',
                confirmLabel: 'Cerrar sesión',
              );
              if (ok && context.mounted) {
                SessionService.instance.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.neutral)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

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
              Icon(icon, color: AppColors.secondary),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _DashboardHeader(role: 'Administrador'),
        Transform.translate(
          offset: const Offset(0, -14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _SummaryBox(value: '${db.asociados.length}', label: 'Asociados activos')),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryBox(value: '${db.conductores.length}', label: 'Conductores')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _SummaryBox(value: '${db.vehiculos.length}', label: 'Vehículos afiliados')),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryBox(value: '${db.planillas.length}', label: 'Planillas del mes')),
                  ],
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Accesos rápidos', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.person_add_alt_1_rounded,
                      label: 'Afiliar asociado',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.asociadoForm),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.receipt_long_rounded,
                      label: 'Generar planillas',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.planillasGenerar),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.airport_shuttle_rounded,
                      label: 'Registrar vehículo',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.vehiculoForm),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.link_rounded,
                      label: 'Afiliaciones',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.afiliacionesList),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.gavel_rounded,
                      label: 'Sanciones',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.sancionesList),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.payments_outlined,
                      label: 'Tarifas',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.tarifasList),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.alt_route_rounded,
                      label: 'Despachos',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.despachosList),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.route_rounded,
                      label: 'Ruta',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.rutas),
                    ),
                    const SizedBox(width: 10),
                    _QuickAction(
                      icon: Icons.person_rounded,
                      label: 'Mi cuenta',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.miPerfil),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Despachos recientes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(height: 10),
                ListItemCard(
                  title: 'Ruta Sincelejo → Sampués',
                  subtitle: 'ABC-123 · 07:40 a.m.',
                  avatarText: '🚐',
                  trailing: const StatusChip(label: 'En ruta', type: ChipType.info),
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.despachosList),
                ),
                ListItemCard(
                  title: 'Ruta Sampués → Sincelejo',
                  subtitle: 'DEF-456 · 08:10 a.m.',
                  avatarText: '🚐',
                  trailing: const StatusChip(label: 'Programado', type: ChipType.warn),
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.despachosList),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConductorDashboard extends StatelessWidget {
  const _ConductorDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _DashboardHeader(role: 'Conductor'),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text('Mi vehículo y mis próximos viajes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ViajesContent(embedded: true),
        ),
      ],
    );
  }
}

class _AsociadoDashboard extends StatelessWidget {
  const _AsociadoDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _DashboardHeader(role: 'Asociado'),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text('Mis vehículos afiliados', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: MisVehiculosContent(embedded: true),
        ),
      ],
    );
  }
}
