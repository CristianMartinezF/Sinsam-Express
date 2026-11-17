import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() => _RegisterDriverScreenState();
}

class _RegisterDriverScreenState extends State<RegisterDriverScreen> {
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _licCtrl = TextEditingController();
  final _catCtrl = TextEditingController();
  final _expCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar conductor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(label: 'Identificación', hint: 'Ej. 1002334552', controller: _idCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Nombres completos', hint: 'Nombre y apellidos', controller: _nameCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Fecha de nacimiento', hint: 'dd/mm/aaaa', controller: _birthCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Celular', hint: 'Ej. 301 456 7890', controller: _phoneCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo electrónico', hint: 'correo@ejemplo.com', controller: _emailCtrl),
            const SizedBox(height: 18),
            const Text('LICENCIA DE CONDUCCIÓN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 10),
            CustomInput(label: 'Número de licencia', hint: 'Ej. 70234456', controller: _licCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Categoría', hint: 'C1, C2, C3', controller: _catCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia de licencia', hint: 'dd/mm/aaaa', controller: _expCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                if (_nameCtrl.text.trim().isEmpty) return;
                final navigator = Navigator.of(context);
                await context.read<AppProvider>().addDriver(
                      DriverModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        identificacion: _idCtrl.text.trim(),
                        nombre: _nameCtrl.text.trim(),
                        fechaNacimiento: _birthCtrl.text.trim(),
                        celular: _phoneCtrl.text.trim(),
                        correo: _emailCtrl.text.trim(),
                        numeroLicencia: _licCtrl.text.trim(),
                        categoria: _catCtrl.text.trim(),
                        vigenciaLicencia: _expCtrl.text.trim(),
                        estado: 'Activo',
                      ),
                    );
                navigator.pop();
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
