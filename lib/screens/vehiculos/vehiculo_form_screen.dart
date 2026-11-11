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

/// 5.11.2 Registrar vehículo.
/// Los conductores con sanción vigente no aparecen como asignables.
class VehiculoFormScreen extends StatefulWidget {
  const VehiculoFormScreen({super.key});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _capCtrl = TextEditingController();
  final _tpCtrl = TextEditingController();
  String _tipo = 'Buseta';
  String? _conductorId;
  String? _tarifaId;
  DateTime? _soat, _trm, _ingreso;
  bool _loading = false;

  Future<DateTime?> _pick() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
      );

  Widget _dateField(String label, DateTime? value, ValueChanged<DateTime> onPick) => AppTextField(
        label: label,
        hint: 'dd/mm/aaaa',
        readOnly: true,
        controller: TextEditingController(text: value == null ? '' : fmtDate(value)),
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        onTap: () async {
          final d = await _pick();
          if (d != null) setState(() => onPick(d));
        },
        validator: (_) => value == null ? 'Selecciona una fecha' : null,
      );

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await VehiculosService().registrar(Vehiculo(
      id: 'v${DateTime.now().millisecondsSinceEpoch}',
      placa: _placaCtrl.text.toUpperCase(),
      tipo: _tipo,
      marca: _marcaCtrl.text,
      modelo: _modeloCtrl.text,
      capacidad: int.tryParse(_capCtrl.text) ?? 0,
      tarjetaPropiedad: _tpCtrl.text,
      conductorId: _conductorId,
      tarifaId: _tarifaId,
      estado: EstadoVehiculo.activo,
      vigenciaSoat: _soat!,
      vigenciaTrm: _trm!,
      fechaIngreso: _ingreso!,
      fechaRegistro: DateTime.now(),
      ultimaActualizacion: DateTime.now(),
    ));
    if (!mounted) return;
    AppSnackBar.success(context, 'Vehículo registrado exitosamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final conductores = db.conductores.where((c) => c.activo && !db.conductorSancionado(c.id)).toList();
    final tarifas = db.tarifas.where((t) => t.activo).toList();
    String req(String? v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : '';

    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar vehículo'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              AppTextField(
                label: 'Placa',
                controller: _placaCtrl,
                hint: 'Ej. ABC-123',
                validator: (v) => req(v).isEmpty ? null : req(v),
              ),
              AppDropdownField<String>(
                label: 'Conductor asignado',
                hint: 'Seleccionar conductor',
                value: _conductorId,
                items: conductores.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombres))).toList(),
                onChanged: (v) => setState(() => _conductorId = v),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Los conductores sancionados no se muestran como asignables.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ),
              Row(children: [
                Expanded(
                  child: AppDropdownField<String>(
                    label: 'Tipo',
                    value: _tipo,
                    items: const ['Bus', 'Buseta', 'Automóvil']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _tipo = v ?? 'Buseta'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(label: 'Capacidad', controller: _capCtrl, hint: 'N° pasajeros', keyboardType: TextInputType.number),
                ),
              ]),
              Row(children: [
                Expanded(child: AppTextField(label: 'Marca', controller: _marcaCtrl, hint: 'Ej. Chevrolet')),
                const SizedBox(width: 10),
                Expanded(child: AppTextField(label: 'Modelo', controller: _modeloCtrl, hint: 'Ej. 2022')),
              ]),
              AppTextField(label: 'Tarjeta de propiedad', controller: _tpCtrl, hint: 'N° de tarjeta de propiedad'),
              AppDropdownField<String>(
                label: 'Tarifa asignada',
                hint: 'Seleccionar tarifa',
                value: _tarifaId,
                items: tarifas
                    .map((t) => DropdownMenuItem(value: t.id, child: Text('${t.nombre} · ${fmtMoney(t.total)}')))
                    .toList(),
                onChanged: (v) => setState(() => _tarifaId = v),
              ),
              Row(children: [
                Expanded(child: _dateField('Vigencia SOAT', _soat, (d) => _soat = d)),
                const SizedBox(width: 10),
                Expanded(child: _dateField('Vigencia TRM', _trm, (d) => _trm = d)),
              ]),
              _dateField('Fecha de ingreso', _ingreso, (d) => _ingreso = d),
              const SizedBox(height: 6),
              AppButton(label: 'Guardar', loading: _loading, onPressed: _guardar),
              AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
            ]),
          ),
        ),
      ),
    );
  }
}
