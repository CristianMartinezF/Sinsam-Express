import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import 'edit_driver_screen.dart';

class DriverDetailScreen extends StatelessWidget {
  const DriverDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drivers = context.watch<AppProvider>().drivers;
    if (drivers.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del conductor')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No hay conductores registrados aún.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Registrar conductor',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.registerDriver),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final driver = drivers.first;
    final initials = driver.nombre.trim().split(' ').take(2).map((s) => s.isNotEmpty ? s[0] : '').join().toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del conductor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: CircleAvatar(child: Text(initials.isEmpty ? 'C' : initials)),
              title: Text(driver.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(
                  label: driver.estado,
                  type: driver.estado == 'Activo' ? BadgeType.success : BadgeType.danger,
                ),
              ),
            ),
            if (driver.estado == 'Sancionado') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dangerText.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Conductor sancionado\nNo puede ser asignado a operaciones de transporte mientras la sanción esté vigente.',
                  style: TextStyle(color: AppColors.dangerText, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text('INFORMACIÓN PERSONAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _DriverRow('Identificación', driver.identificacion),
                  _DriverRow('Fecha de nacimiento', driver.fechaNacimiento),
                  _DriverRow('Celular', driver.celular),
                  _DriverRow('Correo', driver.correo),
                  const Divider(),
                  _DriverRow('Licencia / Categoría', '${driver.numeroLicencia} • ${driver.categoria}'),
                  _DriverRow('Vigencia licencia', driver.vigenciaLicencia),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Editar',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditDriverScreen(driver: driver))),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: 'Ver historial de sanciones',
              isOutlined: true,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sanctions),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: 'Sancionar conductor',
              color: AppColors.dangerText,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.registerSanction),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  final String k, v;
  const _DriverRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
