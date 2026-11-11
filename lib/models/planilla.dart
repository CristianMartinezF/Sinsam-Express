enum EstadoPlanilla { pendiente, pagada, anulada }

extension EstadoPlanillaX on EstadoPlanilla {
  String get label {
    switch (this) {
      case EstadoPlanilla.pendiente:
        return 'Pendiente';
      case EstadoPlanilla.pagada:
        return 'Pagada';
      case EstadoPlanilla.anulada:
        return 'Anulada';
    }
  }
}

enum SentidoRuta { ida, vuelta }

extension SentidoRutaX on SentidoRuta {
  String get label => this == SentidoRuta.ida ? 'Ida' : 'Vuelta';
}

class Planilla {
  final String id;
  final String numero;
  final DateTime fecha;
  final String hora;
  final String vehiculoId;
  final String conductorId;
  final String tarifaId;
  final String tipo; // Diaria, Especial...
  final SentidoRuta sentido;
  EstadoPlanilla estado;
  String? motivoAnulacion;
  DateTime? fechaPago;
  String? metodoPago;

  Planilla({
    required this.id,
    required this.numero,
    required this.fecha,
    required this.hora,
    required this.vehiculoId,
    required this.conductorId,
    required this.tarifaId,
    required this.tipo,
    required this.sentido,
    required this.estado,
    this.motivoAnulacion,
    this.fechaPago,
    this.metodoPago,
  });
}
