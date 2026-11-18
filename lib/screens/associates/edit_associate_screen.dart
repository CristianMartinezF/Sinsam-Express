import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class EditAssociateScreen extends StatefulWidget {
  final AssociateModel associate;
  const EditAssociateScreen({super.key, required this.associate});

  @override
  State<EditAssociateScreen> createState() => _EditAssociateScreenState();
}

class _EditAssociateScreenState extends State<EditAssociateScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _birthCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.associate.nombre);
    _phoneCtrl = TextEditingController(text: widget.associate.celular);
    _emailCtrl = TextEditingController(text: widget.associate.correo);
    _birthCtrl = TextEditingController(text: widget.associate.fechaNacimiento);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar asociado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CC ${widget.associate.identificacion}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 14),
            CustomInput(label: 'Nombres completos', hint: '', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: '', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo electrónico', hint: '', controller: _emailCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: 'AAAA-MM-DD', controller: _birthCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar cambios',
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final updated = AssociateModel(
                    id: widget.associate.id,
                    identificacion: widget.associate.identificacion,
                    nombre: _nameCtrl.text.trim(),
                    celular: _phoneCtrl.text.trim(),
                    correo: _emailCtrl.text.trim(),
                    fechaNacimiento: _birthCtrl.text.trim(),
                    fechaIngreso: widget.associate.fechaIngreso,
                    placaVehiculo: widget.associate.placaVehiculo,
                    activo: widget.associate.activo,
                  );
                  await context.read<AppProvider>().editAssociate(updated);
                  navigator.pop();
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
                }
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