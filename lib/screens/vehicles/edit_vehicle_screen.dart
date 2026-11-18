import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_models.dart';
import '../../services/app_provider.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/primary_button.dart';

class EditVehicleScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late final TextEditingController _fareCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _soatCtrl;
  late final TextEditingController _trmCtrl;

  @override
  void initState() {
    super.initState();
    _fareCtrl = TextEditingController(text: widget.vehicle.tarifa);
    _stateCtrl = TextEditingController(text: widget.vehicle.estado);
    _soatCtrl = TextEditingController(text: widget.vehicle.soat);
    _trmCtrl = TextEditingController(text: widget.vehicle.trm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Placa ${widget.vehicle.placa}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 14),
            CustomInput(label: 'ID Tarifa asignada', hint: 'Ej. 13', controller: _fareCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            CustomInput(label: 'Estado', hint: 'Activa / Inactiva', controller: _stateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia SOAT', hint: 'AAAA-MM-DD', controller: _soatCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia TRM', hint: 'AAAA-MM-DD', controller: _trmCtrl),
            const Spacer(),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await context.read<AppProvider>().updateVehicle(
                        VehicleModel(
                          id: widget.vehicle.id,
                          placa: widget.vehicle.placa,
                          tipo: widget.vehicle.tipo,
                          marcaModelo: widget.vehicle.marcaModelo,
                          capacidad: widget.vehicle.capacidad,
                          conductor: widget.vehicle.conductor,
                          tarjetaPropiedad: widget.vehicle.tarjetaPropiedad,
                          soat: _soatCtrl.text.trim(),
                          trm: _trmCtrl.text.trim(),
                          tarifa: _fareCtrl.text.trim(),
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