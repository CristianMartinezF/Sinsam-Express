import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class ApiService {
  // CAMBIA ESTA URL POR LA DEL SERVIDOR (ej. http://10.0.2.2:8000/api para emulador Android)
  static const String baseUrl = 'https://tu-api.sinsamexpress.com/api';
  static String? authToken;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // ==================== AUTENTICACIÓN ====================
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authToken = data['token'];
      return true;
    }
    return false;
  }

  // ==================== ASOCIADOS ====================
  static Future<List<AssociateModel>> getAssociates() async {
    final response = await http.get(Uri.parse('$baseUrl/asociados'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => AssociateModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar asociados (${response.statusCode})');
  }

  static Future<AssociateModel> createAssociate(AssociateModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/asociados'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return AssociateModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear asociado');
  }

  static Future<AssociateModel> updateAssociate(AssociateModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/asociados/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return AssociateModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar asociado');
  }

  // ==================== AFILIACIONES ====================
  static Future<List<AffiliationModel>> getAffiliations() async {
    final response = await http.get(Uri.parse('$baseUrl/afiliaciones'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => AffiliationModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar afiliaciones');
  }

  // ==================== CONDUCTORES ====================
  static Future<List<DriverModel>> getDrivers() async {
    final response = await http.get(Uri.parse('$baseUrl/conductores'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => DriverModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar conductores');
  }

  static Future<DriverModel> createDriver(DriverModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/conductores'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DriverModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al registrar conductor');
  }

  static Future<DriverModel> updateDriver(DriverModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/conductores/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return DriverModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar conductor');
  }

  // ==================== SANCIONES ====================
  static Future<List<SanctionModel>> getSanctions() async {
    final response = await http.get(Uri.parse('$baseUrl/sanciones'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => SanctionModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar sanciones');
  }

  static Future<SanctionModel> createSanction(SanctionModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sanciones'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return SanctionModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al registrar sanción');
  }

  // ==================== VEHÍCULOS ====================
  static Future<List<VehicleModel>> getVehicles() async {
    final response = await http.get(Uri.parse('$baseUrl/vehiculos'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => VehicleModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar vehículos');
  }

  static Future<VehicleModel> createVehicle(VehicleModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehiculos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return VehicleModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al registrar vehículo');
  }

  static Future<VehicleModel> updateVehicle(VehicleModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehiculos/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return VehicleModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar vehículo');
  }

  // ==================== TARIFAS ====================
  static Future<List<FareModel>> getFares() async {
    final response = await http.get(Uri.parse('$baseUrl/tarifas'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => FareModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar tarifas');
  }

  static Future<FareModel> createFare(FareModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tarifas'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FareModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear tarifa');
  }

  // ==================== PLANILLAS ====================
  static Future<List<SheetModel>> getSheets() async {
    final response = await http.get(Uri.parse('$baseUrl/planillas'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => SheetModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar planillas');
  }

  // ==================== DESPACHOS ====================
  static Future<List<DispatchModel>> getDispatches() async {
    final response = await http.get(Uri.parse('$baseUrl/despachos'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => DispatchModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar despachos');
  }

  static Future<DispatchModel> createDispatch(DispatchModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/despachos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DispatchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al registrar despacho');
  }
}
