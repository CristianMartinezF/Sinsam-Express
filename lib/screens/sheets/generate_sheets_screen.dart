import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class GenerateSheetsScreen extends StatefulWidget {
  const GenerateSheetsScreen({super.key});

  @override
  State<GenerateSheetsScreen> createState() => _GenerateSheetsScreenState();
}

class _GenerateSheetsScreenState extends State<GenerateSheetsScreen> {
  final _dateCtrl = TextEditingController(text: '19/09/2026');
  final Map<String, bool> _selected = {
    'ABC-123 Diego Torres': true,
    'DEF-456 Carlos Andrade': true,
    'JKL-321 Luis Pardo': true,
  };

  @override
  Widget build(BuildContext context) {
    final activeList = _selected.entries.where((e) => e.value).map((e) => e.key).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Generar planillas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'Fecha', hint: '19/09/2026', controller: _dateCtrl),
            const SizedBox(height: 12),
            const CustomInput(label: 'Tipo de planilla', hint: 'Diaria'),
            const SizedBox(height: 12),
            const CustomInput(label: 'Tarifa a aplicar', hint: 'Tarifa estándar \$5.500'),
            const SizedBox(height: 16),
            Text('VEHÍCULOS (${activeList.length} SELECCIONADOS)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ..._selected.keys.map((k) => CheckboxListTile(
                  title: Text(k, style: const TextStyle(fontSize: 13)),
                  value: _selected[k],
                  onChanged: (v) => setState(() => _selected[k] = v ?? false),
                )),
            const CheckboxListTile(
              title: Text('GHI-789 En mantenimiento', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              value: false,
              onChanged: null,
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Generar ${activeList.length} planillas',
              onPressed: () {
                context.read<AppProvider>().generateSheets(activeList, _dateCtrl.text, 5500);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
