import 'package:flutter/material.dart';
import '../../models/vehiculo.dart';
import '../../routes/app_routes.dart';
import '../../services/mock_database.dart';
import '../../services/vehiculos_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/state_views.dart';
import '../../widgets/status_chip.dart';
import '../vehiculos/vehiculo_detail_screen.dart';

/// 5.15 Mis vehículos.
/// Los asociados pueden consultar los vehículos que tengan afiliados.
class MisVehiculosScreen extends StatelessWidget {
  const MisVehiculosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis vehículos'), automaticallyImplyLeading: false),
      body: const SafeArea(child: MisVehiculosContent(embedded: false)),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.misVehiculos),
    );
  }
}

/// Contenido reutilizable: se usa tanto en la pantalla completa como
/// embebido en el Dashboard del Asociado.
class MisVehiculosContent extends StatefulWidget {
  final bool embedded;
  const MisVehiculosContent({super.key, required this.embedded});

  @override
  State<MisVehiculosContent> createState() => _MisVehiculosContentState();
}

class _MisVehiculosContentState extends State<MisVehiculosContent> {
  final _service = VehiculosService();
  late Future<List<Vehiculo>> _future;

  // Vehículo del asociado de demostración (placa afiliada).
  static const _miPlaca = 'ABC-123';

  @override
  void initState() {
    super.initState();
    _future = _service.deAsociado(_miPlaca);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehiculo>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingStateView();
        }
        final vehiculos = snapshot.data ?? [];
        if (vehiculos.isEmpty) {
          return EmptyStateView(
            title: 'Aún no tienes vehículos afiliados',
            message: 'Cuando se registre una afiliación a tu nombre, aparecerá aquí.',
          );
        }
        final db = MockDatabase.instance;
        final content = Column(
          children: vehiculos.map((v) {
            final conductor = v.conductorId != null ? db.conductorById(v.conductorId!) : null;
            return ListItemCard(
              title: '${v.placa} · ${v.tipo}',
              subtitle: '${v.marca} · ${conductor?.nombres ?? 'Sin conductor asignado'}',
              avatarText: v.tipo == 'Automóvil' ? '🚗' : '🚐',
              trailing: StatusChip(
                label: v.estado.label,
                type: v.estado == EstadoVehiculo.activo
                    ? ChipType.active
                    : (v.estado == EstadoVehiculo.mantenimiento ? ChipType.warn : ChipType.inactive),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => VehiculoDetailScreen(vehiculoId: v.id)),
              ),
            );
          }).toList(),
        );
        return widget.embedded
            ? content
            : Padding(padding: const EdgeInsets.all(16), child: content);
      },
    );
  }
}
