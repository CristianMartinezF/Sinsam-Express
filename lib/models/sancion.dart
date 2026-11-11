enum EstadoSancion { programada, vigente, finalizada }

extension EstadoSancionX on EstadoSancion {
  String get label {
    switch (this) {
      case EstadoSancion.programada:
        return 'Programada';
      case EstadoSancion.vigente:
        return 'Vigente';
      case EstadoSancion.finalizada:
        return 'Finalizada';
    }
  }
}

class Sancion {
  final String id;
  final String conductorId;
  final DateTime fechaInicial;
  final DateTime fechaFinal;
  final String motivo;
  final String observaciones;
  final String registradoPor;
  final DateTime fechaRegistro;

  Sancion({
    required this.id,
    required this.conductorId,
    required this.fechaInicial,
    required this.fechaFinal,
    required this.motivo,
    required this.observaciones,
    required this.registradoPor,
    required this.fechaRegistro,
  });

  /// El estado se calcula dinámicamente según la fecha actual.
  EstadoSancion estadoActual([DateTime? ahora]) {
    final now = ahora ?? DateTime.now();
    if (now.isBefore(fechaInicial)) return EstadoSancion.programada;
    if (now.isAfter(fechaFinal)) return EstadoSancion.finalizada;
    return EstadoSancion.vigente;
  }
}
