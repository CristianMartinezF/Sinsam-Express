import '../models/tarifa.dart';
import 'mock_database.dart';

class TarifasService {
  final _db = MockDatabase.instance;

  Future<List<Tarifa>> listar() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return List<Tarifa>.from(_db.tarifas);
  }

  Future<Tarifa> registrar(Tarifa tarifa) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _db.tarifas.add(tarifa);
    return tarifa;
  }

  Future<void> inactivar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final t = _db.tarifaById(id);
    if (t != null) t.activo = false;
  }
}
