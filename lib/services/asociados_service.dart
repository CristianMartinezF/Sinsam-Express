import '../models/asociado.dart';
import 'mock_database.dart';

class AsociadosService {
  final _db = MockDatabase.instance;

  Future<List<Asociado>> listar({
    String query = '',
    bool? soloActivos,
    bool forzarError = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (forzarError) {
      throw Exception('No fue posible conectar con el servidor.');
    }
    return _db.asociados.where((a) {
      final matchQuery = query.isEmpty ||
          a.identificacion.toLowerCase().contains(query.toLowerCase()) ||
          a.nombreCompleto.toLowerCase().contains(query.toLowerCase());
      final matchEstado = soloActivos == null || a.activo == soloActivos;
      return matchQuery && matchEstado;
    }).toList();
  }

  Future<Asociado> registrar(Asociado asociado) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _db.asociados.add(asociado);
    return asociado;
  }

  Future<Asociado> actualizar(Asociado asociado) async {
    await Future.delayed(const Duration(milliseconds: 600));
    asociado.ultimaActualizacion = DateTime.now();
    return asociado;
  }

  Future<void> desafiliar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final a = _db.asociadoById(id);
    if (a != null) {
      a.activo = false;
      a.ultimaActualizacion = DateTime.now();
    }
  }
}
