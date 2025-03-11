import 'dart:convert';

List<ClienteData> clienteDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => ClienteData.fromJson(item)).toList();
}

String clienteDataToJson(ClienteData? data) => json.encode(data!.toJson());

class ClienteData {
  const ClienteData({
    this.id,
    this.user_id,
    this.codigo,
    this.nombres,
    this.celular,
    this.email,
    this.direccion,
    this.tipo_cliente,
    this.image_name,
    this.status,
    this.apellidos,
    this.imagen,
    this.fecha_pago,
    this.tipo_membresia,
  });

  final int? id;
  final int? user_id;
  final String? codigo;
  final String? nombres;
  final int? celular;
  final String? email;
  final String? direccion;
  final String? tipo_cliente;
  final String? image_name;
  final int? status;
  final String? apellidos;
  final String? imagen;
  final DateTime? fecha_pago;
  final String? tipo_membresia;

  factory ClienteData.fromJson(Map<String, dynamic> json) => ClienteData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
        codigo: json['codigo'] as String?,
        nombres: json['nombres'] as String?,
        celular: int.tryParse(json['celular'].toString()) ?? 0,
        email: json['email'] as String?,
        direccion: json['direccion'] as String?,
        tipo_cliente: json['tipo_cliente'] as String?,
        image_name: json['image_name'] as String?,
        status: int.tryParse(json['status'].toString()) ?? 0,
        apellidos: json['apellidos'] as String?,
        imagen: json['imagen'] as String?,
        fecha_pago: json['fecha_pago'] != null
            ? DateTime.tryParse(json['fecha_pago'])
            : null,
        tipo_membresia: json['tipo_membresia'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "codigo": codigo,
        "nombres": nombres,
        "celular": celular,
        "email": email,
        "direccion": direccion,
        "tipo_cliente": tipo_cliente,
        "image_name": image_name,
        "status": status,
        "apellidos": apellidos,
        "imagen": imagen,
        "fecha_pago": fecha_pago,
        "tipo_membresia": tipo_membresia,
      };
}
