import 'dart:convert';

List<ReclamoData> libroReclamoFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => ReclamoData.fromJson(item)).toList();
}

String libroReclamoToJson(ReclamoData data) => json.encode(data.toJson());

class ReclamoData {
  const ReclamoData({
    this.id,
    this.tipoDocumento,
    this.numeroDocumento,
    this.nombresCompletos,
    this.apellidos,
    this.tipoRespuesta,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
    this.telefono,
    this.email,
    this.ordenCompra,
    this.bienContratado,
    this.montoReclamado,
    this.descripcion,
    this.fechaComunicacion,
    this.tipo,
    this.motivo,
    this.detalleReclamo,
    this.pedido,
    this.fecha,
    this.imagen,
  });
  final int? id;
  final String? tipoDocumento;
  final String? numeroDocumento;
  final String? nombresCompletos;
  final String? apellidos;
  final String? tipoRespuesta;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;
  final String? telefono;
  final String? email;
  final String? ordenCompra;
  final String? bienContratado;
  final double? montoReclamado;
  final String? descripcion;
  final DateTime? fechaComunicacion;
  final String? tipo;
  final String? motivo;
  final String? detalleReclamo;
  final String? pedido;
  final DateTime? fecha;
  final String? imagen;

  factory ReclamoData.fromJson(Map<String, dynamic> json) => ReclamoData(
        id: int.tryParse(json['id'].toString()),
        tipoDocumento: json['tipo_documento'] as String?,
        numeroDocumento: json['numero_documento'] as String?,
        nombresCompletos: json['nombres_completos'] as String?,
        apellidos: json['apellidos'] as String?,
        tipoRespuesta: json['tipo_respuesta'] as String?,
        direccion: json['direccion'] as String?,
        departamento: json['departamento'] as String?,
        provincia: json['provincia'] as String?,
        distrito: json['distrito'] as String?,
        telefono: json['telefono'] as String?,
        email: json['email'] as String?,
        ordenCompra: json['orden_compra'] as String?,
        bienContratado: json['bien_contratado'] as String?,
        montoReclamado:
            double.tryParse(json['monto_reclamado'].toString()) ?? 0.0,
        descripcion: json['descripcion'] as String?,
        fechaComunicacion: json['fecha_comunicacion'] != null
            ? DateTime.tryParse(json['fecha_comunicacion'])
            : null,
        tipo: json['tipo'] as String?,
        motivo: json['motivo'] as String?,
        detalleReclamo: json['detalle_reclamo'] as String?,
        pedido: json['pedido'] as String?,
        fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
        imagen: json['imagen'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo_documento": tipoDocumento,
        "numero_documento": numeroDocumento,
        "nombres_completos": nombresCompletos,
        "apellidos": apellidos,
        "tipo_respuesta": tipoRespuesta,
        "direccion": direccion,
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
        "telefono": telefono,
        "email": email,
        "orden_compra": ordenCompra,
        "bien_contratado": bienContratado,
        "monto_reclamado": montoReclamado,
        "descripcion": descripcion,
        "fecha_comunicacion": fechaComunicacion?.toIso8601String(),
        "tipo": tipo,
        "motivo": motivo,
        "detalle_reclamo": detalleReclamo,
        "pedido": pedido,
        "fecha": fecha?.toIso8601String(),
        "imagen": imagen,
      };
}
