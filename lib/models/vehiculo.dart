enum EstadoVehiculo { activo, mantenimiento, inactivo }

extension EstadoVehiculoX on EstadoVehiculo {
  String get label {
    switch (this) {
      case EstadoVehiculo.activo:
        return 'Activo';
      case EstadoVehiculo.mantenimiento:
        return 'En mantenimiento';
      case EstadoVehiculo.inactivo:
        return 'Inactivo';
    }
  }
}

class Vehiculo {
  final String id;
  final String placa;
  String tipo; // Buseta, Automóvil, Bus...
  String marca;
  String modelo;
  int capacidad;
  String tarjetaPropiedad;
  String? conductorId;
  String? tarifaId;
  EstadoVehiculo estado;
  DateTime vigenciaSoat;
  DateTime vigenciaTrm;
  final DateTime fechaIngreso;
  final DateTime fechaRegistro;
  DateTime ultimaActualizacion;
  DateTime? fechaSalidaMantenimiento;
  String? motivoMantenimiento;

  Vehiculo({
    required this.id,
    required this.placa,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.capacidad,
    required this.tarjetaPropiedad,
    this.conductorId,
    this.tarifaId,
    required this.estado,
    required this.vigenciaSoat,
    required this.vigenciaTrm,
    required this.fechaIngreso,
    required this.fechaRegistro,
    required this.ultimaActualizacion,
    this.fechaSalidaMantenimiento,
    this.motivoMantenimiento,
  });
}
