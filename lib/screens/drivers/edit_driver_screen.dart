import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class EditDriverScreen extends StatefulWidget {
  final DriverModel driver;
  const EditDriverScreen({super.key, required this.driver});

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _birthCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _licCtrl;
  late final TextEditingController _catCtrl;
  late final TextEditingController _expCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.driver.nombre);
    _birthCtrl = TextEditingController(text: widget.driver.fechaNacimiento);
    _phoneCtrl = TextEditingController(text: widget.driver.celular);
    _emailCtrl = TextEditingController(text: widget.driver.correo);
    _stateCtrl = TextEditingController(text: widget.driver.estado);
    _licCtrl = TextEditingController(text: widget.driver.numeroLicencia);
    _catCtrl = TextEditingController(text: widget.driver.categoria);
    _expCtrl = TextEditingController(text: widget.driver.vigenciaLicencia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar conductor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'Nombres completos', hint: '', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: 'AAAA-MM-DD', controller: _birthCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: '', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo', hint: '', controller: _emailCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Estado', hint: 'Activo / Inactivo', controller: _stateCtrl),
            const SizedBox(height: 18),
            const Text('LICENCIA DE CONDUCCIÓN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 10),
            CustomInput(label: 'Número de licencia', hint: '', controller: _licCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Categoría', hint: 'C1 / C2 / C3', controller: _catCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia de licencia', hint: 'AAAA-MM-DD', controller: _expCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar cambios',
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await context.read<AppProvider>().updateDriver(
                        DriverModel(
                          id: widget.driver.id,
                          identificacion: widget.driver.identificacion,
                          nombre: _nameCtrl.text.trim(),
                          fechaNacimiento: _birthCtrl.text.trim(),
                          celular: _phoneCtrl.text.trim(),
                          correo: _emailCtrl.text.trim(),
                          numeroLicencia: _licCtrl.text.trim(),
                          categoria: _catCtrl.text.trim().toUpperCase(),
                          vigenciaLicencia: _expCtrl.text.trim(),
                          estado: _stateCtrl.text.trim(),
                        ),
                      );
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