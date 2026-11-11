import '../models/asociado.dart';
import '../models/conductor.dart';
import '../models/vehiculo.dart';
import '../models/afiliacion.dart';
import '../models/sancion.dart';
import '../models/tarifa.dart';
import '../models/planilla.dart';
import '../models/despacho.dart';
import '../models/ruta.dart';

/// Fuente de datos en memoria (mock) que simula la información que,
/// en una fase posterior, vendría de una API/backend real.
/// Se usa un patrón singleton para compartir el estado entre pantallas.
class MockDatabase {
  MockDatabase._internal() {
    _seed();
  }
  static final MockDatabase instance = MockDatabase._internal();

  final List<Asociado> asociados = [];
  final List<Conductor> conductores = [];
  final List<Vehiculo> vehiculos = [];
  final List<Afiliacion> afiliaciones = [];
  final List<Sancion> sanciones = [];
  final List<Tarifa> tarifas = [];
  final List<Planilla> planillas = [];
  final List<Despacho> despachos = [];
  final List<Ruta> rutas = [];

  static const String origenRuta = 'Sincelejo';
  static const String destinoRuta = 'Sampués';

  void _seed() {
    final now = DateTime.now();

    conductores.addAll([
      Conductor(
        id: 'c1',
        identificacion: '1.002.334.552',
        nombres: 'Diego Torres Múnera',
        fechaNacimiento: DateTime(1990, 9, 30),
        activo: true,
        celular: '301 456 7890',
        correo: 'diego.torres@mail.com',
        numeroLicencia: '70234456',
        categoriaLicencia: 'C2',
        vigenciaLicencia: DateTime(2028, 3, 15),
        fechaRegistro: DateTime(2019, 5, 10),
        ultimaActualizacion: now,
      ),
      Conductor(
        id: 'c2',
        identificacion: '1.098.771.223',
        nombres: 'Carlos Andrade Ruiz',
        fechaNacimiento: DateTime(1985, 2, 11),
        activo: true,
        celular: '302 887 1122',
        correo: 'carlos.andrade@mail.com',
        numeroLicencia: '70298871',
        categoriaLicencia: 'C1',
        vigenciaLicencia: DateTime(2027, 11, 2),
        fechaRegistro: DateTime(2020, 1, 20),
        ultimaActualizacion: now,
      ),
      Conductor(
        id: 'c3',
        identificacion: '9.887.221.10',
        nombres: 'Luis Pardo Gómez',
        fechaNacimiento: DateTime(1982, 7, 4),
        activo: true,
        celular: '300 112 2334',
        correo: 'luis.pardo@mail.com',
        numeroLicencia: '70988722',
        categoriaLicencia: 'C2',
        vigenciaLicencia: DateTime(2026, 6, 18),
        fechaRegistro: DateTime(2018, 3, 2),
        ultimaActualizacion: now,
      ),
    ]);

    asociados.addAll([
      Asociado(
        id: 'a1',
        identificacion: '1.045.223.981',
        nombres: 'Camilo',
        apellidos: 'Restrepo Ávila',
        activo: true,
        celular: '300 123 4567',
        correo: 'camilo.restrepo@mail.com',
        fechaNacimiento: DateTime(1988, 4, 12),
        fechaIngreso: DateTime(2021, 2, 3),
        placaVehiculo: 'ABC-123',
        fechaRegistro: DateTime(2021, 2, 3),
        ultimaActualizacion: now,
      ),
      Asociado(
        id: 'a2',
        identificacion: '1.098.771.223',
        nombres: 'María Fernanda',
        apellidos: 'Ruiz Bustos',
        activo: true,
        celular: '301 887 1123',
        correo: 'mafe.ruiz@mail.com',
        fechaNacimiento: DateTime(1992, 10, 5),
        fechaIngreso: DateTime(2022, 6, 21),
        placaVehiculo: 'DEF-456',
        fechaRegistro: DateTime(2022, 6, 21),
        ultimaActualizacion: now,
      ),
      Asociado(
        id: 'a3',
        identificacion: '9.887.221.10',
        nombres: 'Jorge Enrique',
        apellidos: 'Páez Lara',
        activo: false,
        celular: '300 998 7721',
        correo: 'jorge.paez@mail.com',
        fechaNacimiento: DateTime(1979, 1, 30),
        fechaIngreso: DateTime(2019, 1, 1),
        placaVehiculo: 'GHI-789',
        fechaRegistro: DateTime(2019, 1, 1),
        ultimaActualizacion: now,
      ),
    ]);

    vehiculos.addAll([
      Vehiculo(
        id: 'v1',
        placa: 'ABC-123',
        tipo: 'Buseta',
        marca: 'Chevrolet NPR',
        modelo: '2019',
        capacidad: 19,
        tarjetaPropiedad: 'TP-88213',
        conductorId: 'c1',
        tarifaId: 't1',
        estado: EstadoVehiculo.activo,
        vigenciaSoat: DateTime(2027, 3, 22),
        vigenciaTrm: DateTime(2027, 6, 10),
        fechaIngreso: DateTime(2019, 1, 12),
        fechaRegistro: DateTime(2019, 1, 12),
        ultimaActualizacion: now,
      ),
      Vehiculo(
        id: 'v2',
        placa: 'DEF-456',
        tipo: 'Automóvil',
        marca: 'Renault Logan',
        modelo: '2021',
        capacidad: 4,
        tarjetaPropiedad: 'TP-44102',
        conductorId: 'c2',
        tarifaId: 't1',
        estado: EstadoVehiculo.activo,
        vigenciaSoat: DateTime(2027, 1, 15),
        vigenciaTrm: DateTime(2027, 4, 2),
        fechaIngreso: DateTime(2021, 3, 9),
        fechaRegistro: DateTime(2021, 3, 9),
        ultimaActualizacion: now,
      ),
      Vehiculo(
        id: 'v3',
        placa: 'GHI-789',
        tipo: 'Buseta',
        marca: 'Hyundai H1',
        modelo: '2017',
        capacidad: 11,
        tarjetaPropiedad: 'TP-22871',
        conductorId: 'c3',
        tarifaId: 't2',
        estado: EstadoVehiculo.mantenimiento,
        vigenciaSoat: DateTime(2026, 12, 1),
        vigenciaTrm: DateTime(2027, 2, 20),
        fechaIngreso: DateTime(2017, 8, 14),
        fechaRegistro: DateTime(2017, 8, 14),
        ultimaActualizacion: now,
        motivoMantenimiento: 'Cambio de frenos y revisión general',
      ),
    ]);

    afiliaciones.addAll([
      Afiliacion(
        id: 'af1',
        asociadoId: 'a1',
        vehiculoId: 'v1',
        fechaAfiliacion: DateTime(2021, 2, 3),
        estado: EstadoAfiliacion.vigente,
        fechaRegistro: DateTime(2021, 2, 3),
        ultimaActualizacion: now,
      ),
      Afiliacion(
        id: 'af2',
        asociadoId: 'a2',
        vehiculoId: 'v2',
        fechaAfiliacion: DateTime(2022, 6, 21),
        estado: EstadoAfiliacion.vigente,
        fechaRegistro: DateTime(2022, 6, 21),
        ultimaActualizacion: now,
      ),
      Afiliacion(
        id: 'af3',
        asociadoId: 'a3',
        vehiculoId: 'v3',
        fechaAfiliacion: DateTime(2019, 1, 1),
        fechaFin: DateTime(2025, 5, 30),
        estado: EstadoAfiliacion.finalizada,
        fechaRegistro: DateTime(2019, 1, 1),
        ultimaActualizacion: now,
      ),
    ]);

    sanciones.addAll([
      Sancion(
        id: 's1',
        conductorId: 'c1',
        fechaInicial: now.subtract(const Duration(days: 2)),
        fechaFinal: now.add(const Duration(days: 7)),
        motivo: 'Documentación vencida',
        observaciones: 'Se solicitó actualizar SOAT y licencia.',
        registradoPor: 'Laura Restrepo (Gerente)',
        fechaRegistro: now.subtract(const Duration(days: 2)),
      ),
      Sancion(
        id: 's2',
        conductorId: 'c2',
        fechaInicial: now.add(const Duration(days: 10)),
        fechaFinal: now.add(const Duration(days: 20)),
        motivo: 'Reporte de usuario',
        observaciones: 'Queja por exceso de pasajeros.',
        registradoPor: 'Laura Restrepo (Gerente)',
        fechaRegistro: now,
      ),
      Sancion(
        id: 's3',
        conductorId: 'c3',
        fechaInicial: DateTime(2026, 1, 1),
        fechaFinal: DateTime(2026, 1, 15),
        motivo: 'Exceso de velocidad',
        observaciones: 'Comparendo de tránsito municipal.',
        registradoPor: 'Ana Gómez (Asistente)',
        fechaRegistro: DateTime(2026, 1, 1),
      ),
    ]);

    tarifas.addAll([
      Tarifa(
        id: 't1',
        nombre: 'Tarifa estándar',
        aportesGastosVarios: 3000,
        fondoReposicion: 3500,
        aporteSocial: 2000,
        activo: true,
        fechaRegistro: DateTime(2024, 2, 1),
      ),
      Tarifa(
        id: 't2',
        nombre: 'Tarifa preferencial',
        aportesGastosVarios: 2200,
        fondoReposicion: 2500,
        aporteSocial: 1500,
        activo: true,
        fechaRegistro: DateTime(2024, 5, 14),
      ),
      Tarifa(
        id: 't3',
        nombre: 'Tarifa especial 2025',
        aportesGastosVarios: 2800,
        fondoReposicion: 2700,
        aporteSocial: 1500,
        activo: false,
        fechaRegistro: DateTime(2025, 1, 10),
      ),
    ]);

    rutas.addAll([
      Ruta(id: 'r1', origen: origenRuta, destino: destinoRuta, sentido: SentidoRuta.ida, activa: true, tarifa: 8500),
      Ruta(id: 'r2', origen: origenRuta, destino: destinoRuta, sentido: SentidoRuta.vuelta, activa: true, tarifa: 8500),
    ]);

    despachos.addAll([
      Despacho(id: 'd1', sentido: SentidoRuta.ida, vehiculoId: 'v1', fecha: now, hora: '07:40 a.m.', numeroPasajeros: 14, fechaRegistro: now),
      Despacho(id: 'd2', sentido: SentidoRuta.vuelta, vehiculoId: 'v2', fecha: now, hora: '06:15 p.m.', numeroPasajeros: 9, fechaRegistro: now),
    ]);

    planillas.addAll([
      Planilla(id: 'p1', numero: '0231', fecha: now, hora: '07:40 a.m.', vehiculoId: 'v1', conductorId: 'c1', tarifaId: 't1', tipo: 'Diaria', sentido: SentidoRuta.ida, estado: EstadoPlanilla.pagada, fechaPago: now, metodoPago: 'Efectivo'),
      Planilla(id: 'p2', numero: '0232', fecha: now, hora: '08:10 a.m.', vehiculoId: 'v2', conductorId: 'c2', tarifaId: 't1', tipo: 'Diaria', sentido: SentidoRuta.vuelta, estado: EstadoPlanilla.pendiente),
      Planilla(id: 'p3', numero: '0198', fecha: now.subtract(const Duration(days: 2)), hora: '07:35 a.m.', vehiculoId: 'v3', conductorId: 'c3', tarifaId: 't2', tipo: 'Diaria', sentido: SentidoRuta.ida, estado: EstadoPlanilla.anulada, motivoAnulacion: 'Vehículo fuera de servicio'),
    ]);
  }

  // Helpers de búsqueda rápidos usados por los servicios.
  Conductor? conductorById(String id) {
    for (final c in conductores) {
      if (c.id == id) return c;
    }
    return null;
  }

  Vehiculo? vehiculoById(String id) {
    for (final v in vehiculos) {
      if (v.id == id) return v;
    }
    return null;
  }

  Asociado? asociadoById(String id) {
    for (final a in asociados) {
      if (a.id == id) return a;
    }
    return null;
  }

  Tarifa? tarifaById(String id) {
    for (final t in tarifas) {
      if (t.id == id) return t;
    }
    return null;
  }

  List<Sancion> sancionesDeConductor(String conductorId) =>
      sanciones.where((s) => s.conductorId == conductorId).toList();

  bool conductorSancionado(String conductorId) => sancionesDeConductor(conductorId)
      .any((s) => s.estadoActual() == EstadoSancion.vigente);
}
