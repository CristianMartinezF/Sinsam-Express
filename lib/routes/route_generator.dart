import 'package:flutter/material.dart';
import '../screens/afiliaciones/afiliacion_detail_screen.dart';
import '../screens/afiliaciones/afiliaciones_list_screen.dart';
import '../screens/asociados/asociado_detail_screen.dart';
import '../screens/asociados/asociado_form_screen.dart';
import '../screens/asociados/asociados_list_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/nueva_password_screen.dart';
import '../screens/auth/recuperar_password_screen.dart';
import '../screens/auth/verificar_otp_screen.dart';
import '../screens/conductores/conductor_detail_screen.dart';
import '../screens/conductores/conductor_form_screen.dart';
import '../screens/conductores/conductores_list_screen.dart';
import '../screens/cuenta/mis_vehiculos_screen.dart';
import '../screens/cuenta/perfil_screen.dart';
import '../screens/cuenta/viajes_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/despachos/despacho_detail_screen.dart';
import '../screens/despachos/despacho_form_screen.dart';
import '../screens/despachos/despachos_list_screen.dart';
import '../screens/planillas/generar_planillas_screen.dart';
import '../screens/planillas/planilla_detail_screen.dart';
import '../screens/planillas/planillas_list_screen.dart';
import '../screens/rutas/rutas_screen.dart';
import '../screens/sanciones/sancion_detail_screen.dart';
import '../screens/sanciones/sancion_form_screen.dart';
import '../screens/sanciones/sanciones_list_screen.dart';
import '../screens/shared/session_invalid_screen.dart';
import '../screens/shared/splash_screen.dart';
import '../screens/tarifas/tarifa_detail_screen.dart';
import '../screens/tarifas/tarifa_form_screen.dart';
import '../screens/tarifas/tarifas_list_screen.dart';
import '../screens/vehiculos/mantenimiento_screen.dart';
import '../screens/vehiculos/vehiculo_detail_screen.dart';
import '../screens/vehiculos/vehiculo_form_screen.dart';
import '../screens/vehiculos/vehiculos_list_screen.dart';
import 'app_routes.dart';

/// Resuelve cada nombre de ruta a su pantalla.
/// Las pantallas de detalle reciben el id como argumento (String).
class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generate(RouteSettings settings) {
    final arg = settings.arguments;
    final id = arg is String ? arg : '';

    Widget page;
    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
        break;
      case AppRoutes.login:
        page = const LoginScreen();
        break;
      case AppRoutes.recuperarPassword:
        page = const RecuperarPasswordScreen();
        break;
      case AppRoutes.verificarOtp:
        page = VerificarOtpScreen(correo: arg is String ? arg : null);
        break;
      case AppRoutes.nuevaPassword:
        page = const NuevaPasswordScreen();
        break;
      case AppRoutes.sesionInvalida:
        page = const SessionInvalidScreen();
        break;
      case AppRoutes.dashboard:
        page = const DashboardScreen();
        break;
      case AppRoutes.asociadosList:
        page = const AsociadosListScreen();
        break;
      case AppRoutes.asociadoForm:
        page = const AsociadoFormScreen();
        break;
      case AppRoutes.asociadoDetail:
        page = AsociadoDetailScreen(asociadoId: id);
        break;
      case AppRoutes.afiliacionesList:
        page = const AfiliacionesListScreen();
        break;
      case AppRoutes.afiliacionDetail:
        page = AfiliacionDetailScreen(afiliacionId: id);
        break;
      case AppRoutes.conductoresList:
        page = const ConductoresListScreen();
        break;
      case AppRoutes.conductorForm:
        page = const ConductorFormScreen();
        break;
      case AppRoutes.conductorDetail:
        page = ConductorDetailScreen(conductorId: id);
        break;
      case AppRoutes.sancionesList:
        page = SancionesListScreen(conductorId: id.isEmpty ? null : id);
        break;
      case AppRoutes.sancionForm:
        page = SancionFormScreen(conductorId: id.isEmpty ? null : id);
        break;
      case AppRoutes.sancionDetail:
        page = SancionDetailScreen(sancionId: id);
        break;
      case AppRoutes.rutas:
        page = const RutasScreen();
        break;
      case AppRoutes.vehiculosList:
        page = const VehiculosListScreen();
        break;
      case AppRoutes.vehiculoForm:
        page = const VehiculoFormScreen();
        break;
      case AppRoutes.vehiculoDetail:
        page = VehiculoDetailScreen(vehiculoId: id);
        break;
      case AppRoutes.vehiculoMantenimiento:
        page = const MantenimientoScreen();
        break;
      case AppRoutes.tarifasList:
        page = const TarifasListScreen();
        break;
      case AppRoutes.tarifaForm:
        page = const TarifaFormScreen();
        break;
      case AppRoutes.tarifaDetail:
        page = TarifaDetailScreen(tarifaId: id);
        break;
      case AppRoutes.planillasList:
        page = const PlanillasListScreen();
        break;
      case AppRoutes.planillasGenerar:
        page = const GenerarPlanillasScreen();
        break;
      case AppRoutes.planillaDetail:
        page = PlanillaDetailScreen(planillaId: id);
        break;
      case AppRoutes.despachosList:
        page = const DespachosListScreen();
        break;
      case AppRoutes.despachoForm:
        page = const DespachoFormScreen();
        break;
      case AppRoutes.despachoDetail:
        page = DespachoDetailScreen(despachoId: id);
        break;
      case AppRoutes.misVehiculos:
        page = const MisVehiculosScreen();
        break;
      case AppRoutes.misViajes:
        page = const ViajesScreen();
        break;
      case AppRoutes.miPerfil:
        page = const PerfilScreen();
        break;
      default:
        page = const LoginScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
