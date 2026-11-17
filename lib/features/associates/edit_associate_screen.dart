import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/app_models.dart';
import '../../core/providers/app_provider.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class EditAssociateScreen extends StatefulWidget {
  final AssociateModel associate;
  const EditAssociateScreen({super.key, required this.associate});

  @override
  State<EditAssociateScreen> createState() => _EditAssociateScreenState();
}

class _EditAssociateScreenState extends State<EditAssociateScreen> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _birthCtrl;

  @override
  void initState() {
    super.initState();
    _idCtrl = TextEditingController(text: widget.associate.identificacion);
    _nameCtrl = TextEditingController(text: widget.associate.nombre);
    _phoneCtrl = TextEditingController(text: widget.associate.celular);
    _emailCtrl = TextEditingController(text: widget.associate.correo);
    _birthCtrl = TextEditingController(text: widget.associate.fechaNacimiento);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar asociados')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(label: 'Identificacion', hint: '', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Nombre y apellido', hint: '', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: '', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo', hint: '', controller: _emailCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: '', controller: _birthCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar cambios',
              onPressed: () async {
                final updated = AssociateModel(
                  id: widget.associate.id,
                  identificacion: _idCtrl.text.trim(),
                  nombre: _nameCtrl.text.trim(),
                  celular: _phoneCtrl.text.trim(),
                  correo: _emailCtrl.text.trim(),
                  fechaNacimiento: _birthCtrl.text.trim(),
                  fechaIngreso: widget.associate.fechaIngreso,
                  placaVehiculo: widget.associate.placaVehiculo,
                  activo: widget.associate.activo,
                );
                await context.read<AppProvider>().editAssociate(updated);
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Cancelar', isOutlined: true, onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
