import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _baseUrl =
      "http://192.168.18.3/mystore/gull_ventas_php_project";
  static const String _paymentEndpoint = "$_baseUrl/procces_payment.php";
  static const String _orderEndpoint = "$_baseUrl/insert_order.php";
  static const Duration _timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String currency,
    required String email,
    required String sourceId,
    required String firstName,
    required String lastName,
    required String orderUserId,
    required int orderClientId,
    required int orderNoti,
    required Map<String, dynamic> orderSucursal,
    required String orderDistrito,
    required double orderCostoEnvio,
    required double orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    print('[DEBUG] Iniciando processPayment()');
    print('[DEBUG] Datos recibidos:');
    print('- amount: $amount');
    print('- email: $email');
    print('- orderUserId: $orderUserId');
    print('- orderClientId: $orderClientId');
    print('- orderMethod: $orderMethod');
    print('- productos: ${orderedProducts.length}');

    try {
      if (orderedProducts.isEmpty) {
        print('[ERROR] Carrito vacío');
        throw Exception("El carrito de compras está vacío");
      }

      // 1. Procesar pago
      print('[DEBUG] Procesando transacción de pago...');
      final paymentResult = await _processPaymentTransaction(
        amount: amount,
        currency: currency,
        email: email,
        sourceId: sourceId,
        firstName: firstName,
        lastName: lastName,
        orderUserId: orderUserId,
      );

      print('[DEBUG] Resultado de transacción: ${paymentResult['status']}');
      if (paymentResult['status'] != 'success') {
        print('[ERROR] Falló la transacción: ${paymentResult['message']}');
        return paymentResult;
      }

      // 2. Crear orden
      print('[DEBUG] Creando registro de orden...');
      final orderResult = await _insertOrder(
        orderUserId: orderUserId,
        orderClientId: orderClientId,
        orderNoti: orderNoti,
        orderSucursalId: orderSucursal['id'] ?? 0,
        orderDistrito: orderDistrito,
        orderamount: amount,
        orderCostoEnvio: orderCostoEnvio,
        orderComisionCulqi: orderComisionCulqi,
        orderedProducts: orderedProducts,
        orderMethod: orderMethod,
        orderStatus: orderStatus,
      );

      print('[DEBUG] Resultado de orden: ${orderResult['status']}');

      // Intentar extraer el order_id si existe
      final orderId = orderResult['order_id'];

      return {
        "status": orderResult['status'],
        "message": orderResult['message'],
        "order_id": orderId, // Se incluye el order_id si está presente
      };
    } catch (e) {
      print('[EXCEPTION] Error en processPayment: $e');
      return {
        "status": "error",
        "message": "Error en el proceso de pago: ${e.toString()}",
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
      },
      "metadata": {
        "user_id": orderUserId,
      }
    };

    try {
      final response = await http
          .post(
            Uri.parse("$_paymentEndpoint?negocio_id=$orderUserId"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return {
          "status": "error",
          "message": responseData['message'] ??
              "Error en el servidor (${response.statusCode})",
        };
      }

      return {
        "status": "success",
        "payment_data": responseData,
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Error al procesar el pago: ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> _insertOrder({
    required String orderUserId,
    required int orderClientId,
    required int orderNoti,
    required int orderSucursalId,
    required String orderDistrito,
    required double orderamount,
    required double orderCostoEnvio,
    required double orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    print('[PaymentService][DEBUG] Preparando datos para insert_order.php');

    final body = {
      "order_method": orderMethod,
      "order_amount":
          orderamount / 100, // Asegúrate que esta conversión es correcta
      "order_costo_envio": orderCostoEnvio,
      "order_comision_culqui": orderComisionCulqi,
      "order_user_id": int.parse(orderUserId),
      "order_client_id": orderClientId,
      "order_time": DateTime.now().toUtc().toIso8601String(),
      "status": orderStatus,
      "order_noti": orderNoti,
      "order_sucursal_id": orderSucursalId,
      "order_distrito": orderDistrito,
      "ordered_products": orderedProducts
          .map((p) => {
                "id": p['product_id'],
                "qty": p['ordered_quantity'],
                "tipo_categoria": p['tipo_categoria'],
                "previousPrice": p['previousPrice'],
                "name": p['name'],
                "product_size_id": p['product_size_id'],
              })
          .toList(),
    };

    print('[PaymentService][DEBUG] Datos a enviar:');
    print(jsonEncode(body));

    try {
      print('[PaymentService][DEBUG] Enviando petición a $_orderEndpoint');
      final response = await http
          .post(
            Uri.parse(_orderEndpoint),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      print('[PaymentService][DEBUG] Respuesta del servidor:');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final responseData =
          jsonDecode(response.body.isEmpty ? '{}' : response.body);

      if (response.statusCode != 200) {
        print(
            '[PaymentService][ERROR] Error en la respuesta: ${response.statusCode}');
        throw Exception(responseData['message'] ??
            "Error al crear orden (${response.statusCode})");
      }

      return responseData;
    } catch (e, stackTrace) {
      print('[PaymentService][ERROR] Excepción en _insertOrder:');
      print('- Tipo: ${e.runtimeType}');
      print('- Mensaje: $e');
      print('- StackTrace: $stackTrace');
      return {
        "status": "error",
        "message": "Error al crear la orden: ${e.toString()}",
      };
    }
  }
}
