import 'package:flutter/material.dart';
import '../../core/models/app_models.dart';
import '../../core/theme/app_colors.dart';

class DispatchDetailScreen extends StatelessWidget {
  final DispatchModel dispatch;
  const DispatchDetailScreen({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de despacho')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DRow('ID', dispatch.codigo),
              _DRow('Ruta', dispatch.ruta),
              _DRow('Vehículo', dispatch.placa),
              _DRow('Pasajeros', '${dispatch.pasajeros}'),
              const Divider(),
              _DRow('Fecha', dispatch.fecha),
              _DRow('Hora', dispatch.hora),
              _DRow('Estado', dispatch.estado),
            ],
          ),
        ),
      ),
    );
  }
}

class _DRow extends StatelessWidget {
  final String k, v;
  const _DRow(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
