class AssociateModel {
  final String id;
  final String identificacion;
  final String nombre;
  final String celular;
  final String correo;
  final String fechaNacimiento;
  final String fechaIngreso;
  final String placaVehiculo;
  final bool activo;

  AssociateModel({
    required this.id,
    required this.identificacion,
    required this.nombre,
    required this.celular,
    required this.correo,
    required this.fechaNacimiento,
    required this.fechaIngreso,
    this.placaVehiculo = '',
    required this.activo,
  });

  factory AssociateModel.fromJson(Map<String, dynamic> json) => AssociateModel(
        id: json['id'].toString(),
        identificacion: json['identificacion'] ?? '',
        nombre: json['nombre'] ?? '',
        celular: json['celular'] ?? '',
        correo: json['correo'] ?? '',
        fechaNacimiento: json['fecha_nacimiento'] ?? '',
        fechaIngreso: json['fecha_ingreso'] ?? '',
        placaVehiculo: json['placa_vehiculo'] ?? '',
        activo: json['activo'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'identificacion': identificacion,
        'nombre': nombre,
        'celular': celular,
        'correo': correo,
        'fecha_nacimiento': fechaNacimiento,
        'fecha_ingreso': fechaIngreso,
        'placa_vehiculo': placaVehiculo,
        'activo': activo,
      };
}

class AffiliationModel {
  final String id;
  final String codigo;
  final String asociado;
  final String vehiculo;
  final String fechaInicio;
  final String fechaFin;
  final bool vigente;

  AffiliationModel({
    required this.id,
    required this.codigo,
    required this.asociado,
    required this.vehiculo,
    required this.fechaInicio,
    this.fechaFin = '-',
    required this.vigente,
  });

  factory AffiliationModel.fromJson(Map<String, dynamic> json) => AffiliationModel(
        id: json['id'].toString(),
        codigo: json['codigo'] ?? '',
        asociado: json['asociado'] ?? '',
        vehiculo: json['vehiculo'] ?? '',
        fechaInicio: json['fecha_inicio'] ?? '',
        fechaFin: json['fecha_fin'] ?? '-',
        vigente: json['vigente'] ?? true,
      );
}

class DriverModel {
  final String id;
  final String identificacion;
  final String nombre;
  final String fechaNacimiento;
  final String celular;
  final String correo;
  final String numeroLicencia;
  final String categoria;
  final String vigenciaLicencia;
  final String estado;

  DriverModel({
    required this.id,
    required this.identificacion,
    required this.nombre,
    required this.fechaNacimiento,
    required this.celular,
    required this.correo,
    required this.numeroLicencia,
    required this.categoria,
    required this.vigenciaLicencia,
    required this.estado,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json['id'].toString(),
        identificacion: json['identificacion'] ?? '',
        nombre: json['nombre'] ?? '',
        fechaNacimiento: json['fecha_nacimiento'] ?? '',
        celular: json['celular'] ?? '',
        correo: json['correo'] ?? '',
        numeroLicencia: json['numero_licencia'] ?? '',
        categoria: json['categoria'] ?? '',
        vigenciaLicencia: json['vigencia_licencia'] ?? '',
        estado: json['estado'] ?? 'Activo',
      );

  Map<String, dynamic> toJson() => {
        'identificacion': identificacion,
        'nombre': nombre,
        'fecha_nacimiento': fechaNacimiento,
        'celular': celular,
        'correo': correo,
        'numero_licencia': numeroLicencia,
        'categoria': categoria,
        'vigencia_licencia': vigenciaLicencia,
        'estado': estado,
      };
}

class SanctionModel {
  final String id;
  final String conductor;
  final String identificacion;
  final String fechaInicio;
  final String fechaFin;
  final String motivo;
  final String observaciones;
  final String estado;

  SanctionModel({
    required this.id,
    required this.conductor,
    required this.identificacion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.motivo,
    required this.observaciones,
    required this.estado,
  });

  factory SanctionModel.fromJson(Map<String, dynamic> json) => SanctionModel(
        id: json['id'].toString(),
        conductor: json['conductor'] ?? '',
        identificacion: json['identificacion'] ?? '',
        fechaInicio: json['fecha_inicio'] ?? '',
        fechaFin: json['fecha_fin'] ?? '',
        motivo: json['motivo'] ?? '',
        observaciones: json['observaciones'] ?? '',
        estado: json['estado'] ?? 'Vigente',
      );

