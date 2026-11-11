import '../models/sancion.dart';
import 'mock_database.dart';

class SancionesService {
  final _db = MockDatabase.instance;

  Future<List<Sancion>> listar({EstadoSancion? estado}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final lista = _db.sanciones
        .where((s) => estado == null || s.estadoActual() == estado)
        .toList();
    lista.sort((a, b) => b.fechaInicial.compareTo(a.fechaInicial));
    return lista;
  }

  Future<List<Sancion>> deConductor(String conductorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db.sancionesDeConductor(conductorId);
  }

  /// Reglas de interfaz: fecha final >= fecha inicial, y campos obligatorios.
  String? validar({
    required String? conductorId,
    required DateTime? fechaInicial,
    required DateTime? fechaFinal,
    required String motivo,
  }) {
    if (conductorId == null || conductorId.isEmpty) {
      return 'Debes seleccionar un conductor.';
    }
    if (fechaInicial == null || fechaFinal == null) {
      return 'Debes indicar el periodo de la sanción.';
    }
    if (fechaFinal.isBefore(fechaInicial)) {
      return 'La fecha final debe ser igual o posterior a la inicial.';
    }
    if (motivo.trim().isEmpty) {
      return 'Debes indicar el motivo de la sanción.';
    }
    return null;
  }

  Future<Sancion> registrar(Sancion sancion) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _db.sanciones.add(sancion);
    return sancion;
  }
}
