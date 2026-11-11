import 'planilla.dart';

/// SinSam Express opera una única ruta autorizada, en dos sentidos.
class Ruta {
  final String id;
  final String origen;
  final String destino;
  final SentidoRuta sentido;
  final bool activa;
  final double tarifa;

  Ruta({
    required this.id,
    required this.origen,
    required this.destino,
    required this.sentido,
    required this.activa,
    required this.tarifa,
  });

  String get nombre =>
      sentido == SentidoRuta.ida ? '$origen → $destino' : '$destino → $origen';
}
