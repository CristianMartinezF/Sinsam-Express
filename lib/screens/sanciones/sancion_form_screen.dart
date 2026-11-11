import 'package:flutter/material.dart';
import '../../models/user_session.dart';
import '../../config/formatters.dart';
import '../../models/sancion.dart';
import '../../services/mock_database.dart';
import '../../services/sanciones_service.dart';
import '../../services/session_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.9.6 Registrar sanción (solo Gerente / Asistente).
class SancionFormScreen extends StatefulWidget {
  final String? conductorId;
  const SancionFormScreen({super.key, this.conductorId});

  @override
  State<SancionFormScreen> createState() => _SancionFormScreenState();
}

class _SancionFormScreenState extends State<SancionFormScreen> {
  final _service = SancionesService();
  final _obsCtrl = TextEditingController();
  String? _conductorId;
  String? _motivo;
  DateTime? _inicio, _fin;
  String? _error;
  bool _loading = false;

  static const _motivos = [
    'Documentación vencida',
    'Exceso de velocidad',
    'Reporte de usuario',
    'Incumplimiento de horarios',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _conductorId = widget.conductorId;
  }

  Future<void> _pick(bool inicio) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (d != null) setState(() => inicio ? _inicio = d : _fin = d);
  }

  Future<void> _guardar() async {
    final err = _service.validar(
      conductorId: _conductorId,
      fechaInicial: _inicio,
      fechaFinal: _fin,
      motivo: _motivo ?? '',
    );
    setState(() => _error = err);
    if (err != null) return;

    final db = MockDatabase.instance;
    final ok = await ConfirmDialog.show(
      context,
      title: '¿Confirmar sanción?',
      message:
          '${db.conductorById(_conductorId!)?.nombres} no podrá ser asignado a operaciones entre ${fmtDate(_inicio)} y ${fmtDate(_fin)}.',
      confirmLabel: 'Sí, registrar sanción',
    );
    if (!ok) return;

    setState(() => _loading = true);
    final user = SessionService.instance.currentUser;
    await _service.registrar(Sancion(
      id: 's${DateTime.now().millisecondsSinceEpoch}',
      conductorId: _conductorId!,
      fechaInicial: _inicio!,
      fechaFinal: _fin!,
      motivo: _motivo!,
      observaciones: _obsCtrl.text,
      registradoPor: '${user?.nombre ?? 'Usuario'} (${user?.role.label ?? ''})',
      fechaRegistro: DateTime.now(),
    ));
    if (!mounted) return;
    AppSnackBar.success(context, 'Sanción registrada exitosamente.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final conductores = MockDatabase.instance.conductores;
    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar sanción'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AppDropdownField<String>(
              label: 'Conductor',
              hint: 'Seleccionar conductor',
              value: _conductorId,
              items: conductores.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombres))).toList(),
              onChanged: (v) => setState(() => _conductorId = v),
            ),
            Row(children: [
              Expanded(
                child: AppTextField(
                  label: 'Fecha inicial',
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  controller: TextEditingController(text: _inicio == null ? '' : fmtDate(_inicio)),
                  onTap: () => _pick(true),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  label: 'Fecha final',
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  controller: TextEditingController(text: _fin == null ? '' : fmtDate(_fin)),
                  onTap: () => _pick(false),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
              ),
            ]),
            AppDropdownField<String>(
              label: 'Motivo de la sanción',
              hint: 'Seleccionar motivo',
              value: _motivo,
              items: _motivos.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _motivo = v),
            ),
            AppTextField(label: 'Observaciones (opcional)', controller: _obsCtrl, hint: 'Añadir observaciones…', maxLines: 3),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
              ),
            AppButton(label: 'Guardar sanción', variant: AppButtonVariant.danger, loading: _loading, onPressed: _guardar),
            AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
