import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/vehiculo.dart';
import '../../services/mock_database.dart';
import '../../services/planillas_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.13.2 Generar planillas (masivo).
/// Excluye vehículos en mantenimiento y con conductor sancionado.
class GenerarPlanillasScreen extends StatefulWidget {
  const GenerarPlanillasScreen({super.key});

  @override
  State<GenerarPlanillasScreen> createState() => _GenerarPlanillasScreenState();
}

class _GenerarPlanillasScreenState extends State<GenerarPlanillasScreen> {
  DateTime _fecha = DateTime.now();
  String _tipo = 'Diaria';
  String? _tarifaId;
  final Set<String> _seleccion = {};
  bool _loading = false;

  bool _habilitado(Vehiculo v) {
    final db = MockDatabase.instance;
    if (v.estado != EstadoVehiculo.activo) return false;
    if (v.conductorId != null && db.conductorSancionado(v.conductorId!)) return false;
    return true;
  }

  String? _motivoBloqueo(Vehiculo v) {
    final db = MockDatabase.instance;
    if (v.estado != EstadoVehiculo.activo) return v.estado.label;
    if (v.conductorId != null && db.conductorSancionado(v.conductorId!)) return 'Conductor sancionado';
    return null;
  }

  Future<void> _generar() async {
    if (_seleccion.isEmpty || _tarifaId == null) {
      AppSnackBar.error(context, 'Selecciona una tarifa y al menos un vehículo.');
      return;
    }
    setState(() => _loading = true);
    final nuevas = await PlanillasService().generarMasivo(
      fecha: _fecha,
      vehiculoIds: _seleccion.toList(),
      tipo: _tipo,
      tarifaId: _tarifaId!,
    );
    if (!mounted) return;
    AppSnackBar.success(context, '${nuevas.length} planillas generadas correctamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final tarifas = db.tarifas.where((t) => t.activo).toList();
    return Scaffold(
      appBar: const AppTopBar(title: 'Generar planillas'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AppTextField(
              label: 'Fecha',
              readOnly: true,
              controller: TextEditingController(text: fmtDate(_fecha)),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _fecha,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                );
                if (d != null) setState(() => _fecha = d);
              },
            ),
            AppDropdownField<String>(
              label: 'Tipo de planilla',
              value: _tipo,
              items: const ['Diaria', 'Especial']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _tipo = v ?? 'Diaria'),
            ),
            AppDropdownField<String>(
              label: 'Tarifa a aplicar',
              hint: 'Seleccionar tarifa',
              value: _tarifaId,
              items: tarifas
                  .map((t) => DropdownMenuItem(value: t.id, child: Text('${t.nombre} · ${fmtMoney(t.total)}')))
                  .toList(),
              onChanged: (v) => setState(() => _tarifaId = v),
            ),
            SectionLabel('Vehículos (${_seleccion.length} seleccionados)'),
            DetailBlock(
              rows: db.vehiculos.map((v) {
                final conductor = v.conductorId == null ? null : db.conductorById(v.conductorId!);
                final bloqueo = _motivoBloqueo(v);
                return CheckboxListTile(
                  value: _seleccion.contains(v.id),
                  onChanged: _habilitado(v)
                      ? (sel) => setState(() => sel == true ? _seleccion.add(v.id) : _seleccion.remove(v.id))
                      : null,
                  title: Text('${v.placa} · ${conductor?.nombres ?? 'Sin conductor'}', style: const TextStyle(fontSize: 13)),
                  subtitle: bloqueo == null ? null : Text('No disponible: $bloqueo', style: const TextStyle(fontSize: 11)),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: _seleccion.isEmpty ? 'Generar planillas' : 'Generar ${_seleccion.length} planillas',
              loading: _loading,
              onPressed: _generar,
            ),
            AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
