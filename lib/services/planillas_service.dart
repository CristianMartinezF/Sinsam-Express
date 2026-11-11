import '../models/planilla.dart';
import 'mock_database.dart';

class PlanillasService {
  final _db = MockDatabase.instance;

  Future<List<Planilla>> listar({EstadoPlanilla? estado}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final lista = _db.planillas
        .where((p) => estado == null || p.estado == estado)
        .toList();
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  Future<List<Planilla>> generarMasivo({
    required DateTime fecha,
    required List<String> vehiculoIds,
    required String tipo,
    required String tarifaId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final nuevas = <Planilla>[];
    for (final vId in vehiculoIds) {
      final vehiculo = _db.vehiculoById(vId);
      final numero = (1000 + _db.planillas.length + nuevas.length).toString();
      final planilla = Planilla(
        id: 'p$numero',
        numero: numero,
        fecha: fecha,
        hora: '07:40 a.m.',
        vehiculoId: vId,
        conductorId: vehiculo?.conductorId ?? '',
        tarifaId: tarifaId,
        tipo: tipo,
        sentido: SentidoRuta.ida,
        estado: EstadoPlanilla.pendiente,
      );
      _db.planillas.add(planilla);
      nuevas.add(planilla);
    }
    return nuevas;
  }

  Future<void> anular(String id, String motivo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final p = _db.planillas.where((pl) => pl.id == id).first;
    p.estado = EstadoPlanilla.anulada;
    p.motivoAnulacion = motivo;
  }

  Future<void> registrarPago(String id, {required String metodoPago}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final p = _db.planillas.where((pl) => pl.id == id).first;
    p.estado = EstadoPlanilla.pagada;
    p.fechaPago = DateTime.now();
    p.metodoPago = metodoPago;
  }
}
