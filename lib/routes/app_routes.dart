/// Nombres de ruta centralizados para toda la aplicación.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';

  // Autenticación
  static const String login = '/login';
  static const String recuperarPassword = '/recuperar-password';
  static const String verificarOtp = '/verificar-otp';
  static const String nuevaPassword = '/nueva-password';
  static const String sesionInvalida = '/sesion-invalida';

  // Núcleo
  static const String dashboard = '/dashboard';

  // Asociados
  static const String asociadosList = '/asociados';
  static const String asociadoForm = '/asociados/form';
  static const String asociadoDetail = '/asociados/detalle';

  // Afiliaciones
  static const String afiliacionesList = '/afiliaciones';
  static const String afiliacionDetail = '/afiliaciones/detalle';

  // Conductores
  static const String conductoresList = '/conductores';
  static const String conductorForm = '/conductores/form';
  static const String conductorDetail = '/conductores/detalle';

  // Sanciones
  static const String sancionesList = '/sanciones';
  static const String sancionForm = '/sanciones/form';
  static const String sancionDetail = '/sanciones/detalle';

  // Rutas
  static const String rutas = '/rutas';

  // Vehículos
  static const String vehiculosList = '/vehiculos';
  static const String vehiculoForm = '/vehiculos/form';
  static const String vehiculoDetail = '/vehiculos/detalle';
  static const String vehiculoMantenimiento = '/vehiculos/mantenimiento';

  // Tarifas
  static const String tarifasList = '/tarifas';
  static const String tarifaForm = '/tarifas/form';
  static const String tarifaDetail = '/tarifas/detalle';

  // Planillas
  static const String planillasList = '/planillas';
  static const String planillasGenerar = '/planillas/generar';
  static const String planillaDetail = '/planillas/detalle';

  // Despachos
  static const String despachosList = '/despachos';
  static const String despachoForm = '/despachos/form';
  static const String despachoDetail = '/despachos/detalle';

  // Cuenta (Asociado / Conductor)
  static const String misVehiculos = '/cuenta/vehiculos';
  static const String misViajes = '/cuenta/viajes';
  static const String miPerfil = '/cuenta/perfil';
}
