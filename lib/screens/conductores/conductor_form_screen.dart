import 'package:flutter/material.dart';
import '../../models/conductor.dart';
import '../../services/conductores_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/misc_widgets.dart';

/// 5.9.1 Registrar conductor.
class ConductorFormScreen extends StatefulWidget {
  const ConductorFormScreen({super.key});

  @override
  State<ConductorFormScreen> createState() => _ConductorFormScreenState();
}

class _ConductorFormScreenState extends State<ConductorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identificacionCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _fechaNacCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _numeroLicenciaCtrl = TextEditingController();
  final _vigenciaLicenciaCtrl = TextEditingController();
  String _categoria = 'C1';
  bool _loading = false;

  Future<void> _pickDate(TextEditingController controller, {DateTime? initial}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime(2035),
    );
    if (date != null) {
      controller.text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final conductor = Conductor(
        id: 'c${DateTime.now().millisecondsSinceEpoch}',
        identificacion: _identificacionCtrl.text,
        nombres: _nombresCtrl.text,
        fechaNacimiento: DateTime.now(),
        activo: true,
        celular: _celularCtrl.text,
        correo: _correoCtrl.text,
        numeroLicencia: _numeroLicenciaCtrl.text,
        categoriaLicencia: _categoria,
        vigenciaLicencia: DateTime.now().add(const Duration(days: 365)),
        fechaRegistro: DateTime.now(),
        ultimaActualizacion: DateTime.now(),
      );
      await ConductoresService().registrar(conductor);
      if (!mounted) return;
      AppSnackBar.success(context, 'Conductor registrado exitosamente.');
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Registrar conductor'),
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
                  hint: 'Ej. 1002334552',
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
                  label: 'Fecha de nacimiento',
                  controller: _fechaNacCtrl,
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  onTap: () => _pickDate(_fechaNacCtrl),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
                ),
                AppTextField(
                  label: 'Celular',
                  controller: _celularCtrl,
                  hint: 'Ej. 301 456 7890',
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                AppTextField(
                  label: 'Correo electrónico',
                  controller: _correoCtrl,
                  hint: 'correo@ejemplo.com',
                  validator: (v) => (v == null || !v.contains('@')) ? 'Correo no válido' : null,
                ),
                const SectionLabel('Licencia de conducción'),
                AppTextField(
                  label: 'Número de licencia',
                  controller: _numeroLicenciaCtrl,
                  hint: 'Ej. 70234456',
                  validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                AppDropdownField<String>(
                  label: 'Categoría de licencia',
                  value: _categoria,
                  items: const ['A2', 'B1', 'C1', 'C2', 'C3']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoria = v ?? 'C1'),
                ),
                AppTextField(
                  label: 'Vigencia de licencia',
                  controller: _vigenciaLicenciaCtrl,
                  hint: 'dd/mm/aaaa',
                  readOnly: true,
                  onTap: () => _pickDate(_vigenciaLicenciaCtrl, initial: DateTime.now()),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una fecha' : null,
                ),
                const SizedBox(height: 8),
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
