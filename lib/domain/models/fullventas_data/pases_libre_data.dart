import 'dart:convert';

List<PasesLibreData> paseslibresDataFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => PasesLibreData.fromJson(item)).toList();
}

String paseslibresDataToJson(PasesLibreData? data) =>
    json.encode(data!.toJson());

class PasesLibreData {
  const PasesLibreData({
    this.id,
    this.FechaCanjeInicio,
    this.FechaCanjeFinal,
    this.NombrePase,
    this.Descripcion,
    this.Stock,
    this.StockDisponible,
    this.Estado,
    this.user_id,
  });

  final int? id;
  final DateTime? FechaCanjeInicio;
  final DateTime? FechaCanjeFinal;
  final String? NombrePase;
  final String? Descripcion;
  final int? Stock;
  final int? StockDisponible;
  final int? Estado;
  final int? user_id;

  factory PasesLibreData.fromJson(Map<String, dynamic> json) => PasesLibreData(
        id: int.tryParse(json['id'].toString()) ?? 0,
        FechaCanjeInicio: json['FechaCanjeInicio'] != null
            ? DateTime.tryParse(json['FechaCanjeInicio'])
            : null,
        FechaCanjeFinal: json['FechaCanjeFinal'] != null
            ? DateTime.tryParse(json['FechaCanjeFinal'])
            : null,
        NombrePase: json['NombrePase'] as String?,
        Descripcion: json['Descripcion'] as String?,
        Stock: int.tryParse(json['Stock'].toString()) ?? 0,
        StockDisponible: int.tryParse(json['StockDisponible'].toString()) ?? 0,
        Estado: int.tryParse(json['Estado'].toString()) ?? 0,
        user_id: int.tryParse(json['user_id'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "FechaCanjeInicio": FechaCanjeInicio,
        "FechaCanjeFinal": FechaCanjeFinal,
        "NombrePase": NombrePase,
        "Descripcion": Descripcion,
        "Stock": Stock,
        "StockDisponible": StockDisponible,
        "Estado": Estado,
        "user_id": user_id,
      };
}
