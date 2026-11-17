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
  final _dateCtrl = TextEditingController();
  final Map<String, bool> _selected = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehicles = context.read<AppProvider>().vehicles;
    for (final v in vehicles) {
      final key = '${v.placa} ${v.conductor}';
      _selected.putIfAbsent(key, () => v.estado == 'Activa');
    }
  }

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
            CustomInput(label: 'Fecha', hint: 'dd/mm/aaaa', controller: _dateCtrl),
            const SizedBox(height: 12),
            const CustomInput(label: 'Tipo de planilla', hint: 'Diaria'),
            const SizedBox(height: 12),
            const CustomInput(label: 'Tarifa a aplicar', hint: 'Tarifa estándar'),
            const SizedBox(height: 16),
            Text('VEHÍCULOS (${activeList.length} SELECCIONADOS)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            if (_selected.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No hay vehículos disponibles desde la API.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              )
            else
              Expanded(
                child: ListView(
                  children: _selected.keys
                      .map((k) => CheckboxListTile(
                            title: Text(k, style: const TextStyle(fontSize: 13)),
                            value: _selected[k],
                            onChanged: (v) => setState(() => _selected[k] = v ?? false),
                          ))
                      .toList(),
                ),
              ),
            if (_selected.isEmpty) const Spacer(),
            PrimaryButton(
              text: 'Generar ${activeList.length} planillas',
              onPressed: () {
                if (activeList.isEmpty) return;
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
