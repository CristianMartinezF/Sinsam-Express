import '../models/conductor.dart';
import 'mock_database.dart';

class ConductoresService {
  final _db = MockDatabase.instance;

  Future<List<Conductor>> listar({String query = ''}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _db.conductores.where((c) {
      return query.isEmpty ||
          c.identificacion.toLowerCase().contains(query.toLowerCase()) ||
          c.nombres.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<Conductor> registrar(Conductor conductor) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _db.conductores.add(conductor);
    return conductor;
  }

  Future<Conductor> actualizar(Conductor conductor) async {
    await Future.delayed(const Duration(milliseconds: 600));
    conductor.ultimaActualizacion = DateTime.now();
    return conductor;
  }

  bool estaSancionado(String conductorId) => _db.conductorSancionado(conductorId);
}
