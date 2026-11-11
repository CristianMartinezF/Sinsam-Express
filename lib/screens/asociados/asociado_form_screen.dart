import 'package:flutter/material.dart';
import '../../models/asociado.dart';
import '../../services/asociados_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.7.2 Registrar asociado / afiliar.
/// Formulario de creación de asociado.
class AsociadoFormScreen extends StatefulWidget {
  const AsociadoFormScreen({super.key});

  @override
  State<AsociadoFormScreen> createState() => _AsociadoFormScreenState();
}

class _AsociadoFormScreenState extends State<AsociadoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identificacionCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _fechaNacimientoCtrl = TextEditingController();
  final _fechaIngresoCtrl = TextEditingController();
  final _placaCtrl = TextEditingController();
  bool _activo = true;
  bool _loading = false;

  Future<void> _pickDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      controller.text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final partes = _nombresCtrl.text.trim().split(' ');
      final nombres = partes.take((partes.length / 2).ceil()).join(' ');
      final apellidos = partes.skip((partes.length / 2).ceil()).join(' ');
      final asociado = Asociado(
        id: 'a${DateTime.now().millisecondsSinceEpoch}',
        identificacion: _identificacionCtrl.text,
        nombres: nombres.isEmpty ? _nombresCtrl.text : nombres,
        apellidos: apellidos,
        activo: _activo,
        celular: _celularCtrl.text,
        correo: _correoCtrl.text,
        fechaNacimiento: DateTime.now(),
        fechaIngreso: DateTime.now(),
        placaVehiculo: _placaCtrl.text.isEmpty ? null : _placaCtrl.text,
        fechaRegistro: DateTime.now(),
        ultimaActualizacion: DateTime.now(),
      );
      await AsociadosService().registrar(asociado);
      if (!mounted) return;
      AppSnackBar.success(context, 'Asociado registrado exitosamente.');
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar asociado'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Identificación',
                  controller: _identificacionCtrl,
                  hint: 'Ej. 1045223981',
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                AppTextField(
                  label: 'Nombres completos',
                  controller: _nombresCtrl,
                  hint: 'Nombre y apellidos',
                  validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                AppTextField(
                  label: 'Celular',
                  controller: _celularCtrl,
                  hint: 'Ej. 300 123 4567',
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                AppTextField(
                  label: 'Correo electrónico',
                  controller: _correoCtrl,
                  hint: 'correo@ejemplo.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Correo no válido' : null,
                ),
                AppTextField(
                  label: 'Fecha de nacimiento',
                  controller: _fechaNacimientoCtrl,
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  onTap: () => _pickDate(_fechaNacimientoCtrl),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
                ),
                AppTextField(
                  label: 'Fecha de ingreso',
                  controller: _fechaIngresoCtrl,
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  onTap: () => _pickDate(_fechaIngresoCtrl),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
                ),
                AppTextField(
                  label: 'Placa del vehículo',
                  controller: _placaCtrl,
                  hint: 'Ej. ABC-123',
                ),
                const SectionLabel('Estado'),
                SwitchListTile(
                  value: _activo,
                  onChanged: (v) => setState(() => _activo = v),
                  title: const Text('Asociado activo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 10),
                AppButton(label: 'Guardar', loading: _loading, onPressed: _guardar),
                AppButton(
                  label: 'Cancelar',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
