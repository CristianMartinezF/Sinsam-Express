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
  final _typeCtrl = TextEditingController();
  final _capCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _tpCtrl = TextEditingController();
  final _fareCtrl = TextEditingController();
  final _soatCtrl = TextEditingController();
  final _trmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(label: 'Placa', hint: 'Ej. WXY123', controller: _plateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tipo', hint: 'BUSETA / AUTOMOVIL / CAMIONETA', controller: _typeCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Capacidad de pasajeros', hint: 'Ej. 19', controller: _capCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            CustomInput(label: 'Marca', hint: 'Ej. Chevrolet', controller: _brandCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Modelo', hint: 'Ej. NPR 2022', controller: _modelCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tarjeta de propiedad', hint: 'Número de tarjeta', controller: _tpCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'ID Tarifa asignada', hint: 'Ej. 13', controller: _fareCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia SOAT', hint: 'AAAA-MM-DD (Ej. 2027-06-30)', controller: _soatCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia TRM', hint: 'AAAA-MM-DD (Ej. 2027-06-30)', controller: _trmCtrl),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                if (_plateCtrl.text.trim().isEmpty) return;
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  final cleanPlate = _plateCtrl.text.trim().toUpperCase().replaceAll('-', '');
                  await context.read<AppProvider>().addVehicle(
                        VehicleModel(
                          id: cleanPlate,
                          placa: cleanPlate,
                          tipo: _typeCtrl.text.trim().toUpperCase(),
                          marcaModelo: '${_brandCtrl.text.trim()} ${_modelCtrl.text.trim()}'.trim(),
                          capacidad: int.tryParse(_capCtrl.text) ?? 0,
                          conductor: 'Sin asignar',
                          tarjetaPropiedad: _tpCtrl.text.trim(),
                          soat: _soatCtrl.text.trim(),
                          trm: _trmCtrl.text.trim(),
                          tarifa: _fareCtrl.text.trim(),
                          estado: 'Activa',
                        ),
                      );
                  messenger.showSnackBar(const SnackBar(content: Text('Vehículo registrado exitosamente')));
                  navigator.pop();
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('Error al registrar vehículo: $e')));
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