  Map<String, dynamic> toJson() => {
        'conductor': conductor,
        'identificacion': identificacion,
        'fecha_inicio': fechaInicio,
        'fecha_fin': fechaFin,
        'motivo': motivo,
        'observaciones': observaciones,
        'estado': estado,
      };
}

class VehicleModel {
  final String id;
  final String placa;
  final String tipo;
  final String marcaModelo;
  final int capacidad;
  final String conductor;
  final String tarjetaPropiedad;
  final String soat;
  final String trm;
  final String tarifa;
  final String estado;

  VehicleModel({
    required this.id,
    required this.placa,
    required this.tipo,
    required this.marcaModelo,
    required this.capacidad,
    required this.conductor,
    this.tarjetaPropiedad = 'TP-88213',
    required this.soat,
    required this.trm,
    required this.tarifa,
    required this.estado,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'].toString(),
        placa: json['placa'] ?? '',
        tipo: json['tipo'] ?? '',
        marcaModelo: json['marca_modelo'] ?? '',
        capacidad: int.tryParse(json['capacidad'].toString()) ?? 0,
        conductor: json['conductor'] ?? '',
        tarjetaPropiedad: json['tarjeta_propiedad'] ?? '',
        soat: json['soat'] ?? '',
        trm: json['trm'] ?? '',
        tarifa: json['tarifa'] ?? '',
        estado: json['estado'] ?? 'Activa',
      );

  Map<String, dynamic> toJson() => {
        'placa': placa,
        'tipo': tipo,
        'marca_modelo': marcaModelo,
        'capacidad': capacidad,
        'conductor': conductor,
        'tarjeta_propiedad': tarjetaPropiedad,
        'soat': soat,
        'trm': trm,
        'tarifa': tarifa,
        'estado': estado,
      };
}

class FareModel {
  final String id;
  final String nombre;
  final int gastosVarios;
  final int fondoReposicion;
  final int aporteSocial;
  final bool activa;

  int get total => gastosVarios + fondoReposicion + aporteSocial;

  FareModel({
    required this.id,
    required this.nombre,
    required this.gastosVarios,
    required this.fondoReposicion,
    required this.aporteSocial,
    required this.activa,
  });

  factory FareModel.fromJson(Map<String, dynamic> json) => FareModel(
        id: json['id'].toString(),
        nombre: json['nombre'] ?? '',
        gastosVarios: json['gastos_varios'] ?? 0,
        fondoReposicion: json['fondo_reposicion'] ?? 0,
        aporteSocial: json['aporte_social'] ?? 0,
        activa: json['activa'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'gastos_varios': gastosVarios,
        'fondo_reposicion': fondoReposicion,
        'aporte_social': aporteSocial,
        'total': total,
        'activa': activa,
      };
}

class SheetModel {
  final String id;
  final String numero;
  final String placa;
  final String conductor;
  final String fecha;
  final int valor;
  final String estado;

  SheetModel({
    required this.id,
    required this.numero,
    required this.placa,
    required this.conductor,
    required this.fecha,
    required this.valor,
    required this.estado,
  });

  factory SheetModel.fromJson(Map<String, dynamic> json) => SheetModel(
        id: json['id'].toString(),
        numero: json['numero'] ?? '',
        placa: json['placa'] ?? '',
        conductor: json['conductor'] ?? '',
        fecha: json['fecha'] ?? '',
        valor: json['valor'] ?? 0,
        estado: json['estado'] ?? 'Pendiente',
      );
}

class DispatchModel {
  final String id;
  final String codigo;
  final String ruta;
  final String placa;
  final int pasajeros;
  final String fecha;
  final String hora;
  final String estado;

  DispatchModel({
    required this.id,
    required this.codigo,
    required this.ruta,
    required this.placa,
    required this.pasajeros,
    required this.fecha,
    required this.hora,
    required this.estado,
  });

  factory DispatchModel.fromJson(Map<String, dynamic> json) => DispatchModel(
        id: json['id'].toString(),
        codigo: json['codigo'] ?? '',
        ruta: json['ruta'] ?? '',
        placa: json['placa'] ?? '',
        pasajeros: json['pasajeros'] ?? 0,
        fecha: json['fecha'] ?? '',
        hora: json['hora'] ?? '',
        estado: json['estado'] ?? 'Despachado',
      );

  Map<String, dynamic> toJson() => {
        'ruta': ruta,
        'placa': placa,
        'pasajeros': pasajeros,
        'fecha': fecha,
        'hora': hora,
        'estado': estado,
      };
}
