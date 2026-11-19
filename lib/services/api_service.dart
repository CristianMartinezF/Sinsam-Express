import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class ApiService {
  static const String baseUrl = 'https://api.sitram.cecar.cloud/api';
  static String? authToken;
  static String userRole = '';

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  static String _extractRoleFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      final normalized = base64Url.normalize(parts[1]);
      final payload = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      if (payload is Map<String, dynamic>) {
        final rawRole = payload['rol'] ??
            payload['role'] ??
            payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
            '';
        return rawRole.toString().toUpperCase();
      }
    } catch (_) {}
    return '';
  }

  static List<dynamic> _extractItems(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic> && data['items'] is List) {
        return data['items'] as List<dynamic>;
      }
      if (decoded['items'] is List) return decoded['items'] as List<dynamic>;
    }
    return [];
  }

  static Map<String, dynamic> _extractObject(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map<String, dynamic>) {
        return decoded['data'] as Map<String, dynamic>;
      }
      return decoded;
    }
    return {};
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'] is Map<String, dynamic>
            ? decoded['data'] as Map<String, dynamic>
            : decoded;
        authToken = data['token'] ?? data['accessToken'] ?? decoded['token'];
        final explicitRole =
            (data['rol'] ?? data['role'] ?? decoded['rol'] ?? '').toString().toUpperCase();
        userRole = explicitRole.isNotEmpty
            ? explicitRole
            : (authToken != null ? _extractRoleFromJwt(authToken!) : '');
      }
      return true;
    }
    return false;
  }

  static Future<List<AssociateModel>> getAssociates() async {
    final response = await http.get(Uri.parse('$baseUrl/asociados'), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
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
      return AssociateModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al crear asociado');
  }

  static Future<AssociateModel> updateAssociate(AssociateModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/asociados/${item.identificacion}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return AssociateModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al actualizar asociado');
  }

  static Future<List<AffiliationModel>> getAffiliations() async {
    final response = await http.get(Uri.parse('$baseUrl/afiliaciones'), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
      return list.map((e) => AffiliationModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar afiliaciones');
  }

  static Future<List<DriverModel>> getDrivers() async {
    final response = await http.get(Uri.parse('$baseUrl/conductores'), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
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
      return DriverModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al registrar conductor');
  }

  static Future<DriverModel> updateDriver(DriverModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/conductores/${item.identificacion}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return DriverModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al actualizar conductor');
  }

  static Future<List<SanctionModel>> getSanctions() async {
    final response = await http.get(Uri.parse('$baseUrl/sanciones'), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
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
      return SanctionModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al registrar sanción');
  }

  static Future<List<VehicleModel>> getVehicles() async {
    final endpoint =
        userRole == 'ASOCIADO' ? '$baseUrl/mi-cuenta/vehiculos' : '$baseUrl/vehiculos';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
      return list.map((e) => VehicleModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar vehículos (${response.statusCode})');
  }

  static Future<VehicleModel> createVehicle(VehicleModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehiculos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return VehicleModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al registrar vehículo');
  }

  static Future<VehicleModel> updateVehicle(VehicleModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehiculos/${item.placa}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return VehicleModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al actualizar vehículo');
  }

  static Future<List<FareModel>> getFares() async {
    final response = await http.get(Uri.parse('$baseUrl/tarifas'), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
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
      return FareModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al crear tarifa');
  }

  static Future<List<SheetModel>> getSheets() async {
    final endpoint =
        userRole == 'ASOCIADO' ? '$baseUrl/mi-cuenta/viajes' : '$baseUrl/planillas';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
      return list.map((e) => SheetModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar planillas (${response.statusCode})');
  }

  static Future<List<DispatchModel>> getDispatches() async {
    final endpoint =
        userRole == 'ASOCIADO' ? '$baseUrl/mi-cuenta/despachos' : '$baseUrl/despachos';
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    if (response.statusCode == 200) {
      final list = _extractItems(response.body);
      return list.map((e) => DispatchModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar despachos (${response.statusCode})');
  }

  static Future<DispatchModel> createDispatch(DispatchModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/despachos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return DispatchModel.fromJson(_extractObject(response.body));
    }
    throw Exception('Error al registrar despacho');
  }
}