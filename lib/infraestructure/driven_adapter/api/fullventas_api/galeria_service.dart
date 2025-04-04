import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fullventas_app/domain/models/fullventas_data/galeria.dart';

class PhotoService {
  static const String baseUrl =
      "http://192.168.18.3/mystore/gull_ventas_php_project/";

  static Future<List<Photo>> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_photos.php"));

      // Imprimir el response completo para depuración
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception(
            "Error al obtener fotos. Código: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en fetchPhotos: $e");
      rethrow;
    }
  }
}
