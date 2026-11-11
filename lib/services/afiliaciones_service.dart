import '../models/afiliacion.dart';
import 'mock_database.dart';

class AfiliacionesService {
  final _db = MockDatabase.instance;

  Future<List<Afiliacion>> listar({EstadoAfiliacion? estado}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _db.afiliaciones
        .where((af) => estado == null || af.estado == estado)
        .toList();
  }

  Future<void> finalizar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final af = _db.afiliaciones.where((a) => a.id == id).first;
    af.estado = EstadoAfiliacion.finalizada;
    af.fechaFin = DateTime.now();
    af.ultimaActualizacion = DateTime.now();
  }
}
