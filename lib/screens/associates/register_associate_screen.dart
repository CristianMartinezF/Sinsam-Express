import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterAssociateScreen extends StatefulWidget {
  const RegisterAssociateScreen({super.key});

  @override
  State<RegisterAssociateScreen> createState() => _RegisterAssociateScreenState();
}

class _RegisterAssociateScreenState extends State<RegisterAssociateScreen> {
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  bool _active = true;
  bool _saving = false;

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _idCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa identificación y nombres')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final newAssociate = AssociateModel(
        id: _idCtrl.text.trim(),
        identificacion: _idCtrl.text.trim(),
        nombre: _nameCtrl.text.trim(),
        celular: _phoneCtrl.text.trim(),
        correo: _emailCtrl.text.trim(),
        fechaNacimiento: _birthCtrl.text.trim(),
        fechaIngreso: '',
        activo: _active,
      );
      await context.read<AppProvider>().addAssociate(newAssociate);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asociado registrado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar asociado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'Identificación', hint: 'Ej. 1104789234', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Nombres completos', hint: 'Nombres y apellidos', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: 'Ej. 3145678912', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo electrónico', hint: 'correo@gmail.com', controller: _emailCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: 'AAAA-MM-DD (Ej. 1993-07-19)', controller: _birthCtrl),
            const SizedBox(height: 14),
            SwitchListTile(
              title: const Text('Asociado activo'),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            const SizedBox(height: 18),
            PrimaryButton(text: _saving ? 'Guardando...' : 'Guardar', onPressed: _saving ? () {} : _save),
          ],
        ),
      ),
    );
  }
}