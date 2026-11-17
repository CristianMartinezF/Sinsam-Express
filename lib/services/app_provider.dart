import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'api_service.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasServerError = false;

  List<AssociateModel> associates = [];
  List<AffiliationModel> affiliations = [];
  List<DriverModel> drivers = [];
  List<SanctionModel> sanctions = [];
  List<VehicleModel> vehicles = [];
  List<FareModel> fares = [];
  List<SheetModel> sheets = [];
  List<DispatchModel> dispatches = [];

  Future<void> fetchInitialData({bool simulateError = false}) async {
    isLoading = true;
    hasServerError = false;
    notifyListeners();

    try {
      if (simulateError) {
        throw Exception('Simulated network error');
      }

      final results = await Future.wait([
        ApiService.getAssociates(),
        ApiService.getAffiliations(),
        ApiService.getDrivers(),
        ApiService.getSanctions(),
        ApiService.getVehicles(),
        ApiService.getFares(),
        ApiService.getSheets(),
        ApiService.getDispatches(),
      ]);

      associates = results[0] as List<AssociateModel>;
      affiliations = results[1] as List<AffiliationModel>;
      drivers = results[2] as List<DriverModel>;
      sanctions = results[3] as List<SanctionModel>;
      vehicles = results[4] as List<VehicleModel>;
      fares = results[5] as List<FareModel>;
      sheets = results[6] as List<SheetModel>;
      dispatches = results[7] as List<DispatchModel>;
    } catch (_) {
      hasServerError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> toggleAssociateStatus(String id) async {
    final idx = associates.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = associates[idx];
      final updated = AssociateModel(
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
      await editAssociate(updated);
    }
  }

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
        fechaFin: DateTime.now().toString().split(' ').first,
        vigente: false,
      );
      notifyListeners();
    }
  }

  Future<void> addDriver(DriverModel item) async {
    final created = await ApiService.createDriver(item);
    drivers.insert(0, created);
    notifyListeners();
  }

  Future<void> updateDriver(DriverModel updated) async {
    final res = await ApiService.updateDriver(updated);
    final idx = drivers.indexWhere((d) => d.id == res.id);
    if (idx != -1) {
      drivers[idx] = res;
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

  Future<void> addVehicle(VehicleModel item) async {
    final created = await ApiService.createVehicle(item);
    vehicles.insert(0, created);
    notifyListeners();
  }

  Future<void> updateVehicle(VehicleModel updated) async {
    final res = await ApiService.updateVehicle(updated);
    final idx = vehicles.indexWhere((v) => v.id == res.id);
    if (idx != -1) {
      vehicles[idx] = res;
      notifyListeners();
    }
  }

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

  void generateSheets(List<String> placas, String fecha, int valor) {
    for (final placa in placas) {
      final num = 1 + sheets.length;
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

  Future<void> addDispatch(DispatchModel item) async {
    final created = await ApiService.createDispatch(item);
    dispatches.insert(0, created);
    notifyListeners();
  }
}
