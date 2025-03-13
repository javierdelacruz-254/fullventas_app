import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String backendUrl =
      "http://192.168.1.2/gull_ventas_php_project-master/procces_payment.php"; // Reemplaza con la URL de tu archivo PHP
  final String insertOrderUrl =
      "http://192.168.1.2/gull_ventas_php_project-master/insert_order.php"; // URL del archivo PHP para insertar la orden

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String currency,
    required String email,
    required String sourceId,
    required String firstName,
    required String lastName,
    required String orderUserId, // ID del usuario
    required int orderClientId, // ID del cliente
    required String orderNoti, // Notificación
    required Map<String, dynamic> orderSucursal, // ID de la sucursal
    required String orderDistrito, // Distrito
    required int orderCostoEnvio,
    required int orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
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

    try {
      final response = await http.post(
        Uri.parse("$backendUrl?negocio_id=$orderUserId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final paymentResponse = jsonDecode(response.body);

        if (paymentResponse.containsKey('authorization_code')) {
          // Después de un pago exitoso, enviamos los detalles de la orden
          final orderResponse = await _sendOrderData(
            orderUserId: orderUserId,
            orderClientId: orderClientId,
            orderNoti: orderNoti,
            orderSucursalId: orderSucursal['id'],
            orderDistrito: orderDistrito,
            amount: amount,
            orderCostoEnvio: orderCostoEnvio,
            orderComisionCulqi: orderComisionCulqi,
            orderedProducts: orderedProducts,
            orderMethod: orderMethod,
            orderStatus: orderStatus,
          );
          return orderResponse;
        } else {
          return {"status": "error", "message": "Error al procesar el pago"};
        }
      } else {
        return {
          "status": "error",
          "message": "Error en la respuesta del servidor"
        };
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  // Función para enviar los detalles de la orden a la base de datos
  Future<Map<String, dynamic>> _sendOrderData({
    required String orderUserId,
    required int orderClientId,
    required String orderNoti,
    required String orderSucursalId,
    required String orderDistrito,
    required double amount,
    required int orderCostoEnvio,
    required int orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    final body = {
      "order_user_id": orderUserId,
      "order_client_id": orderClientId,
      "order_noti": orderNoti,
      "order_sucursal_id": orderSucursalId,
      "order_distrito": orderDistrito,
      "amount": amount / 100,
      "order_costo_envio": orderCostoEnvio,
      "order_comision_culqui": orderComisionCulqi,
      "ordered_products": orderedProducts,
      "order_method": orderMethod,
      "order_status": orderStatus,
    };

    print("Enviando datos de la orden: $body");

    try {
      final response = await http.post(
        Uri.parse(insertOrderUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Respuesta de insert_order.php: ${response.body}");

      if (response.statusCode == 200) {
        final orderResponse = jsonDecode(response.body);
        return orderResponse;
      } else {
        return {"status": "error", "message": "Error al insertar la orden"};
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}
