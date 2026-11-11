import 'package:flutter/material.dart';
import '../../config/formatters.dart';
import '../../models/despacho.dart';
import '../../models/planilla.dart';
import '../../models/vehiculo.dart';
import '../../services/despachos_service.dart';
import '../../services/mock_database.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.14.2 Registrar despacho.
/// Solo existe una ruta autorizada (Sincelejo ↔ Sampués): se elige el sentido.
class DespachoFormScreen extends StatefulWidget {
  const DespachoFormScreen({super.key});

  @override
  State<DespachoFormScreen> createState() => _DespachoFormScreenState();
}

class _DespachoFormScreenState extends State<DespachoFormScreen> {
  final _pasajerosCtrl = TextEditingController();
  SentidoRuta _sentido = SentidoRuta.ida;
  String? _vehiculoId;
  DateTime _fecha = DateTime.now();
  TimeOfDay _hora = TimeOfDay.now();
  bool _loading = false;

  Future<void> _guardar() async {
    final pasajeros = int.tryParse(_pasajerosCtrl.text);
    if (_vehiculoId == null || pasajeros == null || pasajeros <= 0) {
      AppSnackBar.error(context, 'Selecciona un vehículo e indica el número de pasajeros.');
      return;
    }
    final v = MockDatabase.instance.vehiculoById(_vehiculoId!)!;
    if (pasajeros > v.capacidad) {
      AppSnackBar.error(context, 'El vehículo solo admite ${v.capacidad} pasajeros.');
      return;
    }
    setState(() => _loading = true);
    await DespachosService().registrar(Despacho(
      id: 'd${DateTime.now().millisecondsSinceEpoch}',
      sentido: _sentido,
      vehiculoId: _vehiculoId!,
      fecha: _fecha,
      hora: _hora.format(context),
      numeroPasajeros: pasajeros,
      fechaRegistro: DateTime.now(),
    ));
    if (!mounted) return;
    AppSnackBar.success(context, 'Despacho registrado exitosamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final disponibles = db.vehiculos
        .where((v) => v.estado == EstadoVehiculo.activo && (v.conductorId == null || !db.conductorSancionado(v.conductorId!)))
        .toList();
    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar despacho'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AppDropdownField<SentidoRuta>(
              label: 'Sentido de la ruta',
              value: _sentido,
              items: const [
                DropdownMenuItem(value: SentidoRuta.ida, child: Text('Sincelejo → Sampués')),
                DropdownMenuItem(value: SentidoRuta.vuelta, child: Text('Sampués → Sincelejo')),
              ],
              onChanged: (s) => setState(() => _sentido = s ?? SentidoRuta.ida),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'SinSam Express opera una única ruta autorizada: Sincelejo ↔ Sampués.',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ),
            AppDropdownField<String>(
              label: 'Vehículo',
              hint: 'Seleccionar vehículo',
              value: _vehiculoId,
              items: disponibles.map((v) => DropdownMenuItem(value: v.id, child: Text('${v.placa} · ${v.tipo}'))).toList(),
              onChanged: (v) => setState(() => _vehiculoId = v),
            ),
            Row(children: [
              Expanded(
                child: AppTextField(
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
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  label: 'Hora',
                  readOnly: true,
                  controller: TextEditingController(text: _hora.format(context)),
                  suffixIcon: const Icon(Icons.access_time, size: 18),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: _hora);
                    if (t != null) setState(() => _hora = t);
                  },
                ),
              ),
            ]),
            AppTextField(label: 'Número de pasajeros', controller: _pasajerosCtrl, hint: 'Ej. 14', keyboardType: TextInputType.number),
            AppButton(label: 'Guardar', loading: _loading, onPressed: _guardar),
            AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
