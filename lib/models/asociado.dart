class Asociado {
  final String id;
  final String identificacion;
  final String nombres;
  final String apellidos;
  bool activo;
  String celular;
  String correo;
  final DateTime fechaNacimiento;
  final DateTime fechaIngreso;
  String? placaVehiculo;
  final DateTime fechaRegistro;
  DateTime ultimaActualizacion;

  Asociado({
    required this.id,
    required this.identificacion,
    required this.nombres,
    required this.apellidos,
    required this.activo,
    required this.celular,
    required this.correo,
    required this.fechaNacimiento,
    required this.fechaIngreso,
    this.placaVehiculo,
    required this.fechaRegistro,
    required this.ultimaActualizacion,
  });

  String get nombreCompleto => '$nombres $apellidos';
}
