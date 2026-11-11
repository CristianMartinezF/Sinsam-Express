import '../models/ruta.dart';
import 'mock_database.dart';

class RutasService {
  final _db = MockDatabase.instance;

  Future<List<Ruta>> listar() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List<Ruta>.from(_db.rutas);
  }
}
