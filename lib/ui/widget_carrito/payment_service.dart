import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  // URLs base como constantes
  static const String _baseUrl =
      "http://192.168.18.3/mystore/gull_ventas_php_project";
  final String _paymentEndpoint = "$_baseUrl/procces_payment.php";
  final String _orderEndpoint = "$_baseUrl/insert_order.php";

  // Tiempo de espera para las peticiones HTTP
  final Duration _timeout = const Duration(seconds: 30);

  Future<Map<String, dynamic>> processPayment({
    required int amount,
    required String currency,
    required String email,
    required String sourceId,
    required String firstName,
    required String lastName,
    required String orderUserId,
    required int orderClientId,
    required String orderNoti,
    required Map<String, dynamic> orderSucursal,
    required String orderDistrito,
    required int orderCostoEnvio,
    required int orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    try {
      // 1. Procesar el pago
      final paymentResult = await _processPaymentTransaction(
        amount: amount.toDouble(),
        currency: currency,
        email: email,
        sourceId: sourceId,
        firstName: firstName,
        lastName: lastName,
        orderUserId: orderUserId,
      );

      if (paymentResult['status'] != 'success') {
        return paymentResult;
      }

      // 2. Crear la orden si el pago fue exitoso
      final orderResult = await _createOrder(
        orderUserId: orderUserId,
        orderClientId: orderClientId,
        orderNoti: orderNoti,
        orderSucursalId: orderSucursal['id'],
        orderDistrito: orderDistrito,
        total: amount.toDouble(),
        orderCostoEnvio: orderCostoEnvio,
        orderComisionCulqi: orderComisionCulqi,
        orderedProducts: orderedProducts,
        orderMethod: orderMethod,
        orderStatus: orderStatus,
      );

      return orderResult;
    } catch (e) {
      return {
        "status": "error",
        "message": "Error en el proceso de pago order: ${e.toString()}",
        "error_details": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _processPaymentTransaction({
    required double amount,
    required String currency,
    required String email,
    required String sourceId,
    required String firstName,
    required String lastName,
    required String orderUserId,
  }) async {
    final body = {
      "amount": amount,
      "currency_code": currency,
      "email": email,
      "source_id": sourceId,
      "antifraud_details": {
        "first_name": firstName,
        "last_name": lastName,
      }
    };

    final response = await http
        .post(
          Uri.parse("$_paymentEndpoint?negocio_id=$orderUserId"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      return {
        "status": "error",
        "message":
            "Error en la respuesta del servidor (${response.statusCode})",
        "response_body": response.body,
      };
    }

    final paymentResponse = jsonDecode(response.body);

    if (!paymentResponse.containsKey('authorization_code')) {
      return {
        "status": "error",
        "message": "Fallo en la autorización del pago",
        "payment_response": paymentResponse,
      };
    }

    return {"status": "success", "payment_data": paymentResponse};
  }

  Future<Map<String, dynamic>> _createOrder({
    required String orderUserId,
    required int orderClientId,
    required String orderNoti,
    required String orderSucursalId,
    required String orderDistrito,
    required double total,
    required int orderCostoEnvio,
    required int orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    // Adapting to the table structure from the image
    final body = {
      "color_id": "", // Auto-incremented in database
      "color_method": orderMethod,
      "color_amount": total.toString(),
      "color_costs_envio": orderCostoEnvio.toString(),
      "color_combine_colapid": "", // Not clear from table, leave empty
      "order_user_id": orderUserId,
      "order_sitter_id": orderClientId.toString(),
      "order_status": orderStatus.toString(),
      "date_status": DateTime.now().toString(),
      "status_despancho": "1", // Default value from table
      "order_poll": "NULL", // From table
      "view_poll": "1", // Default value from table
      "order_secreted_id": "", // Not clear from table
      "order_distribo": orderDistrito,
      // Additional fields from the table that might be needed
      "options_no": "", // From table header
      "name_no": "", // From table header
      "name_de_flux": "", // From table header
      "fax": "", // From table header
      "phone_flux": "", // From table header
      "docker_en_esta_tabla": "", // From table header
      "options_segun_la_clave": "", // From table header
      "empresa": "", // From table header
      "ordered_products": orderedProducts,
    };

    try {
      final response = await http
          .post(
            Uri.parse(_orderEndpoint),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }

      final orderResponse = jsonDecode(response.body);

      // Validar que la respuesta contiene los datos esperados
      if (orderResponse['status'] == 'success') {
        return {
          ...orderResponse,
          // Include additional fields from the table if needed
          "order_details": {
            "color_id": orderResponse['color_id'] ?? "",
            "order_distribo": orderDistrito,
            "date_status": DateTime.now().toString(),
          }
        };
      } else {
        throw Exception("Respuesta de orden inválida: ${response.body}");
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Error al crear la orden: ${e.toString()}",
        "error_details": e.toString(),
      };
    }
  }
}
