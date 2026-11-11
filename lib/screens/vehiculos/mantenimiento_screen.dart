import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/vehiculo.dart';
import '../../services/mock_database.dart';
import '../../services/vehiculos_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.11.5 Ingreso / salida de mantenimiento.
class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  final _motivoCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();
  String? _vehiculoId;
  bool _loading = false;

  Vehiculo? get _v => _vehiculoId == null ? null : MockDatabase.instance.vehiculoById(_vehiculoId!);

  Future<void> _ingreso() async {
    if (_v == null || _motivoCtrl.text.isEmpty) {
      AppSnackBar.error(context, 'Selecciona un vehículo e indica el motivo.');
      return;
    }
    setState(() => _loading = true);
    _v!.estado = EstadoVehiculo.mantenimiento;
    _v!.motivoMantenimiento = _motivoCtrl.text;
    _v!.fechaSalidaMantenimiento = null;
    await VehiculosService().actualizar(_v!);
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.success(context, 'Ingreso a mantenimiento registrado.');
  }

  Future<void> _salida() async {
    if (_v == null || _v!.estado != EstadoVehiculo.mantenimiento) {
      AppSnackBar.error(context, 'El vehículo seleccionado no está en mantenimiento.');
      return;
    }
    setState(() => _loading = true);
    _v!.estado = EstadoVehiculo.activo;
    _v!.fechaSalidaMantenimiento = DateTime.now();
    await VehiculosService().actualizar(_v!);
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.success(context, 'Salida de mantenimiento registrada.');
  }

  @override
  Widget build(BuildContext context) {
    final vehiculos = MockDatabase.instance.vehiculos;
    return Scaffold(
      appBar: const AppTopBar(title: 'Mantenimiento de vehículo'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AppDropdownField<String>(
              label: 'Vehículo',
              hint: 'Seleccionar vehículo',
              value: _vehiculoId,
              items: vehiculos
                  .map((v) => DropdownMenuItem(value: v.id, child: Text('${v.placa} · ${v.tipo} (${v.estado.label})')))
                  .toList(),
              onChanged: (v) => setState(() {
                _vehiculoId = v;
                _motivoCtrl.text = _v?.motivoMantenimiento ?? '';
              }),
            ),
            AppTextField(label: 'Fecha de ingreso', readOnly: true, controller: TextEditingController(text: fmtDate(DateTime.now())), suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
            AppTextField(label: 'Motivo del mantenimiento', controller: _motivoCtrl, hint: 'Ej. Cambio de frenos'),
            AppTextField(label: 'Observaciones', controller: _obsCtrl, hint: 'Detalle adicional…', maxLines: 3),
            AppTextField(
              label: 'Fecha de salida',
              readOnly: true,
              hint: 'Pendiente',
              controller: TextEditingController(text: _v?.fechaSalidaMantenimiento == null ? '' : fmtDate(_v!.fechaSalidaMantenimiento)),
            ),
            AppButton(label: 'Registrar ingreso', loading: _loading, onPressed: _ingreso),
            AppButton(label: 'Registrar salida', variant: AppButtonVariant.success, onPressed: _loading ? null : _salida),
            AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
