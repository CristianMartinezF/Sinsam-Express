enum EstadoAfiliacion { vigente, finalizada }

extension EstadoAfiliacionX on EstadoAfiliacion {
  String get label => this == EstadoAfiliacion.vigente ? 'Vigente' : 'Finalizada';
}

class Afiliacion {
  final String id;
  final String asociadoId;
  final String vehiculoId;
  final DateTime fechaAfiliacion;
  DateTime? fechaFin;
  EstadoAfiliacion estado;
  final DateTime fechaRegistro;
  DateTime ultimaActualizacion;

  Afiliacion({
    required this.id,
    required this.asociadoId,
    required this.vehiculoId,
    required this.fechaAfiliacion,
    this.fechaFin,
    required this.estado,
    required this.fechaRegistro,
    required this.ultimaActualizacion,
  });
}
