class Conductor {
  final String id;
  final String identificacion;
  final String nombres;
  final DateTime fechaNacimiento;
  bool activo;
  String celular;
  String correo;
  String numeroLicencia;
  String categoriaLicencia;
  DateTime vigenciaLicencia;
  final DateTime fechaRegistro;
  DateTime ultimaActualizacion;

  Conductor({
    required this.id,
    required this.identificacion,
    required this.nombres,
    required this.fechaNacimiento,
    required this.activo,
    required this.celular,
    required this.correo,
    required this.numeroLicencia,
    required this.categoriaLicencia,
    required this.vigenciaLicencia,
    required this.fechaRegistro,
    required this.ultimaActualizacion,
  });
}
