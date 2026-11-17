import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasServerError = false;

  List<AssociateModel> associates = [];
  List<AffiliationModel> affiliations = [
    AffiliationModel(
      id: '1',
      codigo: 'AF-8989',
      asociado: 'Maria Corrales Pedrozo',
      vehiculo: 'ABD-432',
      fechaInicio: '03/02/2021',
      vigente: true,
    ),
    AffiliationModel(
      id: '2',
      codigo: 'AF-9012',
      asociado: 'Luis Adrian Berrio',
      vehiculo: 'HDR-765',
      fechaInicio: '21/06/2022',
      vigente: true,
    ),
  ];

  List<DriverModel> drivers = [
    DriverModel(
      id: '1',
      identificacion: '1.002.334.552',
      nombre: 'Diego Torres Múnera',
      fechaNacimiento: '30/09/1990',
      celular: '301 458 7890',
      correo: 'diego.torres@mail.com',
      numeroLicencia: '70234456',
      categoria: 'C2',
      vigenciaLicencia: '15/03/2028',
      estado: 'Sancionado',
    ),
  ];

  List<SanctionModel> sanctions = [
    SanctionModel(
      id: '1',
      conductor: 'Diego Torres Múnera',
      identificacion: '1.002.334.552',
      fechaInicio: '19/08/2026',
      fechaFin: '26/09/2026',
      motivo: 'Documentación vencida',
      observaciones: 'Se solicitó actualizar SOAT y licencia.',
      estado: 'Vigente',
    ),
  ];

  List<VehicleModel> vehicles = [];

  List<FareModel> fares = [
    FareModel(
      id: '1',
      nombre: 'Tarifa estandar',
      gastosVarios: 2000,
      fondoReposicion: 2500,
      aporteSocial: 1000,
      activa: true,
    ),
    FareModel(
      id: '2',
      nombre: 'Tarifa preferencial',
      gastosVarios: 1500,
      fondoReposicion: 2000,
      aporteSocial: 1000,
      activa: true,
    ),
  ];

  List<SheetModel> sheets = [
    SheetModel(
      id: '1',
      numero: '#0314',
      placa: 'ABC-123',
      conductor: 'Diego Torres Múnera',
      fecha: '18/09/2026 - 07:40 a.m.',
      valor: 5500,
      estado: 'Pagada',
    ),
    SheetModel(
      id: '2',
      numero: '#0232',
      placa: 'DEF-456',
      conductor: 'Carlos Andrade',
      fecha: '19/09/2026 - 08:10 a.m.',
      valor: 5500,
      estado: 'Pendiente',
    ),
  ];

  List<DispatchModel> dispatches = [
    DispatchModel(
      id: '1',
      codigo: 'DSP-1042',
      ruta: 'Sincelejo - Sampués',
      placa: 'ABC-123',
      pasajeros: 14,
      fecha: '19/09/2026',
      hora: '07:40 a.m.',
      estado: 'Despachado',
    ),
    DispatchModel(
      id: '2',
      codigo: 'DSP-1043',
      ruta: 'Sampués - Sincelejo',
      placa: 'DEF-456',
      pasajeros: 11,
      fecha: '19/09/2026',
      hora: '08:10 a.m.',
      estado: 'Programado',
    ),
  ];

  Future<void> fetchInitialData({bool simulateError = false}) async {
    isLoading = true;
    hasServerError = false;
    notifyListeners();

    try {
      if (simulateError) {
        await Future.delayed(const Duration(milliseconds: 500));
        throw Exception('Simulated network error');
      }
      associates = await ApiService.getAssociates();
      vehicles = await ApiService.getVehicles();
    } catch (_) {
      hasServerError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- ASOCIADOS ---
  Future<void> addAssociate(AssociateModel item) async {
    final created = await ApiService.createAssociate(item);
    associates.insert(0, created);
    notifyListeners();
  }

  Future<void> editAssociate(AssociateModel updated) async {
    final res = await ApiService.updateAssociate(updated);
    final idx = associates.indexWhere((a) => a.id == res.id);
    if (idx != -1) {
      associates[idx] = res;
      notifyListeners();
    }
  }

  void toggleAssociateStatus(String id) {
    final idx = associates.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = associates[idx];
      associates[idx] = AssociateModel(
        id: old.id,
        identificacion: old.identificacion,
        nombre: old.nombre,
        celular: old.celular,
        correo: old.correo,
        fechaNacimiento: old.fechaNacimiento,
        fechaIngreso: old.fechaIngreso,
        placaVehiculo: old.placaVehiculo,
        activo: !old.activo,
      );
      notifyListeners();
    }
  }

  // --- AFILIACIONES ---
  void endAffiliation(String id) {
    final idx = affiliations.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = affiliations[idx];
      affiliations[idx] = AffiliationModel(
        id: old.id,
        codigo: old.codigo,
        asociado: old.asociado,
        vehiculo: old.vehiculo,
        fechaInicio: old.fechaInicio,
        fechaFin: '19/09/2026',
        vigente: false,
      );
      notifyListeners();
    }
  }

  // --- CONDUCTORES Y SANCIONES ---
  Future<void> addDriver(DriverModel item) async {
    final created = await ApiService.createDriver(item);
    drivers.insert(0, created);
    notifyListeners();
  }

  void updateDriver(DriverModel updated) {
    final idx = drivers.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      drivers[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> addSanction(SanctionModel item) async {
    final created = await ApiService.createSanction(item);
    sanctions.insert(0, created);
    final dIdx = drivers.indexWhere((d) => d.nombre.toLowerCase() == item.conductor.toLowerCase());
    if (dIdx != -1) {
      final old = drivers[dIdx];
      drivers[dIdx] = DriverModel(
        id: old.id,
        identificacion: old.identificacion,
        nombre: old.nombre,
        fechaNacimiento: old.fechaNacimiento,
        celular: old.celular,
        correo: old.correo,
        numeroLicencia: old.numeroLicencia,
        categoria: old.categoria,
        vigenciaLicencia: old.vigenciaLicencia,
        estado: 'Sancionado',
      );
    }
    notifyListeners();
  }

  // --- VEHÍCULOS ---
  Future<void> addVehicle(VehicleModel item) async {
    final created = await ApiService.createVehicle(item);
    vehicles.insert(0, created);
    notifyListeners();
  }

  void updateVehicle(VehicleModel updated) {
    final idx = vehicles.indexWhere((v) => v.id == updated.id);
    if (idx != -1) {
      vehicles[idx] = updated;
      notifyListeners();
    }
  }

  // --- TARIFAS ---
  Future<void> addFare(FareModel item) async {
    final created = await ApiService.createFare(item);
    fares.insert(0, created);
    notifyListeners();
  }

  void toggleFareStatus(String id) {
    final idx = fares.indexWhere((f) => f.id == id);
    if (idx != -1) {
      final old = fares[idx];
      fares[idx] = FareModel(
        id: old.id,
        nombre: old.nombre,
        gastosVarios: old.gastosVarios,
        fondoReposicion: old.fondoReposicion,
        aporteSocial: old.aporteSocial,
        activa: !old.activa,
      );
      notifyListeners();
    }
  }

  // --- PLANILLAS ---
  void generateSheets(List<String> placas, String fecha, int valor) {
    for (final placa in placas) {
      final num = 315 + sheets.length;
      sheets.insert(
        0,
        SheetModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + placa,
          numero: '#0$num',
          placa: placa.split(' ').first,
          conductor: placa,
          fecha: fecha,
          valor: valor,
          estado: 'Pendiente',
        ),
      );
    }
    notifyListeners();
  }

  void paySheet(String id) {
    final idx = sheets.indexWhere((s) => s.id == id);
    if (idx != -1) {
      final old = sheets[idx];
      sheets[idx] = SheetModel(
        id: old.id,
        numero: old.numero,
        placa: old.placa,
        conductor: old.conductor,
        fecha: old.fecha,
        valor: old.valor,
        estado: 'Pagada',
      );
      notifyListeners();
    }
  }

  void cancelSheet(String id) {
    final idx = sheets.indexWhere((s) => s.id == id);
    if (idx != -1) {
      final old = sheets[idx];
      sheets[idx] = SheetModel(
        id: old.id,
        numero: old.numero,
        placa: old.placa,
        conductor: old.conductor,
        fecha: old.fecha,
        valor: old.valor,
        estado: 'Anulada',
      );
      notifyListeners();
    }
  }

  // --- DESPACHOS ---
  Future<void> addDispatch(DispatchModel item) async {
    final created = await ApiService.createDispatch(item);
    dispatches.insert(0, created);
    notifyListeners();
  }
}
