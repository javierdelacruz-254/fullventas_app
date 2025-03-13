import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Map<String, dynamic>? _userData;

  Future<void> fetchUserData() async {
    final String apiUrl =
        'http://192.168.1.2/gull_ventas_php_project-master/get_user.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        _userData = json.decode(response.body);
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      print('Error en fetchUserData: $e');
    }
  }

  Map<String, dynamic>? get userData => _userData;
}
