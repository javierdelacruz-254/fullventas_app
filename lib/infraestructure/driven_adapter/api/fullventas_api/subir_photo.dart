import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fullventas_app/domain/models/fullventas_data/subir_photo.dart';

class FotoService {
  final String baseUrl;
  final Duration timeout;
  final int userId; // ID hardcodeado según requerimiento

  FotoService({
    this.baseUrl =
        'http://localhost/mystore/gull_ventas_php_project/comunidad/',
    this.timeout = const Duration(milliseconds: 90000),
    this.userId = 10,
  });

  Future<int> getWeeklyCount() async {
    final response = await http
        .get(Uri.parse('$baseUrl/user/$userId/weekly'))
        .timeout(timeout);
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body)['fotos_semanales'];
    }
    throw Exception('Error al obtener conteo semanal');
  }

  Future<List<Foto>> getUserPhotos() async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/$userId')).timeout(timeout);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Foto.fromJson(item)).toList();
    }
    throw Exception('Error al cargar fotos');
  }

  /// **Subir foto en formato Base64**
  Future<Foto> uploadPhoto(File imageFile) async {
    // Convertir la imagen a Base64
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'description': 'Nueva foto',
            'cliente_id': userId,
            'fotoUrl': base64Image, // Guardamos la imagen en Base64
            'estado': "pendiente",
            'fecha_creacion': DateTime.now().toIso8601String(),
          }),
        )
        .timeout(timeout);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Foto.fromJson(json.decode(response.body)['foto']);
    }
    throw Exception('Error al subir foto');
  }
}
