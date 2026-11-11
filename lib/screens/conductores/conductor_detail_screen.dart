import 'package:flutter/material.dart';
import '../../models/user_session.dart';
import '../../config/formatters.dart';
import '../../models/conductor.dart';
import '../../services/conductores_service.dart';
import '../../services/mock_database.dart';
import '../../services/session_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import '../sanciones/sancion_form_screen.dart';
import '../sanciones/sanciones_list_screen.dart';

/// 5.9.2 Ver detalle / 5.9.3 Edición de conductor.
class ConductorDetailScreen extends StatefulWidget {
  final String conductorId;
  const ConductorDetailScreen({super.key, required this.conductorId});

  @override
  State<ConductorDetailScreen> createState() => _ConductorDetailScreenState();
}

class _ConductorDetailScreenState extends State<ConductorDetailScreen> {
  late Conductor _c;
  late TextEditingController _celCtrl, _correoCtrl, _licCtrl;
  bool _editando = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _c = MockDatabase.instance.conductorById(widget.conductorId)!;
    _celCtrl = TextEditingController(text: _c.celular);
    _correoCtrl = TextEditingController(text: _c.correo);
    _licCtrl = TextEditingController(text: _c.numeroLicencia);
  }

  Future<void> _guardar() async {
    setState(() => _loading = true);
    _c.celular = _celCtrl.text;
    _c.correo = _correoCtrl.text;
    _c.numeroLicencia = _licCtrl.text;
    await ConductoresService().actualizar(_c);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _editando = false;
    });
    AppSnackBar.success(context, 'Conductor actualizado correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase.instance;
    final puedeSancionar = SessionService.instance.currentUser?.role.isAdmin ?? false;
    final vigente = db.sancionesDeConductor(_c.id).where((s) => s.estadoActual().name == 'vigente');
    final sancion = vigente.isEmpty ? null : vigente.first;

    return Scaffold(
      appBar: AppTopBar(
        title: _editando ? 'Editar conductor' : 'Detalle del conductor',
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
              Row(children: [
                InitialsAvatar(text: iniciales(_c.nombres)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_c.nombres, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    StatusChip(label: _c.activo ? 'Activo' : 'Inactivo', type: _c.activo ? ChipType.active : ChipType.inactive),
                  ]),
                ),
              ]),
              const SizedBox(height: 14),
              if (sancion != null)
                InlineAlertBanner(
                  title: 'Sancionado hasta ${fmtDate(sancion.fechaFinal)}',
                  message: 'No puede ser asignado a operaciones de transporte mientras la sanción esté vigente.',
                ),
              if (_editando) ...[
                AppTextField(label: 'Celular', controller: _celCtrl),
                AppTextField(label: 'Correo', controller: _correoCtrl),
                AppTextField(label: 'Número de licencia', controller: _licCtrl),
                AppButton(label: 'Guardar cambios', loading: _loading, onPressed: _guardar),
                AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary, onPressed: () => setState(() => _editando = false)),
              ] else ...[
                const SectionLabel('Información personal'),
                DetailBlock(rows: [
                  DetailRow(label: 'Identificación', value: _c.identificacion),
                  DetailRow(label: 'Fecha de nacimiento', value: fmtDate(_c.fechaNacimiento)),
                  DetailRow(label: 'Celular', value: _c.celular),
                  DetailRow(label: 'Correo', value: _c.correo),
                ]),
                const SectionLabel('Licencia de conducción'),
                DetailBlock(rows: [
                  DetailRow(label: 'Número', value: _c.numeroLicencia),
                  DetailRow(label: 'Categoría', value: _c.categoriaLicencia),
                  DetailRow(label: 'Vigencia', value: fmtDate(_c.vigenciaLicencia)),
                ]),
                const SectionLabel('Registro'),
                DetailBlock(rows: [
                  DetailRow(label: 'Fecha de registro', value: fmtDate(_c.fechaRegistro), readOnly: true),
                  DetailRow(label: 'Última actualización', value: fmtDate(_c.ultimaActualizacion), readOnly: true),
                ]),
                const SizedBox(height: 16),
                AppButton(label: 'Editar', onPressed: () => setState(() => _editando = true)),
                AppButton(
                  label: 'Ver historial de sanciones',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SancionesListScreen(conductorId: _c.id)),
                  ),
                ),
                if (puedeSancionar)
                  AppButton(
                    label: 'Sancionar conductor',
                    variant: AppButtonVariant.danger,
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SancionFormScreen(conductorId: _c.id)),
                      );
                      setState(() {});
                    },
                  )
                else
                  const Text(
                    'Solo los perfiles Gerente y Asistente pueden sancionar conductores.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
