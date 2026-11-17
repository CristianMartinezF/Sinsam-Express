import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/app_models.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class SheetDetailScreen extends StatelessWidget {
  final SheetModel sheet;
  const SheetDetailScreen({super.key, required this.sheet});

  void _showCancelSheetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Anular planilla ${sheet.numero}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const CustomInput(label: 'Motivo de anulación', hint: 'Seleccionar motivo'),
            const SizedBox(height: 12),
            const CustomInput(label: 'Observaciones (opcional)', hint: 'Detalle adicional...'),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Sí, anular planilla',
              color: AppColors.dangerText,
              onPressed: () {
                context.read<AppProvider>().cancelSheet(sheet.id);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planilla ${sheet.numero}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.dangerText, size: 34),
              title: Text('planilla_${sheet.numero.replaceAll('#', '')}_${sheet.placa}.pdf', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Generado ${sheet.fecha} - 210 KB'),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Descargar PDF',
              icon: Icons.download,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Planilla descargada correctamente')),
                );
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Compartir', icon: Icons.share, isOutlined: true, onPressed: () {}),
            const Spacer(),
            if (sheet.estado != 'Anulada')
              PrimaryButton(
                text: 'Anular planilla',
                color: AppColors.dangerText,
                onPressed: () => _showCancelSheetModal(context),
              ),
          ],
        ),
      ),
    );
  }
}
