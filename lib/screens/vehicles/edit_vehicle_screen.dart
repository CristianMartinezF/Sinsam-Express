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
  late final TextEditingController _driverCtrl;
  late final TextEditingController _fareCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _soatCtrl;
  late final TextEditingController _trmCtrl;

  @override
  void initState() {
    super.initState();
    _driverCtrl = TextEditingController(text: widget.vehicle.conductor);
    _fareCtrl = TextEditingController(text: widget.vehicle.tarifa);
    _stateCtrl = TextEditingController(text: widget.vehicle.estado);
    _soatCtrl = TextEditingController(text: widget.vehicle.soat);
    _trmCtrl = TextEditingController(text: widget.vehicle.trm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar vehiculo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(label: 'Conductor asignado', hint: '', controller: _driverCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Tarifa asignada', hint: '', controller: _fareCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Estado', hint: '', controller: _stateCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia Soat', hint: '', controller: _soatCtrl),
            const SizedBox(height: 12),
            CustomInput(label: 'Vigencia TRM', hint: '', controller: _trmCtrl),
            const Spacer(),
            PrimaryButton(
              text: 'Guardar',
              onPressed: () {
                context.read<AppProvider>().updateVehicle(
                      VehicleModel(
                        id: widget.vehicle.id,
                        placa: widget.vehicle.placa,
                        tipo: widget.vehicle.tipo,
                        marcaModelo: widget.vehicle.marcaModelo,
                        capacidad: widget.vehicle.capacidad,
                        conductor: _driverCtrl.text.trim(),
                        tarjetaPropiedad: widget.vehicle.tarjetaPropiedad,
                        soat: _soatCtrl.text.trim(),
                        trm: _trmCtrl.text.trim(),
                        tarifa: _fareCtrl.text.trim(),
                        estado: _stateCtrl.text.trim(),
                      ),
                    );
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
