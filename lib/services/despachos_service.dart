import '../models/despacho.dart';
import 'mock_database.dart';

class DespachosService {
  final _db = MockDatabase.instance;

  Future<List<Despacho>> listar({String? placaVehiculo}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final lista = _db.despachos.where((d) {
      if (placaVehiculo == null) return true;
      final vehiculo = _db.vehiculoById(d.vehiculoId);
      return vehiculo?.placa == placaVehiculo;
    }).toList();
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  Future<Despacho> registrar(Despacho despacho) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _db.despachos.add(despacho);
    return despacho;
  }
}
