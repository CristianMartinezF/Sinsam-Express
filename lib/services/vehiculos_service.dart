import '../models/vehiculo.dart';
import 'mock_database.dart';

class VehiculosService {
  final _db = MockDatabase.instance;

  Future<List<Vehiculo>> listar({
    String placa = '',
    String? tipo,
    bool forzarError = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (forzarError) {
      throw Exception('No fue posible cargar el listado de vehículos.');
    }
    return _db.vehiculos.where((v) {
      final matchPlaca =
          placa.isEmpty || v.placa.toLowerCase().contains(placa.toLowerCase());
      final matchTipo = tipo == null || tipo == 'Todos' || v.tipo == tipo;
      return matchPlaca && matchTipo;
    }).toList();
  }

  Future<List<Vehiculo>> deAsociado(String? placa) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (placa == null) return [];
    return _db.vehiculos.where((v) => v.placa == placa).toList();
  }

  Future<Vehiculo> registrar(Vehiculo vehiculo) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _db.vehiculos.add(vehiculo);
    return vehiculo;
  }

  Future<Vehiculo> actualizar(Vehiculo vehiculo) async {
    await Future.delayed(const Duration(milliseconds: 600));
    vehiculo.ultimaActualizacion = DateTime.now();
    return vehiculo;
  }
}
