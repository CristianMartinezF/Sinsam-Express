import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../services/app_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import 'edit_associate_screen.dart';

class AssociateDetailScreen extends StatelessWidget {
  final String associateId;
  const AssociateDetailScreen({super.key, required this.associateId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final item = provider.associates.firstWhere((a) => a.id == associateId);
    final initials = item.nombre.trim().split(' ').take(2).map((s) => s.isNotEmpty ? s[0] : '').join().toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del asociado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: CircleAvatar(child: Text(initials.isEmpty ? 'A' : initials)),
              title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(
                  label: item.activo ? 'Activo' : 'Inactivo',
                  type: item.activo ? BadgeType.success : BadgeType.danger,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('INFORMACIÓN PERSONAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            _card([
              _row('Identificación', item.identificacion),
              _row('Celular', item.celular),
              _row('Correo', item.correo),
              _row('Fecha de nacimiento', item.fechaNacimiento),
            ]),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Editar asociado',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditAssociateScreen(associate: item)),
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: item.activo ? 'Desactivar asociado' : 'Reactivar asociado',
              isOutlined: true,
              color: item.activo ? AppColors.dangerText : AppColors.successText,
              onPressed: () => provider.toggleAssociateStatus(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(children: children),
      );

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          ],
        ),
      );
}