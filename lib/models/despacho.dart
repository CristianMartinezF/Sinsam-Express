import 'planilla.dart';

class Despacho {
  final String id;
  final SentidoRuta sentido;
  final String vehiculoId;
  final DateTime fecha;
  final String hora;
  final int numeroPasajeros;
  final DateTime fechaRegistro;

  Despacho({
    required this.id,
    required this.sentido,
    required this.vehiculoId,
    required this.fecha,
    required this.hora,
    required this.numeroPasajeros,
    required this.fechaRegistro,
  });
}
