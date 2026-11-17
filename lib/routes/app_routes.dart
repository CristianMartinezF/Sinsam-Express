import 'package:flutter/material.dart';
import '../screens/affiliations/affiliations_list_screen.dart';
import '../screens/associates/associates_list_screen.dart';
import '../screens/associates/register_associate_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/new_password_screen.dart';
import '../screens/auth/recover_password_screen.dart';
import '../screens/auth/verify_code_screen.dart';
import '../screens/dispatches/dispatches_list_screen.dart';
import '../screens/dispatches/register_dispatch_screen.dart';
import '../screens/drivers/driver_detail_screen.dart';
import '../screens/drivers/register_driver_screen.dart';
import '../screens/fares/fares_list_screen.dart';
import '../screens/fares/register_fare_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/more/more_menu_screen.dart';
import '../screens/navigation/main_navigation_screen.dart';
import '../screens/routes/routes_list_screen.dart';
import '../screens/sanctions/register_sanction_screen.dart';
import '../screens/sanctions/sanctions_history_screen.dart';
import '../screens/sheets/generate_sheets_screen.dart';
import '../screens/sheets/sheets_list_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/vehicles/register_vehicle_screen.dart';
import '../screens/vehicles/vehicles_list_screen.dart';
import '../widgets/app_states.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String recoverPassword = '/recover-password';
  static const String verifyCode = '/verify-code';
  static const String newPassword = '/new-password';
  static const String mainNav = '/main';
  static const String home = '/home';
  static const String associates = '/associates';
  static const String registerAssociate = '/associates/register';
  static const String affiliations = '/affiliations';
  static const String driverDetail = '/drivers/detail';
  static const String registerDriver = '/drivers/register';
  static const String sanctions = '/sanctions';
  static const String registerSanction = '/sanctions/register';
  static const String routesList = '/routes';
  static const String vehicles = '/vehicles';
  static const String registerVehicle = '/vehicles/register';
  static const String fares = '/fares';
  static const String registerFare = '/fares/register';
  static const String sheets = '/sheets';
  static const String generateSheets = '/sheets/generate';
  static const String dispatches = '/dispatches';
  static const String registerDispatch = '/dispatches/register';
  static const String more = '/more';
  static const String sessionExpired = '/session-expired';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        recoverPassword: (_) => const RecoverPasswordScreen(),
        verifyCode: (_) => const VerifyCodeScreen(),
        newPassword: (_) => const NewPasswordScreen(),
        mainNav: (_) => const MainNavigationScreen(),
        home: (_) => const HomeScreen(),
        associates: (_) => const AssociatesListScreen(),
        registerAssociate: (_) => const RegisterAssociateScreen(),
        affiliations: (_) => const AffiliationsListScreen(),
        driverDetail: (_) => const DriverDetailScreen(),
        registerDriver: (_) => const RegisterDriverScreen(),
        sanctions: (_) => const SanctionsHistoryScreen(),
        registerSanction: (_) => const RegisterSanctionScreen(),
        routesList: (_) => const RoutesListScreen(),
        vehicles: (_) => const VehiclesListScreen(),
        registerVehicle: (_) => const RegisterVehicleScreen(),
        fares: (_) => const FaresListScreen(),
        registerFare: (_) => const RegisterFareScreen(),
        sheets: (_) => const SheetsListScreen(),
        generateSheets: (_) => const GenerateSheetsScreen(),
        dispatches: (_) => const DispatchesListScreen(),
        registerDispatch: (_) => const RegisterDispatchScreen(),
        more: (_) => const MoreMenuScreen(),
        sessionExpired: (_) => const SessionExpiredScreen(),
      };
}
