import 'package:flutter/material.dart';
import '../../models/asociado.dart';
import '../../services/asociados_service.dart';
import '../../services/mock_database.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/status_chip.dart';

/// 5.7.3 Ver detalle / 5.7.4 Edición de asociado.
/// Visualiza y permite actualizar la información completa del asociado.
class AsociadoDetailScreen extends StatefulWidget {
  final String asociadoId;
  const AsociadoDetailScreen({super.key, required this.asociadoId});

  @override
  State<AsociadoDetailScreen> createState() => _AsociadoDetailScreenState();
}

class _AsociadoDetailScreenState extends State<AsociadoDetailScreen> {
  final _service = AsociadosService();
  bool _editando = false;
  bool _loading = false;
  late Asociado _asociado;
  late TextEditingController _celularCtrl;
  late TextEditingController _correoCtrl;
  late TextEditingController _fechaNacCtrl;

  @override
  void initState() {
    super.initState();
    _asociado = MockDatabase.instance.asociadoById(widget.asociadoId)!;
    _celularCtrl = TextEditingController(text: _asociado.celular);
    _correoCtrl = TextEditingController(text: _asociado.correo);
    _fechaNacCtrl = TextEditingController(text: _formatDate(_asociado.fechaNacimiento));
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _guardarCambios() async {
    setState(() => _loading = true);
    _asociado.celular = _celularCtrl.text;
    _asociado.correo = _correoCtrl.text;
    await _service.actualizar(_asociado);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _editando = false;
    });
    AppSnackBar.success(context, 'Información actualizada correctamente.');
  }

  Future<void> _desafiliar() async {
    final ok = await ConfirmDialog.show(
      context,
      title: '¿Desafiliar a este asociado?',
      message: 'El estado de ${_asociado.nombreCompleto} cambiará a inactivo. Esta acción quedará registrada.',
      confirmLabel: 'Sí, desafiliar',
    );
    if (!ok) return;
    await _service.desafiliar(_asociado.id);
    if (!mounted) return;
    setState(() {});
    AppSnackBar.success(context, 'Asociado desafiliado correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    final iniciales = _asociado.nombreCompleto.trim().split(' ').map((e) => e[0]).take(2).join();

    return Scaffold(
      appBar: AppTopBar(
        title: _editando ? 'Editar asociado' : 'Detalle del asociado',
        action: _editando
            ? null
            : IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _editando = true)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InitialsAvatar(text: iniciales.toUpperCase()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_asociado.nombreCompleto, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        StatusChip(
                          label: _asociado.activo ? 'Activo' : 'Inactivo',
                          type: _asociado.activo ? ChipType.active : ChipType.inactive,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_editando) ...[
                const SectionLabel('Información editable'),
                AppTextField(label: 'Celular', controller: _celularCtrl, keyboardType: TextInputType.phone),
                AppTextField(label: 'Correo', controller: _correoCtrl, keyboardType: TextInputType.emailAddress),
                AppTextField(label: 'Fecha de nacimiento', controller: _fechaNacCtrl, suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
                const SizedBox(height: 8),
                AppButton(label: 'Guardar cambios', loading: _loading, onPressed: _guardarCambios),
                AppButton(
                  label: 'Cancelar',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => setState(() => _editando = false),
                ),
              ] else ...[
                const SectionLabel('Información personal'),
                DetailBlock(rows: [
                  DetailRow(label: 'Identificación', value: _asociado.identificacion),
                  DetailRow(label: 'Celular', value: _asociado.celular),
                  DetailRow(label: 'Correo', value: _asociado.correo),
                  DetailRow(label: 'Fecha de nacimiento', value: _formatDate(_asociado.fechaNacimiento)),
                ]),
                const SectionLabel('Vinculación'),
                DetailBlock(rows: [
                  DetailRow(label: 'Fecha de ingreso', value: _formatDate(_asociado.fechaIngreso)),
                  DetailRow(label: 'Placa del vehículo', value: _asociado.placaVehiculo ?? '-'),
                  DetailRow(label: 'Fecha de registro', value: _formatDate(_asociado.fechaRegistro), readOnly: true),
                  DetailRow(label: 'Última actualización', value: _formatDate(_asociado.ultimaActualizacion), readOnly: true),
                ]),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Editar asociado',
                  onPressed: () => setState(() => _editando = true),
                ),
                if (_asociado.activo)
                  AppButton(label: 'Desafiliar asociado', variant: AppButtonVariant.danger, onPressed: _desafiliar),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
