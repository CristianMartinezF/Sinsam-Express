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
  final _entryCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  bool _active = true;

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _idCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa identificación y nombre')),
      );
      return;
    }
    final newAssociate = AssociateModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      identificacion: _idCtrl.text.trim(),
      nombre: _nameCtrl.text.trim(),
      celular: _phoneCtrl.text.trim(),
      correo: _emailCtrl.text.trim(),
      fechaNacimiento: _birthCtrl.text.trim(),
      fechaIngreso: _entryCtrl.text.trim(),
      placaVehiculo: _plateCtrl.text.trim(),
      activo: _active,
    );
    await context.read<AppProvider>().addAssociate(newAssociate);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asociado guardado y reflejado en la lista')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar asociados')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'identificacion', hint: 'Ej. 1049317444', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Nombres completos', hint: 'Nombre y apellidos', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: 'Ej. 3103652244', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo electronico', hint: 'correo@gmail.com', controller: _emailCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: 'dd/mm/aaaa', controller: _birthCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de ingreso', hint: 'dd/mm/aaaa', controller: _entryCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Placa del vehiculo', hint: 'Seleccionar vehiculo', controller: _plateCtrl),
            const SizedBox(height: 14),
            SwitchListTile(
              title: const Text('Asociado activo'),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            const SizedBox(height: 18),
            PrimaryButton(text: 'Guardar', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
