import '../models/app_models.dart';

class ApiService {
  //  CAMBIA ESTA URL POR LA DEL SERVIDOR (ej. http://10.0.2.2:8000/api)
  static const String baseUrl = 'https://tu-api.sinsamexpress.com/api';
  static String? authToken;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // ==================== AUTENTICACIÓN ====================
  static Future<bool> login(String email, String password) async {
    /* DESCOMENTAR PARA API REAL:
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
    */
    await Future.delayed(const Duration(milliseconds: 400));
    authToken = 'mock_jwt_token_sinsam';
    return true;
  }

  // ==================== ASOCIADOS ====================
  static Future<List<AssociateModel>> getAssociates() async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.get(Uri.parse('$baseUrl/asociados'), headers: headers);
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => AssociateModel.fromJson(e)).toList();
    }
    throw Exception('Error al cargar asociados');
    */
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AssociateModel(
        id: '1',
        identificacion: '1.049.317.455',
        nombre: 'Maria Corrales Pedrozo',
        celular: '300 364 1210',
        correo: 'Maria.corrales@gmail.com',
        fechaNacimiento: '07/24/2008',
        fechaIngreso: '03/02/2021',
        placaVehiculo: 'ABD-432',
        activo: true,
      ),
      AssociateModel(
        id: '2',
        identificacion: '1.004.645.677',
        nombre: 'Luis Adrian Berrio',
        celular: '310 445 6789',
        correo: 'luis.berrio@gmail.com',
        fechaNacimiento: '14/08/1988',
        fechaIngreso: '21/06/2022',
        placaVehiculo: 'HDR-765',
        activo: true,
      ),
      AssociateModel(
        id: '3',
        identificacion: '1.884.496.317',
        nombre: 'Diomar Monroy',
        celular: '312 889 1122',
        correo: 'diomar.monroy@gmail.com',
        fechaNacimiento: '02/11/1985',
        fechaIngreso: '01/01/2019',
        activo: false,
      ),
    ];
  }

  static Future<AssociateModel> createAssociate(AssociateModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/asociados'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return AssociateModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear asociado');
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  static Future<AssociateModel> updateAssociate(AssociateModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.put(
      Uri.parse('$baseUrl/asociados/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return AssociateModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  // ==================== VEHÍCULOS ====================
  static Future<List<VehicleModel>> getVehicles() async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.get(Uri.parse('$baseUrl/vehiculos'), headers: headers);
    final List list = jsonDecode(response.body);
    return list.map((e) => VehicleModel.fromJson(e)).toList();
    */
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      VehicleModel(
        id: '1',
        placa: 'ABC-123',
        tipo: 'Buseta',
        marcaModelo: 'Chevrolet NPR 2019',
        capacidad: 19,
        conductor: 'Diego Torres Múnera',
        soat: '22/03/2027',
        trm: '10/06/2027',
        tarifa: 'Tarifa estandar \$8.500',
        estado: 'Activa',
      ),
      VehicleModel(
        id: '2',
        placa: 'DEF-456',
        tipo: 'Automovil',
        marcaModelo: 'Renault Logan 2021',
        capacidad: 4,
        conductor: 'Luis Pardo Gómez',
        soat: '15/11/2026',
        trm: '20/12/2026',
        tarifa: 'Tarifa estandar \$8.500',
        estado: 'Activa',
      ),
    ];
  }

  static Future<VehicleModel> createVehicle(VehicleModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/vehiculos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return VehicleModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  // ==================== CONDUCTORES ====================
  static Future<DriverModel> createDriver(DriverModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/conductores'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return DriverModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  // ==================== SANCIONES ====================
  static Future<SanctionModel> createSanction(SanctionModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/sanciones'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return SanctionModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  // ==================== TARIFAS ====================
  static Future<FareModel> createFare(FareModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/tarifas'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return FareModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }

  // ==================== DESPACHOS ====================
  static Future<DispatchModel> createDispatch(DispatchModel item) async {
    /* DESCOMENTAR PARA API REAL:
    final response = await http.post(
      Uri.parse('$baseUrl/despachos'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    return DispatchModel.fromJson(jsonDecode(response.body));
    */
    await Future.delayed(const Duration(milliseconds: 300));
    return item;
  }
}
