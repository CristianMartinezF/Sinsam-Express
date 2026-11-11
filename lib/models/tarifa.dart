class Tarifa {
  final String id;
  final String nombre;
  double aportesGastosVarios;
  double fondoReposicion;
  double aporteSocial;
  bool activo;
  final DateTime fechaRegistro;

  Tarifa({
    required this.id,
    required this.nombre,
    required this.aportesGastosVarios,
    required this.fondoReposicion,
    required this.aporteSocial,
    required this.activo,
    required this.fechaRegistro,
  });

  double get total => aportesGastosVarios + fondoReposicion + aporteSocial;
}
