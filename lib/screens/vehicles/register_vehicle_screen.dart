import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class RegisterVehicleScreen extends StatefulWidget {
  const RegisterVehicleScreen({super.key});

  @override
  State<RegisterVehicleScreen> createState() => _RegisterVehicleScreenState();
}

class _RegisterVehicleScreenState extends State<RegisterVehicleScreen> {
  final _plateCtrl = TextEditingController();
  final _driverCtrl = TextEditingController(text: 'Diego Torres Múnera');
  final _typeCtrl = TextEditingController(text: 'Buseta');
  final _capCtrl = TextEditingController(text: '19');
  final _modelCtrl = TextEditingController(text: '2022');
  final _brandCtrl = TextEditingController();
  final _tpCtrl = TextEditingController(text: 'TP-99012');
  final _fareCtrl = TextEditingController(text: 'Tarifa estandar \$8.500');
  final _soatCtrl = TextEditingController(text: '22/03/2027');
  final _trmCtrl = TextEditingController(text: '10/06/2027');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehiculo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(label: 'Placa', hint: 'Ej. ABC-123', controller: _plateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Conductor asignado', hint: 'Seleccionar', controller: _driverCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tipo', hint: 'Buseta / Automóvil', controller: _typeCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Capacidad', hint: 'N pasajeros', controller: _capCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            CustomInput(label: 'Modelo', hint: 'Ej. 2022', controller: _modelCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Marca', hint: 'Ej. Chevrolet NPR', controller: _brandCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tarjeta de propiedad', hint: 'N de la tarjeta de propiedad', controller: _tpCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tarifa asignada', hint: 'Seleccionar tarifa', controller: _fareCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia Soat', hint: 'dd/mm/aaaa', controller: _soatCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia TRM', hint: 'dd/mm/aaaa', controller: _trmCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                if (_plateCtrl.text.trim().isEmpty) return;
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await context.read<AppProvider>().addVehicle(
                      VehicleModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        placa: _plateCtrl.text.trim().toUpperCase(),
                        tipo: _typeCtrl.text.trim(),
                        marcaModelo: '${_brandCtrl.text.trim()} ${_modelCtrl.text.trim()}',
                        capacidad: int.tryParse(_capCtrl.text) ?? 15,
                        conductor: _driverCtrl.text.trim(),
                        tarjetaPropiedad: _tpCtrl.text.trim(),
                        soat: _soatCtrl.text.trim(),
                        trm: _trmCtrl.text.trim(),
                        tarifa: _fareCtrl.text.trim(),
                        estado: 'Activa',
                      ),
                    );
                messenger.showSnackBar(
                  const SnackBar(content: Text('Vehículo registrado exitosamente')),
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
