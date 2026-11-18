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
        id: (json['id'] ?? json['identificacion'] ?? '').toString(),
        identificacion: json['identificacion'] ?? '',
        nombre: json['nombres'] ?? json['nombre'] ?? '',
        celular: json['celular'] ?? '',
        correo: json['correo'] ?? '',
        fechaNacimiento: json['fechaNacimiento'] ?? json['fecha_nacimiento'] ?? '',
        fechaIngreso: json['fechaIngreso'] ?? json['fecha_ingreso'] ?? '',
        placaVehiculo: json['placaVehiculo'] ?? json['placa_vehiculo'] ?? '',
        activo: json['activo'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'identificacion': identificacion,
        'nombres': nombre,
        'activo': activo,
        'celular': celular,
        'correo': correo,
        'fechaNacimiento': fechaNacimiento,
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

  factory AffiliationModel.fromJson(Map<String, dynamic> json) {
    final estadoStr = (json['estado'] ?? '').toString().toUpperCase();
    final isVigente = json['vigente'] is bool
        ? json['vigente']
        : (estadoStr == 'ACTIVA' || estadoStr == 'VIGENTE');

    final asociadoText = json['asociado'] is Map
        ? (json['asociado']['nombres'] ?? json['identificacionAsociado'] ?? '')
        : (json['asociado'] ?? json['identificacionAsociado'] ?? '');

    final vehiculoText = json['vehiculo'] is Map
        ? (json['vehiculo']['placa'] ?? json['placaVehiculo'] ?? '')
        : (json['vehiculo'] ?? json['placaVehiculo'] ?? '');

    return AffiliationModel(
      id: (json['id'] ?? '').toString(),
      codigo: json['codigo'] ?? 'AFL-${json['id']}',
      asociado: asociadoText.toString(),
      vehiculo: vehiculoText.toString(),
      fechaInicio: json['fechaAfiliacion'] ?? json['fecha_inicio'] ?? '',
      fechaFin: json['fechaFinAfiliacion']?.toString() ?? json['fecha_fin'] ?? '-',
      vigente: isVigente,
    );
  }
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

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    final isActivo = json['activo'];
    String parsedEstado = 'Activo';
    if (isActivo is bool) {
      parsedEstado = isActivo ? 'Activo' : 'Inactivo';
    } else if (json['estado'] != null) {
      parsedEstado = json['estado'].toString();
    }

    return DriverModel(
      id: (json['id'] ?? json['identificacion'] ?? '').toString(),
      identificacion: json['identificacion'] ?? '',
      nombre: json['nombres'] ?? json['nombre'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] ?? json['fecha_nacimiento'] ?? '',
      celular: json['celular'] ?? '',
      correo: json['correo'] ?? '',
      numeroLicencia: json['numeroLicencia'] ?? json['numero_licencia'] ?? '',
      categoria: json['categoriaLicencia'] ?? json['categoria'] ?? '',
      vigenciaLicencia: json['vigenciaLicencia'] ?? json['vigencia_licencia'] ?? '',
      estado: parsedEstado,
    );
  }

  Map<String, dynamic> toJson() => {
        'identificacion': identificacion,
        'nombres': nombre,
        'fechaNacimiento': fechaNacimiento,
        'activo': estado == 'Activo',
        'numeroLicencia': numeroLicencia,
        'categoriaLicencia': categoria,
        'vigenciaLicencia': vigenciaLicencia,
        'celular': celular,
        'correo': correo,
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
    this.observaciones = '',
    required this.estado,
  });

  factory SanctionModel.fromJson(Map<String, dynamic> json) {
    final conductorText = json['conductor'] is Map
        ? (json['conductor']['nombres'] ?? json['identificacionConductor'] ?? '')
        : (json['conductor'] ?? json['identificacionConductor'] ?? '');

    final parsedFechaInicio = (json['fechaInicio'] ?? json['fecha_inicio'] ?? '').toString();
    final parsedFechaFin = (json['fechaFin'] ?? json['fecha_fin'] ?? '').toString();

    final rawEstado = (json['estado'] ?? '').toString().toUpperCase();
    final endDate = DateTime.tryParse(parsedFechaFin);
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final isExpired = endDate != null && endDate.isBefore(today);

    final parsedEstado = (rawEstado == 'CUMPLIDA' || rawEstado == 'VENCIDA' || isExpired)
        ? 'Vencida'
        : 'Vigente';

    return SanctionModel(
      id: (json['id'] ?? '').toString(),
      conductor: conductorText.toString(),
      identificacion: (json['identificacionConductor'] ?? json['identificacion'] ?? '').toString(),
      fechaInicio: parsedFechaInicio,
      fechaFin: parsedFechaFin,
      motivo: (json['motivo'] ?? '').toString(),
      observaciones: (json['observaciones'] ?? '').toString(),
      estado: parsedEstado,
    );
  }

  Map<String, dynamic> toJson() => {
        'identificacionConductor': identificacion,
        'motivo': motivo,
        'fechaInicio': fechaInicio,
        'fechaFin': fechaFin,
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
    this.tarjetaPropiedad = '',
    required this.soat,
    required this.trm,
    required this.tarifa,
    required this.estado,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    final isActivo = json['activo'];
    String parsedEstado = 'Activa';
    if (isActivo is bool) {
      parsedEstado = isActivo ? 'Activa' : 'Inactiva';
    } else if (json['estado'] != null) {
      parsedEstado = json['estado'].toString();
    }

    final marca = json['marca'] ?? '';
    final modelo = json['modelo'] ?? '';
    final combinedMarcaModelo =
        (marca.toString().isNotEmpty || modelo.toString().isNotEmpty)
            ? '$marca $modelo'.trim()
            : (json['marca_modelo'] ?? '');

    return VehicleModel(
      id: (json['id'] ?? json['placa'] ?? '').toString(),
      placa: json['placa'] ?? '',
      tipo: json['tipo'] ?? '',
      marcaModelo: combinedMarcaModelo,
      capacidad: int.tryParse((json['capacidadPasajeros'] ?? json['capacidad'] ?? 0).toString()) ?? 0,
      conductor: json['conductor'] is Map
          ? (json['conductor']['nombres'] ?? '')
          : (json['conductor'] ?? json['identificacionConductor'] ?? 'Sin asignar'),
      tarjetaPropiedad: json['tarjetaPropiedad'] ?? json['tarjeta_propiedad'] ?? '',
      soat: json['vigenciaSoat'] ?? json['soat'] ?? '',
      trm: json['vigenciaTrm'] ?? json['trm'] ?? '',
      tarifa: json['tarifa'] is Map
          ? (json['tarifa']['nombre'] ?? '')
          : (json['tarifaId']?.toString() ?? json['tarifa'] ?? ''),
      estado: parsedEstado,
    );
  }

  Map<String, dynamic> toJson() {
    final parts = marcaModelo.trim().split(' ');
    final marca = parts.isNotEmpty ? parts.first : marcaModelo;
    final modelo = parts.length > 1 ? parts.sublist(1).join(' ') : '2024';

    return {
      'placa': placa.replaceAll('-', ''),
      'tipo': tipo.toUpperCase(),
      'marca': marca,
      'modelo': modelo,
      'capacidadPasajeros': capacidad,
      'tarjetaPropiedad': tarjetaPropiedad,
      'tarifaId': int.tryParse(tarifa) ?? 13,
      'activo': estado == 'Activa',
      'vigenciaSoat': soat,
      'vigenciaTrm': trm,
      'fechaIngreso': DateTime.now().toString().split(' ').first,
    };
  }
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

  factory FareModel.fromJson(Map<String, dynamic> json) {
    final parsedId = (json['id'] ?? '').toString();
    final gv = (double.tryParse((json['aportesGastosVarios'] ?? json['gastosVarios'] ?? json['gastos_varios'] ?? 0).toString()) ?? 0).round();
    final fr = (double.tryParse((json['fondoReposicion'] ?? json['fondo_reposicion'] ?? 0).toString()) ?? 0).round();
    final asoc = (double.tryParse((json['aporteSocialSocio'] ?? json['aporteSocial'] ?? json['aporte_social'] ?? 0).toString()) ?? 0).round();

    return FareModel(
      id: parsedId,
      nombre: (json['nombre'] != null && json['nombre'].toString().isNotEmpty)
          ? json['nombre'].toString()
          : 'Tarifa #$parsedId',
      gastosVarios: gv,
      fondoReposicion: fr,
      aporteSocial: asoc,
      activa: json['activo'] ?? json['activa'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'aportesGastosVarios': gastosVarios,
        'fondoReposicion': fondoReposicion,
        'aporteSocialSocio': aporteSocial,
        'activo': activa,
      };
}

class SheetModel {
  final String id;
  final String numero;
  final String placa;
  final String conductor;
  final String fecha;
  final String tarifaId;
  final int valor;
  final String estado;

  SheetModel({
    required this.id,
    required this.numero,
    required this.placa,
    required this.conductor,
    required this.fecha,
    this.tarifaId = '',
    required this.valor,
    required this.estado,
  });

  factory SheetModel.fromJson(Map<String, dynamic> json) {
    final rawEstado = (json['estado'] ?? 'ACTIVA').toString().toUpperCase();
    final rawPago = (json['estadoPago'] ?? 'PENDIENTE').toString().toUpperCase();

    String parsedEstado = 'Pendiente';
    if (rawEstado == 'ANULADA') {
      parsedEstado = 'Anulada';
    } else if (rawPago == 'PAGADA' || rawPago == 'PAGADO') {
      parsedEstado = 'Pagada';
    }

    int parsedValor = 0;
    if (json['valorPagado'] != null && (num.tryParse(json['valorPagado'].toString()) ?? 0) > 0) {
      parsedValor = num.parse(json['valorPagado'].toString()).round();
    } else if (json['valor'] != null) {
      parsedValor = num.tryParse(json['valor'].toString())?.round() ?? 0;
    } else if (json['tarifa'] is Map && json['tarifa']['total'] != null) {
      parsedValor = num.tryParse(json['tarifa']['total'].toString())?.round() ?? 0;
    }

    String conductorText = '';
    if (json['conductor'] is Map) {
      conductorText = (json['conductor']['Nombre del conductor'] ??
              json['conductor']['nombres'] ??
              json['conductor']['Identificacion'] ??
              '')
          .toString();
    } else {
      conductorText = (json['conductor'] ?? '').toString();
    }

    final rawNum = (json['numero'] ?? json['id'] ?? '').toString();

    return SheetModel(
      id: rawNum,
      numero: rawNum,
      placa: (json['placaVehiculo'] ?? json['placa'] ?? '').toString(),
      conductor: conductorText,
      fecha: (json['fecha'] ?? '').toString(),
      tarifaId: (json['tarifaId'] ?? '').toString(),
      valor: parsedValor,
      estado: parsedEstado,
    );
  }
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
    this.codigo = '',
    required this.ruta,
    required this.placa,
    required this.pasajeros,
    required this.fecha,
    required this.hora,
    required this.estado,
  });

  factory DispatchModel.fromJson(Map<String, dynamic> json) => DispatchModel(
        id: (json['id'] ?? '').toString(),
        codigo: json['codigo'] ?? 'DSP-${json['id']}',
        ruta: json['ruta'] ?? '',
        placa: json['placaVehiculo'] ?? json['placa'] ?? '',
        pasajeros: int.tryParse((json['numeroPasajeros'] ?? json['pasajeros'] ?? 0).toString()) ?? 0,
        fecha: json['fecha'] ?? '',
        hora: json['hora'] ?? '',
        estado: json['estado'] ?? 'Despachado',
      );

  Map<String, dynamic> toJson() {
    final formattedHora = hora.length == 5 ? '$hora:00' : hora;
    return {
      'ruta': ruta,
      'placaVehiculo': placa.replaceAll('-', ''),
      'hora': formattedHora,
      'fecha': fecha,
      'numeroPasajeros': pasajeros,
    };
  }
}
