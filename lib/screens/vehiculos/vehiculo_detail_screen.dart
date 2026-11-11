import 'package:flutter/material.dart';
import '../../models/user_session.dart';
import '../../config/formatters.dart';
import '../../models/vehiculo.dart';
import '../../services/mock_database.dart';
import '../../services/session_service.dart';
import '../../services/vehiculos_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/status_chip.dart';

/// 5.11.3 Ver detalle / 5.11.4 Edición de vehículo.
class VehiculoDetailScreen extends StatefulWidget {
  final String vehiculoId;
  const VehiculoDetailScreen({super.key, required this.vehiculoId});

  @override
  State<VehiculoDetailScreen> createState() => _VehiculoDetailScreenState();
}

class _VehiculoDetailScreenState extends State<VehiculoDetailScreen> {
  late Vehiculo _v;
  bool _editando = false;
  bool _loading = false;
  String? _conductorId, _tarifaId;
  EstadoVehiculo _estado = EstadoVehiculo.activo;

  @override
  void initState() {
    super.initState();
    _v = MockDatabase.instance.vehiculoById(widget.vehiculoId)!;
    _conductorId = _v.conductorId;
    _tarifaId = _v.tarifaId;
    _estado = _v.estado;
  }

  Future<void> _guardar() async {
    setState(() => _loading = true);
    _v.conductorId = _conductorId;
    _v.tarifaId = _tarifaId;
    _v.estado = _estado;
    await VehiculosService().actualizar(_v);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _editando = false;
    });
    AppSnackBar.success(context, 'Vehículo actualizado correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final esAdmin = SessionService.instance.currentUser?.role.isAdmin ?? false;
    final conductor = _v.conductorId == null ? null : db.conductorById(_v.conductorId!);
    final tarifa = _v.tarifaId == null ? null : db.tarifaById(_v.tarifaId!);
    final asignables = db.conductores.where((c) => c.activo && (!db.conductorSancionado(c.id) || c.id == _v.conductorId)).toList();

    return Scaffold(
      appBar: AppTopBar(title: _editando ? 'Editar vehículo' : 'Detalle del vehículo'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              InitialsAvatar(text: _v.tipo == 'Automóvil' ? '🚗' : '🚐'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${_v.placa} · ${_v.tipo}', style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  StatusChip(
                    label: _v.estado.label,
                    type: _v.estado == EstadoVehiculo.activo
                        ? ChipType.active
                        : (_v.estado == EstadoVehiculo.mantenimiento ? ChipType.warn : ChipType.inactive),
                  ),
                ]),
              ),
            ]),
            if (_editando) ...[
              const SectionLabel('Información editable'),
              AppDropdownField<String>(
                label: 'Conductor asignado',
                value: asignables.any((c) => c.id == _conductorId) ? _conductorId : null,
                items: asignables.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombres))).toList(),
                onChanged: (v) => setState(() => _conductorId = v),
              ),
              AppDropdownField<String>(
                label: 'Tarifa asignada',
                value: db.tarifas.any((t) => t.id == _tarifaId) ? _tarifaId : null,
                items: db.tarifas
                    .where((t) => t.activo)
                    .map((t) => DropdownMenuItem(value: t.id, child: Text('${t.nombre} · ${fmtMoney(t.total)}')))
                    .toList(),
                onChanged: (v) => setState(() => _tarifaId = v),
              ),
              AppDropdownField<EstadoVehiculo>(
                label: 'Estado',
                value: _estado,
                items: EstadoVehiculo.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
                onChanged: (v) => setState(() => _estado = v ?? _estado),
              ),
              AppButton(label: 'Guardar cambios', loading: _loading, onPressed: _guardar),
              AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => setState(() => _editando = false)),
            ] else ...[
              const SectionLabel('Información general'),
              DetailBlock(rows: [
                DetailRow(label: 'Marca / Modelo', value: '${_v.marca} · ${_v.modelo}'),
                DetailRow(label: 'Capacidad', value: '${_v.capacidad} pasajeros'),
                DetailRow(label: 'Conductor asignado', value: conductor?.nombres ?? 'Sin asignar'),
              ]),
              const SectionLabel('Documentación'),
              DetailBlock(rows: [
                DetailRow(label: 'Tarjeta de propiedad', value: _v.tarjetaPropiedad),
                DetailRow(label: 'Vigencia SOAT', value: fmtDate(_v.vigenciaSoat)),
                DetailRow(label: 'Vigencia TRM', value: fmtDate(_v.vigenciaTrm)),
              ]),
              const SectionLabel('Tarifa y registro'),
              DetailBlock(rows: [
                DetailRow(label: 'Tarifa asignada', value: tarifa == null ? '—' : '${tarifa.nombre} · ${fmtMoney(tarifa.total)}'),
                DetailRow(label: 'Fecha de ingreso', value: fmtDate(_v.fechaIngreso)),
                DetailRow(label: 'Fecha de registro', value: fmtDate(_v.fechaRegistro), readOnly: true),
                DetailRow(label: 'Última actualización', value: fmtDate(_v.ultimaActualizacion), readOnly: true),
              ]),
              if (esAdmin) ...[
                const SizedBox(height: 16),
                AppButton(label: 'Editar vehículo', onPressed: () => setState(() => _editando = true)),
              ],
            ],
          ]),
        ),
      ),
    );
  }
}
