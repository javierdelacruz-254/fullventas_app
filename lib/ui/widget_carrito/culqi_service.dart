import 'dart:convert';
import 'package:http/http.dart' as http;

class CulqiService {
  String? publicKey;

  Future<void> fetchPublicKey(int usersId) async {
    final url = Uri.parse(
        'http://192.168.18.3/mystore/gull_ventas_php_project-master/get_culqi_keys.php?negocio_id=$usersId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          publicKey = data['data']['llave_publica'];
        } else {
          print(data);
          throw Exception('No se encontró la llave pública');
        }
      } else {
        throw Exception('Error al obtener la llave');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> createToken({
    required int usersId,
    required String cardNumber,
    required String cvv,
    required String expirationMonth,
    required String expirationYear,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    if (publicKey == null) {
      await fetchPublicKey(usersId);
      if (publicKey == null) {
        print("No se pudo obtener la llave pública");
        return null;
      }
    }
    final url = Uri.parse('https://secure.culqi.com/v2/tokens');
    final headers = {
      'Authorization': 'Bearer $publicKey',
      'Content-Type': 'application/json',
    };
    final body = {
      'card_number': cardNumber,
      'cvv': cvv,
      'expiration_month': expirationMonth,
      'expiration_year': expirationYear,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // Retorna el token
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }
}
